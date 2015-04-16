#!/bin/bash

# If
#   (not within Vagrant Guest OS) and (not within Travis)
# then
#    exit 1

WHOAMI=`whoami`

if [ `whoami` == "travis" ];
then
    BASEDIR=`pwd`
elif [ `facter virtual` == "virtualbox" ];
then
    BASEDIR=/vagrant
else
    echo The command should be executed within the guest OS!
    exit 1
fi

rm -rf /app/symfony2app/app/cache/*

mysql -u root < "${BASEDIR}/00-extra/db/create-empty-database.sql"
php "${BASEDIR}/app/console" doctrine:schema:update --force

/app/symfony2app/vendor/behat/behat/bin/behat $@

sudo chmod -R 0777 /app/symfony2app
sudo chown -R "${WHOAMI}:${WHOAMI}" /app/symfony2app
