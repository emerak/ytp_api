# README

### Project Setup
 clone repository

 create the master key, this is only for this purpose, otherwise it should be
shared in a _secure way_, run in a terminal the following instruction:

`echo 'b662a19720e3f996ce2dd64b2d923844' >> config/master.key`

`bundle install` to install dependencies

`rails db:setup` to create, load schema and seed database

Admin user = admin@test.com, password: adminytp

`rails server` to initiate server

`rspec spec` to run the test suite

documentation is located on `localhost:3000/apipie`
