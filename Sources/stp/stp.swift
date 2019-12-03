import ncurses

public class STP {
    private var wrap: Bool = true
    private var currentLine: Int = 0
    private var lineNumbers: Bool = false
    
    private let text: String

    public init(text: String) {
        self.text = text
        
        /* Boilerplate initialization */
        initscr()
        cbreak()
        noecho()
        
        nonl()
        intrflush(stdscr, false)
        keypad(stdscr, true)
        
        show_interactive()
    }
    
    deinit { endwin() }
    
    private var lines: [String] {
        return text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }
    
    private var lineCount: Int { return lines.count }
    
    public func show_interactive() {
       
        var done: Bool = false
        
        while !done {
            show()
            
            let c: Int32 = getch()
            
            switch c {
            case 0x0B, KEY_UP:
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
                lineNumbers = !lineNumbers
                
            case KEY_RESIZE:
                /* KEY_RESIZE: Do nothing */
                break
                
            default:
                break
            }
            
        }
        
    }

    private func show() {
        clear()
            
        if wrap {
            if (currentLine > lines.count-1) { currentLine = lines.count - 1 }
            let rest = lines[currentLine...lines.count-1].joined(separator: "\n")
            s_printw(rest)
            
        } else {
            /* Clip mode */
            for line in lines[currentLine...lines.count-1] {
                addnstr(String(describing: currentLine) + line + "\n", COLS)
            }
        }
        
        refresh()
    }
    
}
