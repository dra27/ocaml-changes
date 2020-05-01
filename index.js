/**************************************************************************
 *                                                                        *
 *                                 OCaml                                  *
 *                                                                        *
 *                 David Allsopp, OCaml Labs, Cambridge.                  *
 *                                                                        *
 *   Copyright 2020 MetaStack Solutions Ltd.                              *
 *                                                                        *
 *   All rights reserved.  This file is distributed under the terms of    *
 *   the GNU Lesser General Public License version 2.1, with the          *
 *   special exception on linking described in the file LICENSE.          *
 *                                                                        *
 **************************************************************************/

const core = require('@actions/core');
const github = require('@actions/github');
const exec = require('@actions/exec');
const path = require('path');

async function run () {
  try {
    let script = path.join(__dirname, 'changes.sh');
    let args = [github.context.payload.pull_request.base.sha,
                github.context.payload.pull_request.head.sha,
                github.context.payload.pull_request.head.ref];
    let code = await exec.exec(script, args);
    if (code !== 0) {
      core.setFailed('An entry needs adding to the Changes file!');
    }
  } catch (e) {
    core.setFailed(e.message);
  }
}

run ();
