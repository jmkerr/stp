import stp

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

let page = STP(wrap: true, lineNumbers: true)

page.showInteractive(text: text)
