deploy
======

This is collection of deploy tools.

Since there are different mechanisms which differ very much from each other, 
each subdirectory contains a specific "method" for deployment. 
Further details about the specific deployment method is described in the respective README files 
in the subdirectories.


Directory | Description 
----------|------------
`git-hook` | deployment triggered by git-push
`stage-to-production` | copy staged applications to the production site
`copy-to-server` | copy applications from local workspace to a remote site
