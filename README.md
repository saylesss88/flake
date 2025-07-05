1. Start work by describing it

```bash
jj log
@  ywnkulko steve@steveklabnik.com 2024-02-28 20:40:00.000 -06:00 46b50ed7
│  (empty) (no description set)
◉  puomrwxl steve@steveklabnik.com 2024-02-28 20:38:13.000 -06:00 7a096b8a
│  it's important to comment our code
◉  yyrsmnoo steve@steveklabnik.com 2024-02-28 20:24:56.000 -06:00 ac691d85
│  hello world
◉  zzzzzzzz root() 00000000
```

Describe the work you want to do:

```bash
jj desc -m "adding jj completions to zsh and a workflow README"
```

2. Create a new empty change

```bash
jj new
Working copy  (@) now at: nnkyszrx b86466e3 (empty) (no description set)
Parent commit (@-)      : nsrpsrvs 88d5cbb0 adding jj completions to zsh and a workflow README
```

Now we have an empty change on top of our commit that we just described.

3. Make your changes

```bash
hx README.md
jj st
Working copy changes:
M README.md
Working copy  (@) : nnkyszrx 0b9cd23b (no description set)
Parent commit (@-): nsrpsrvs 88d5cbb0 adding jj completions to zsh and a workflow README
```

Our Working copy shows changes `M README.md` and our Working copy (@): nnk 0b9
Parent commit (@-): nsr 88d
