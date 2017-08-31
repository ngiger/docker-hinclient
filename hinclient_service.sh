#!/bin/sh
/bin/mkdir -p /tmp/redmine
chown -R www-data /var/www/redmine/ngiger /tmp/redmine
cd /var/www/redmine/ngiger
if [[ -f Gemfile.lock ]]; then
  sudo -u www-data /usr/local/bin/bundle install --deployment  --without rmagic
else 
  sudo -u www-data /usr/local/bin/bundle install --without rmagic
fi
exec /sbin/setuser www-data /usr/local/bin/bundle exec rails server -e production -p 3333 --pid=/tmp/redmine/server.pid >>/var/log/redmine.log 2>&1

