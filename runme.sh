#!/bin/bash
rm -fr css fonts images lang lib o2c.html swagger-ui.* index.html

if [ ! -f rest_api.json ]; then
    echo "Downloading rest_api.json from GitHub hyperledger/fabric repository"
    curl -XGET https://raw.githubusercontent.com/hyperledger/fabric/master/core/rest/rest_api.json --output rest_api.json
    if [ $? -eq 0 ]; then
      echo OK
    else
      echo "Unable to download rest_api.json"
      exit 1
    fi
fi

which npm
if [ $? -eq 1 ]; then
  echo "Node.js/npm not installed. Please visit https://nodejs.org/en/ and install Node.js"
  exit 1
fi

export PATH=./node_modules/.bin:$PATH
which http-server
if [ $? -eq 1 ]; then
  npm install http-server
  if [ $? -eq 1 ]; then
    echo "Unable to install http-server npm module"
    exit 1
  fi
fi

if [ ! -f swagger-ui/dist/index.html ]; then
  git clone https://github.com/swagger-api/swagger-ui.git
  if [ $? -eq 1 ]; then
    echo "Unable to clone swagger-ui"
    exit 1
  fi
fi

cp -r swagger-ui/dist/* .
rm index.html
cp replace.html index.html

http-server -a 0.0.0.0 -p 5554 -o --cors
exit $?
