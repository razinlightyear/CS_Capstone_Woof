# README


* Ruby version  
```
$ ruby -v
ruby 2.4.0p0 (2016-12-24 revision 57164) [x86_64-darwin16]
```
* Rails version  
```
$ rails -v
Rails 5.0.2
```
* System dependencies

## Configuration  
  **Mac**  
  Install brew  
	• Go to https://brew.sh/  
	• Paste the line in terminal and follow the directions

  _Install rvm (ruby version manager)_  
`$ curl -L get.rvm.io | bash`  
	Make sure this line is in your `~/.profile` so that it's loaded for every terminal session  
`[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"`  

  _Install the latest stable version of ruby (as of 3/12/2017)_  
	`$ rvm install 2.4.0`  
  _Create a gemset for our application (Do this so that you can isolate your ruby dependencies)_  
	`$ rvm gemset create woof`  
  _Switch to the woof gemset_  
	`$ rvm use 2.4.0@woof`  

  _Install Rails!_  
	`$ gem install rails -v 5.0.2`

  _Get the Codes_  
	• Fork the repo https://github.com/andycho7/CS_Capstone_Woof  
	• Navigate to where you want the project  
	• Clone the forked repo  
  
  **Ubuntu**
  Install brew  
	• http://linuxbrew.sh/
	• Paste the line in terminal and follow the directions

  sudo apt-get curl
  
## Database creation

## Database initialization
  Start mysql
  mysql.server start
## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

