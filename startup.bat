REM Windows shell script to initialize base box
REM not sure how/if this runs as PowerShell

vagrant destroy base -f
del package.box
vagrant up base
vagrant package base
vagrant box add opscode-ubuntu-14.04a package.box -f
del package.box
vagrant destroy base -f