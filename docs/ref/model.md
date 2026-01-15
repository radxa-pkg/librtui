# Display Model

`librtui` implements a stack based scene managament. Each scene is called `screen`
and is stored in `RTUI_SCREEN` stack. `tui_start` creates the main loop that shows
the `screen` from top of the stack, automatically pop the stack, and repeat. This
allows the leaf scene to work without any specific scene management, and let
`librtui`'s other components to handle it.

It is important that stack poping does not pop the current showing `screen`, but
only the top of the stack. This allows `screen` to manipulate the `screen` stack
to control the scene when necessary.

The most common operation is provided by `push_screen`. This pushes a new `screen`
as well as a dummy `screen`. This way, the main loop will unload the dummy `screen`
and show new `screen` next. When new `screen` exits, the user will return to the
original `screen` to make another selection. This function is used by `menu_show`
to provide multi-level menu system.

Less used option includes `switch_screen`, which pops top `screen` before calling
`push_screen`. `menu_show` calls this function if only a single item is listed
in the menu. This allows the new `screen` to return 1 extra level when finished,
since returing to the direct parent `screen` will cause a dead loop back to the
new `screen`.

Please be aware than a scene/`screen` is different from what user is interacting.
A `screen` can consist multiple TUI dialogs, or only one dialog. `librtui` applications
usually consist many `screens` with only a single menu dialog to create a multi-level
menu system, and some leaf `screens` with multiple dialogs to perform the actual
work. If you want the user to be able to return to it at some point, then you
will need to create a new `screen`.
