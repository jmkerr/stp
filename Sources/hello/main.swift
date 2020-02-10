import stp

/// Iterates the program state based on viewport dimensions, frame, and last key press

func slDemo() {
    let page = STP(wrap: false, lineNumbers: false)

    page.startDelayed(delay: 1)

    var c = 0, n = 0, d = 0
    while c != 27 {
        let dim = page.dimensions
        var text = dim.1/2 + (dim.1) % 2 - 5 < 0 ? "Window too small\n" :
            "".padding(toLength: dim.1 / 2, withPad: "\n", startingAt: 0)
            + ["____", "|DD|____\(d)", "|_ |_____|<", "  @-@-@-oo\\"].reduce("", {
                $0 + "".padding(toLength: n % (dim.0 - 2), withPad: " ", startingAt: 0)
                + $1.padding(toLength: dim.0 - 2, withPad: " ", startingAt: 0) + "\n" })
            + "".padding(toLength: dim.1/2 + (dim.1) % 2 - 5, withPad: "\n", startingAt: 0)
        text += "delayed mode (\(dim.0) cols, \(dim.1) rows), frame \(n), last key \(c), press [ESC] to proceed."
        c = page.stepDelayed(text: text)
        d = c == -1 ? d : c
        n += 1
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
