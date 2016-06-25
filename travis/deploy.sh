# Decrypt the deploy key
openssl aes-256-cbc -K $encrypted_e96b6cd79886_key -iv $encrypted_e96b6cd79886_iv
  -in travis/deploy_key.enc -out travis/deploy_key -d
chmod 600 travis/deploy_key

# Set up SSH
eval "$(ssh-agent -s)"
ssh-add travis/deploy_key
ssh-keyscan evabot.io >> ~/.ssh/known_hosts

# Push to production
git remote add production deploy@evabot.io:evabot.git
git push -f production master

