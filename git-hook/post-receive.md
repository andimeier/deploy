post-receive hook
=================

Performs the following steps:

1. extract master branch with `git archive` to a temporary directory
2. "build" the app in the temporary directory
3. add version file (includes version info and deploy timestamp)
4. copy to application folder, into a timestamped directory
5. add target specific config file
6. modify the symlink 'app' in the application folder so that it points to the newly deployed version

Suggestions
-----------

* use deploy branch or at least make the branc configurable
