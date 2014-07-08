The directory `git-hook` contains hook scripts which deploy the app as soon as something is pushed against the repo.

Depending on the flavor of the application, there are different types of 
hook scripts:

* **post-receive-nodejs** for *node.js* applications

## post-receive-nodejs

A post-receive hook for node.js apps.

Performs the following steps:

1. extract master branch with `git archive` to a temporary directory
2. build the app in the temporary directory (`npm install`)
3. add version file (includes version info from ``package.json`` and deploy timestamp)
4. copy to application folder, into a timestamped directory
5. add target specific config file
6. modify the symlink `app` in the application folder so that it points to the newly deployed version
7. restart the app service (with ``sudo``)

### Install

To enable the deploy hook for a repo:

1. copy the script `post-receive` to the `GIT_DIR/hooks` folder, set chmod to 755.
2. add a `config.sh` file in the same directory (you can use the file `config.sh.sample` as a template). This should be populated with the actual configuration values.
3. make sure the deploy user has sufficient access right:
  * user can create a new directory in the deployment directory
  * user has sudo rights to restart the app service

**Note:** you may have to do a `fromdos` for the shell script to run smoothly without warnings.

### Suggestions

* use deploy branch or at least make the branch configurable
