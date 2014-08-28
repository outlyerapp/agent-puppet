dataloop-agent puppet module
============================


Add the dataloop directory to your modules in your puppet repo. We suggest this is added to your base module, or something that runs at the very beginning.

Update init.pp with a non root user and also your dataloop api key. We don't create any users in this module as often people have a way to create those. We suggest creating a 'dataloop' user account.

#Tags

After the agent has run once (to generate a fingerprint) you can run the following command to add tags.

/usr/local/bin/dataloop-lin-agent -a [api key] -s https://www.dataloop.io --add-tags [tag1,tag2,tag3]

You can sprinkle these around your various modules so that dataloop dynamically updates on puppet runs. You can also use --remove-tags to take tags away.
