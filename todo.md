# Some things that are bothering me

## General file editing flow

- Do I really need two file explorers? I see myself using both the snacks one
  and yazi. Usually one or another is not enough to look through a project
  quickly, or to find files quickly, or to create or move files or directories.

- `nvim-surround` is borderline unusable due to the mental overhead of
  selecting a proper range and having to type out `gzc)]` or whatever.

- I usually underutilize `nvim-ufo` (although it's a nice tool for showcasing a
  file), `grapple.nvim` and built-in marks. Maybe I would enjoy `marko.nvim` or
  alternatives instead of `grapple`.

- It turns out that I sometimes would like to disable file formatting. This is
  easy on itself, but it would be nice for `conform` to remember whether it should
  format stuff after I relaunch nvim.

- Also, relaunching nvim: `rust-analyzer` does NOT want me to. This thing takes
  up AGES to load my Rust project again. It looks like I should treat nvim as an
  actual IDE that I launch once and reuse. That would mean relying on floating
  terminals instead of ctrl-z-ing, using a separate terminal for commands
  alongside something like Neovide, or learning a terminal multiplexer which
  hurts my head.

- I don't really use `declancm/maximize.nvim`. I ditched tpope's maximizer
  because it didn't work on lists and floating windows, only to never ever
  maximize lists or floating windows. His plugin is dead simple and works like a
  charm. I remember spending multiple nights looking for an alternative.

## Plugin configuration improvements

- I rarely use other colorschemes, and I don't think it's a good idea to preload
  them all at once. I wish there was a plugin that eagerly loads the current
  selected theme and disables all the others completely.

- `ultimate-autopair.nvim` does lots and lots of stuff I don't understand, but
  at least it doesn't bother me as much as `mini.pairs` did.

  Specifically, it auto-erases the closing symbol, which is a problem for
  generics in Rust, such as `fn foo(a: Option<T>) -> U`, where erasing the `<`
  next to `Option` erases part of the arrow. But then I kinda started relying
  on it for more complicated parentesis pairs, so I would only like to disable
  it for `<>`?

- `blink.cmp` completion acceptance sometimes overwrites entire words, or
  brackets, or semicolons after the accepted text.
