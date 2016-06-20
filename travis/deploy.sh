source ~/.bash_profile

cd /home/deploy/evabot 
git fetch --all
git reset --hard origin/master

cd rails
bundle install
rails db:create db:migrate
rvmsudo bin/rails server --daemon -p 80 -b 0.0.0.0
