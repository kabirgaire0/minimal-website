**Simple website project template**


## Process

Use this template to create simple website projects
Use Linode Server
Setup SSH connection
SCP this project folder to the linode server
Serve the project using http-server from npm


# Add SSH public key using 
```
echo "public key here" >> ~/.ssh/authorized_keys
```

# SSH to the server
```
ssh -t root@ip-address
```

# Install npm
```
apt update && apt install npm@latest
```

# Install http-server with npm
```
npm install -g http-server
```

# Serve the project using https-server
```
http-server /root/minimal-project/index.html
```



# 
```
http-server
```

## using :
    npm
    nvm
    http-server

serving at port 8080


