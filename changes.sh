#!/usr/bin/env bash
#**************************************************************************
#*                                                                        *
#*                                 OCaml                                  *
#*                                                                        *
#*                 David Allsopp, OCaml Labs, Cambridge.                  *
#*                                                                        *
#*   Copyright 2020 MetaStack Solutions Ltd.                              *
#*                                                                        *
#*   All rights reserved.  This file is distributed under the terms of    *
#*   the GNU Lesser General Public License version 2.1, with the          *
#*   special exception on linking described in the file LICENSE.          *
#*                                                                        *
#**************************************************************************

set -e

#------------------------------------------------------------------------
#This test checks that the Changes file has been modified by the pull
#request. Most contributions should come with a message in the Changes
#file, as described in our contributor documentation:
#
#  https://github.com/ocaml/ocaml/blob/trunk/CONTRIBUTING.md#changelog
#
#Some very minor changes (typo fixes for example) may not need
#a Changes entry. In this case, you may explicitly disable this test by
#adding the code word "No change entry needed" (on a single line) to
#a commit message of the PR, or using the "no-change-entry-needed" label
#on the github pull request.
#------------------------------------------------------------------------

CUR_HEAD="$1"
PR_HEAD="$2"
BRANCH="$3"

# The checkout is almost certainly shallow - deepen it until the merge-base is
# present.
DEEPEN=50
while ! git merge-base "$CUR_HEAD" "$PR_HEAD" >& /dev/null
do
  echo "Deepening $BRANCH by $DEEPEN commits"
  git fetch origin --deepen=$DEEPEN HEAD
  ((DEEPEN*=2))
done
MERGE_BASE=$(git merge-base "$CUR_HEAD" "$PR_HEAD")

CheckNoChangesMessage () {
  if [[ -n $(git log --grep='[Nn]o [Cc]hange.* needed' --max-count=1 \
    "$MERGE_BASE..$PR_HEAD") ]] ; then
    echo '"No change needed" found in a commit message'
  else
    echo 'An entry needs adding to the Changes file!'
    exit 1
  fi
}

# Check that the Changes file has been modified
git diff "$MERGE_BASE..$PR_HEAD" --name-only --exit-code \
  Changes > /dev/null && CheckNoChangesMessage || \
  echo 'Branch updates Changes file'
