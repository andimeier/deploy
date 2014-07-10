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

1. set up a bare repo on the deployment target host ``git init --bare PROJECT_NAME``. This is the *deployment repo*.
1. in the deployment repo, copy the script `post-receive` to the `GIT_DIR/hooks` folder, set chmod to 755.
1. add a `config.sh` file in the same directory (you can use the file `config.sh.sample` as a template). This should be populated with the actual configuration values.
1. make sure the deploy user has sufficient access right:
  * user can create a new directory in the deployment directory
  * user has sudo rights to restart the app service

To enable access from your local (working dir) repo to the remote deployment repo: 

1. in the local (working dir) git repo, add a git remote *deploy*. This will be the target for deployment pushes:
	``git remote add deploy DEPLOY_GIT_REPO``

### Workflow

The intended workflow is as follow:

1. in your working directory repo, make sure you reference the revision you would like to deploy (by committing latest changes or checking out the desired revision or whatever)
2. ``git push deploy``


**Note:** you may have to do a `fromdos` for the shell script to run smoothly without warnings.

### Suggestions

* use deploy branch or at least make the branch configurable, so it is not necessary to always use the master branch
