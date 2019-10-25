# Docker container - Ubuntu for RPA (with VNC)


The docker image contains the following components:

* NodeJS 12 + npm
* Python (2.7 e 3.6) + pip
* Desktop environment [**Xfce4**](http://www.xfce.org)
* VNC-Server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* Browsers:
  * Mozilla Firefox
  * Google Chrome
  
## Usage


- Run command with mapping to local port `5901` (vnc protocol) and `6901` (vnc web access):

      docker run -d -p 5901:5901 -p 6901:6901 delpinos/ubuntu-xfce-vnc-rpa 
  
- If you want to get into the container use interactive mode `-it` and `bash`
      
      docker run -it -p 5901:5901 -p 6901:6901 delpinos/ubuntu-xfce-vnc-rpa  bash

- Build an image from scratch:

      docker build -t delpinos/ubuntu-xfce-vnc-rpa  ubuntu-xfce-vnc-rpa 

# Connect & Control
If the container is started like mentioned above, connect via one of these options:

* connect via __VNC viewer `localhost:5901`__, default password: `vncpassword`
* connect via __noVNC HTML5 full client__: [`http://localhost:6901/vnc.html`](http://localhost:6901/vnc.html), default password: `b045e0c5e8f9a2c87ac19512f6e0f7e5` 
* connect via __noVNC HTML5 lite client__: [`http://localhost:6901/?password=vncpassword`](http://localhost:6901/?password=vncpassword) 


## Hints

### 1) Override VNC environment variables
The following VNC environment variables can be overwritten at the `docker run` phase to customize your desktop environment inside the container:
* `VNC_COL_DEPTH`, default: `32`
* `VNC_RESOLUTION`, default: `1280x720`
* `VNC_PW`, default: `b045e0c5e8f9a2c87ac19512f6e0f7e5`

#### Example: Override the VNC password
Simply overwrite the value of the environment variable `VNC_PW`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_PW=my-pw delpinos/ubuntu-xfce-vnc-rpa 

#### Example: Override the VNC resolution
Simply overwrite the value of the environment variable `VNC_RESOLUTION`. For example in
the docker run command:

    docker run -it -p 5901:5901 -p 6901:6901 -e VNC_RESOLUTION=800x600 delpinos/ubuntu-xfce-vnc-rpa 
    
#### Example: View only VNC

     docker run -it -p 5901:5901 -p 6901:6901 -e VNC_VIEW_ONLY=true delpinos/ubuntu-xfce-vnc-rpa 

## Changelog

The current changelog is provided here: **[changelog.md](./changelog.md)**