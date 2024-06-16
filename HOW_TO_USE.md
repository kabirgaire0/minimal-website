# Setup env
```
cp  .env.example .env
```

add your id_address & project name on .env

copy your website to project-files/

# Setup SSH connection on the server
```
echo "public_key_here" >> ~/.ssh/authorized_keys
```

# Setup Server using SSH
```
ssh -t root@ip-address apt update && \
apt install -y npm && \
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash && \
export NVM_DIR="$HOME/.nvm" && \
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" && \
nvm install --lts && \
nvm use --lts && \
npm install -g http-server && \
http-server /root/minimal-website
```

# Run deploy.sh script
```
./deploy.sh
```
