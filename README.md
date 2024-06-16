**Simple website project template**


# Run deploy.sh script
```
./deploy.sh
```


# Process

Use this template to create simple website projects
Use Linode Server
Setup SSH connection
SCP this project folder to the linode server
Serve the project using http-server from npm

# using :
    ssh
    scp
    npm
    nvm
    http-server

# Add SSH public key using 
```
echo "public key here" >> ~/.ssh/authorized_keys
```

# SCP Project folder to the linode server
```
scp -rf /project-directory root@ip-address:/root/ 
```

# Setup using Command
```
apt update && \
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

# SSH to the server
```
ssh -t root@ip-address
```

# Install npm
```
apt update && apt install npm@latest
```

# Install nvm
```
apt update &&
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash && source ~/.nvm/nvm.sh
```

# Install Latest LTS npm version
```
nvm install --lts &&
nvm use --lts 
```

# Install http-server with npm
```
npm install -g http-server
```

# Serve the project using https-server
```
http-server /root/minimal-project
```
