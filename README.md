# example

https://github.com/cideM/co_log_issue
https://stackoverflow.com/questions/65599741/how-to-make-co-logs-withlog-work-with-scotty

*Solved by https://github.com/cideM/co_log_issue/pulls?q=is%3Apr+is%3Aclosed*

## Instructions

You can just run `stack build` to see if it compiles or for a faster feedback loop

```shell
$ nix-shell
$ ghcid "--command=stack ghci"
```

Sorry for having this be a plain stack project but at the time of writing `co-log` is broken in Nixpkgs (I'm fixing this) and `Haskell.nix` is broken on MacOS :(
