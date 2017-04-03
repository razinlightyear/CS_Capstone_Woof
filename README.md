# README

## Configuration  
  **Mac**  
  _Install brew_  
  * `$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"` https://brew.sh/  

  _Install rvm (ruby version manager)_  
* `$ curl -L get.rvm.io | bash`  
* Make sure this line is in your `~/.profile` so that it's loaded for every terminal session:  
   `[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"`  
  _Install the latest stable version of ruby (as of 3/12/2017)_  
	`$ rvm install 2.4.0`  
  _Create a gemset for our application (Do this so that you can isolate your ruby dependencies)_  
	`$ rvm gemset create woof`  
  _Switch to the woof gemset_  
	`$ rvm --default use 2.4.0@woof`  
  _Database initialization_  
* Follow the Database initilaization below  
  _Install Rails!_  
	`$ gem install rails -v 5.0.2`
  _Database creation_  
* Follow the Database creation below
  _Get the Codes_  
	• Fork the repo https://github.com/andycho7/CS_Capstone_Woof  
	• Navigate to where you want the project  
	• Clone the forked repo  
  
  **Ubuntu**  
  _Install a version of ruby to get going_ (as described at https://www.ruby-lang.org/en/documentation/installation/)  
	 `$ sudo apt-get install ruby-full`  
  _Install brew_  
	• http://linuxbrew.sh/  
	• Paste the commands in terminal and follow the directions  
  _Install curl_ (used by RVM)  
	`$ sudo apt-get curl`  
  _Install rvm (ruby version manager)_  
`$ curl -L get.rvm.io | bash`  
	Make sure this line is in your `~/.profile` so that it's loaded for every terminal session  
`[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"`  
  _Database initialization_
  * Follow the Database initilaization below  
  _Install the latest stable version of ruby (as of 3/12/2017)_  
	`$ rvm install 2.4.0`  
  _Create a gemset for our application (Do this so that you can isolate your ruby dependencies)_  
	`$ rvm gemset create woof`  
  _Switch to the woof gemset_  
	`$ rvm use 2.4.0@woof`  

  _Install Rails!_  
	`$ gem install rails -v 5.0.2`
  _Database creation  
  * Follow the Database creation below
  _Get the Codes_  
	• Fork the repo https://github.com/andycho7/CS_Capstone_Woof  
	• Navigate to where you want the project  
	• Clone the forked repo  
## Database creation
In your rails app directory, run the database migration  
* `$ rails db:create`  
* `$ rails db:migrate`  
#### db commands  
* `$ rails db:drop && rails db:create && rails db:migrate && rails db:seed` I've had problems reseting the db so I've used this command
* `$ rails db:migrate` runs (single) migrations that have not run yet.  
* `$ rails db:create` creates the database  
* `$ rails db:drop` deletes the database  
* `$ rails db:schema:load` creates tables and columns within the (existing) database following schema.rb  
* `$ rails db:setup` does db:create, db:schema:load, db:seed  
* `$ rails db:reset` does db:drop, db:setup  
* `$ rails db:seed` this populates the database with stuff in the db/seed.rb  
## Database initialization
Install mysql with brew (follow the configuration process above to install brew)  
  	`$ brew install mysql`  
  _Start mysql_  
  	`$ mysql.server start`  
_MySQL Client_  
	I recommend that mac users use Sequel Pro, https://www.sequelpro.com/ , since it is simple and powerful.  
	After you have run the database migration to create the database, setup a socket conection with username as root and database as woof_development.  
	The database credentials are saved in app/config/database.yml  
## Common commands  
* Run rails server  
`$ rails s` make sure your in the application directory  
The server is accepting requests at localhost:3000  
* Run rails console  
`$ rails c` make sure your in the application directory
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

## How to run the test suite

## Services (job queues, cache servers, search engines, etc.)

## Deployment instructions

