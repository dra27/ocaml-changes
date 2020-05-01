# OCaml Changes Log Action

This GitHub Actions action tests whether Pull Requests to
[ocaml/ocaml](https://github.com/ocaml/ocaml) have updated the Changes file with
details of the improvement made in the branch or noted in at least one of the
commits that no alteration is necessary.

The action must be invoked from within the Git clone (you will almost certainly
need [actions/checkout](https://github.com/actions/checkout) first) and is only
valid for `pull_request` events.
