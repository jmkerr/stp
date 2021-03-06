import Foundation
import ncurses

public class STP {
    private var wrap: Bool
    private var currentLine: Int = 0
    private var showLineNumbers: Bool
    
    private var rawLines: [String] = []
    private var lineCount: Int { return lines.count }
    
    public var dimensions: (Int, Int) { return (Int(COLS) - 1, Int(LINES)) }

    public init(wrap: Bool = true, lineNumbers: Bool = true, delay: Int = 100) {
        self.wrap = wrap
        self.showLineNumbers = lineNumbers
        
        /* Boilerplate initialization */
        initscr()
        noecho()
        nonl()
        intrflush(stdscr, true)
        keypad(stdscr, true)
        curs_set(0)
        
        setDelay(delay)
    }
    
    deinit { endwin() }
    
    /* Dynamic text processing */
    private var lines: [String] {
        let rightColumIndex = Int(COLS) - (showLineNumbers ? 5 : 0) - 1
        
        /* Clip or Wrap Lines, with optional line numbers */
        var cwLines: [String] = []
        if !wrap {
            cwLines = rawLines.enumerated().map{
                (showLineNumbers ? String(format: "%4d ", $0) : "") + String($1.prefix(rightColumIndex))
            }
        }
        else {
            for (n, line) in rawLines.enumerated() {
                var line = line
                let prefix = showLineNumbers ? String(format: "%4d ", n) : ""
                while line.count > rightColumIndex {
                    cwLines.append(prefix + String(line.prefix(rightColumIndex)))
                    line.removeFirst(rightColumIndex)
                }
                cwLines.append(prefix + line)
            }
        }

        return cwLines
    }
    
    public func setDelay(_ delay: Int) { timeout(Int32(delay)) }
    
    public func stepDelayed(text: String) -> Int {
        /* Initial text processing */
        self.rawLines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        
        show()
        return Int(getch())
    }
    
    public func showInteractive(text: String) {
        /* Initial text processing */
        self.rawLines = text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
        
        setDelay(-1)
       
        var done: Bool = false
        
        while !done {
            show()
            
            let c: Int32 = getch()
            
            switch c {
            case 0x6B, KEY_UP:
                /* k, Arrow up: Scroll up by one row */
                currentLine = max(currentLine - 1, 0)
            
            case KEY_PPAGE:
                /* Page up: Scroll up by a lot */
                currentLine = max(currentLine - Int(LINES), 0)
                
            case KEY_HOME:
                /* Home: Scroll up all the way */
                currentLine = 0
                
            case 0x6A, KEY_DOWN:
                /* j, Arrow down: Scroll down by one row */
                currentLine = min(currentLine + 1, lineCount - 1)
                
            case KEY_NPAGE:
                /* Page down: Scroll down by a lot */
                currentLine = min(currentLine + Int(LINES), lineCount - 1)
            
            case KEY_END:
                /* Home: Scroll down all the way */
                currentLine = lineCount - 1
                
            case 0x71, 0x51, 0x1B:
                /* q, Q, ESC: Quit */
                done = true
            
            case 0x77:
                /* w: Toggle Wrap/Clip */
                wrap = !wrap
                
            case 0x6E:
                /* n: Toggle line numbers */
                showLineNumbers = !showLineNumbers
                
            case KEY_RESIZE:
                /* KEY_RESIZE: Do nothing */
                break
                
            default:
                break
            }
        }
    }

    private func show() {
        let allLines = lines
        currentLine = min(currentLine, allLines.count - 1)
        let rest = allLines[currentLine...allLines.count-1].joined(separator: "\n")
        
        clear()
        s_printw(rest)
        refresh()
    }
    
}
