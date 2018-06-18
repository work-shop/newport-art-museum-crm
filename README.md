# Newport Art Museum CRM Application

## Dev, Build and Test

To create a new scratch org to work in, run:

```sh
sfdx force:org:create -s -f config/project-scratch-def.json -a NewportArtMuseumCRM_Test
```

This will create a scratch org for development work, and set it as the default org for `sfdx` commands.. Following this, push the current state of your codebase to the newly-created org with:

```sh
sfdx force:source:push
```

This pushes the current codebase state to the default scratch org.

## Resources


## Description of Files and Directories


## Issues
