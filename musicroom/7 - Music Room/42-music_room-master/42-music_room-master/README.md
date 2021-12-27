# <p align="center"> Music room </p>

* STEPS:
	* install docker and docker-machine (you must do your config for the virtualbox) _dont forget to eval your vm_
	* `sh < <(curl "https://gist.githubusercontent.com/smurfy92/b72e24f04a7a96efa262a366c9628175/raw/9d988b733a2cabb54ed339dea17c47e2d6e7a568/42_symlinks")` _run one time this script to create symslinks on your sgoinfre_
	* cp config/config_dev.json config/config.json _and add all credentials_
	* docker-compose up --build
	* to launch the react-front `cd react-front && npm install && npm start` (dont forget to install globally react-scripts `npm install -g react-scripts`)

* ACCESS THE CONTAINER:
	* docker exec -it c79bf5491c08 /bin/bash

