import stp

/// Iterates the program state based on viewport dimensions, frame, and last key press

func slDemo() {
    let page = STP(wrap: false, lineNumbers: false)

    page.startDelayed(delay: 1)

    var c = 0, n = 0, d = 0
    while (n += 1, d = c == -1 ? d : c, c).2 != 0x1B {
        let (x, y) = page.dimensions
        let text = y < 5 ? "Window too small\n" : ["____", "|DD|____\(d)", "|_ |_____|<", "  @-@-@-oo\\"].reduce(
            String(repeating: "\n", count: y / 2 - 2), { $0 + String(repeating: " ", count: n % x) + $1 + "\n" })
            + String(repeating: "\n", count: y / 2 + y % 2 - 3)
            + "delayed mode (\(x) cols, \(y) rows), frame \(n), last key \(c), press [ESC] to proceed."
        c = page.stepDelayed(text: text)
    }
    
    page.endDelayed()
}

/// Handle input automatically

func staticDemo() {
    let text = """
    Swift Terminal Pager
    ====================

    * Use the arrow keys, j, and k to navigate by row.

    * Use PgUp, PgDn to navigate fast.

    * Use Home and End to navigate to the beginning and the end.

    * Use n to toggle line numbers at the beginning of each line.

    * Use w to toggle between wrapping and clipping of long lines.

    * Use q, Q, Esc to quit.
    """

    STP(wrap: true, lineNumbers: true).showInteractive(text: text)
}

slDemo()
staticDemo()
