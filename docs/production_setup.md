## Getting help
[![Join our Slack!](https://img.shields.io/badge/slack-join%20us!-e01563.svg)](http://slack.evabot.io)
[![Open issue](https://img.shields.io/badge/report-issue-yellow.svg)](https://github.com/macaullyjames/evabot/issues/new)
[![Edit page](https://img.shields.io/badge/edit-page-lightgrey.svg)](https://github.com/macaullyjames/evabot/edit/master/README.md)

As always, you can ask for help in the #help channel on Slack (the above badge
will take you to a sign-up form if you haven't joined our team already). If
the documentation is incorrect/incomplete and you want to help out then open an
issue in the issue tracker describing the problem. Of course, PRs are welcome
too ❤️

## Setting up a production environment
1. Spin up a DO droplet, adding your SSH key in the setup.
2. Point the `evabot.io` domain to the droplet's ip. This can take up to 30
   mins. Don't proceed until you can `ssh root@evabot.io`!
3. Create the `deploy` user:

  ```bash
  adduser deploy sudo
  ```
4. Run the following as the `deploy` user:

  ```bash
  sudo apt-get update -y
  sudo apt-get install git cmake -y
  gpg --keyserver hkp://keys.gnupg.net \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  curl -sSL https://get.rvm.io | bash -s stable --ruby
  source ~/.rvm/scripts/rvm
  git clone https://github.com/macaullyjames/evabot.git --bare
  ```
  
5. Create `~/evabot.git/hooks/post_receive`:

  ```bash
   git --work-tree=/home/deploy/evabot \
       --git-dir=/home/deploy/evabot.git checkout -f
   
   cd /home/deploy/evabot/rails
   
   bundle install
   sudo kill $(sudo lsof -i tcp:80 -t)
   RAILS_ENV=production rails db:migrate assets:precompile
   rvmsudo \
     RAILS_SERVE_STATIC_FILES=true \
     SECRET_KEY_BASE=`rails secret` \
     GITHUB_CLIENT_ID="d8d0b61ac86f56b38ad3" \
     GITHUB_CLIENT_SECRET="<secret>" \
     rails server --daemon -e production -p 80 -b 0.0.0.0
  ```
  Then run `chmod +x ~/evabot.git/hooks/post-receive` to make the script
  executable.

6. Travis should now deploy whenever a `master` build passes. If you want to
   start the server right away just run `~/evabot.git/hooks/post-receive`
   manually.

Wow, this really needs to be automated.
