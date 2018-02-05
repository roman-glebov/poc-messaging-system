# Messaging System PoC

## How to install:

In order to clone repository with submodules content, execute this command:

```
git clone --recursive git@github.com:roman-glebov/poc-messaging-system.git
```

Add ruby 2.3.1 into rvm if you haven't:

```
rvm install ruby-2.3.1
```

Add new gemset:

```
rvm gemset create messaging-poc
```

Switch to any of the directories and check if app uses proper ruby and gemset:

```text
cd fake_cf_api
rvm gemset list
```

If not, switch to it manually:

```text
rvm use 2.3.1@messaging-poc
```

Now you need to install Postgresql and RabbitMQ:

```text
brew update
brew install postgresql rabbitmq
```

Start the Postgresql:

```text
brew services start postgresql        
```

Enable RabbitMQ Management plugin:

```text
rabbitmq-plugins enable rabbitmq_management
```

Start RabbitMQ:

```text
brew services start rabbitmq
```

You can open web interface locally on port `15672`(guest/guest):

```text
http://localhost:15672
```

Run `bundle install` in each app:

```text
cd fake_cf_api
bundle install
 
cd fake_project_runner
bundle install
 
cd fake_test_runner
bundle install 
```

Prepare database for each app:

```text
bundle exec hanami db prepare
```

And run migrations in each app:

```text
bundle exec hanami db migrate
```

Inside `fake_cf_api` start the app server:

```text
bundle exec hanami server
```

Inside `fake_project_runner` start the app server:

```text
bundle exec hanami server -p 2301
```

Inside `fake_test_runner` start the server:

```text
bundle exec hanami server -p 2302
```

Import file `postman_collection.json` to you Postman.

First, you need to add some tests:

```json
{
        "name": "CyberSecurity Assessment Perf Test",
        "description": "",
        "type": "csa"
}
```
```json
{
        "name": "HTTP 1.0 Connections per Second Test",
        "description": "",
        "type": "cps"
}
``` 

Then add `Project` with test ids were created previously:

```json
{
	"name": "New Project",
	"description": "Project description",
	"test_ids": [1,2]
}
```

Start test runner background job listener:

```text
cd fake_test_runner
WORKERS=TestRunWorker bundle exec rake sneakers:run
```

Start log script `receive_logs_topic.rb` in the top folder:

```text
ruby receive_logs_topic.rb "#"
```



