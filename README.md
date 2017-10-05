# Competitor Monitor

Competitor Monitor is a web application to monitor product competitors
on Amazon.

## Install

The application has the following dependencies: Git, Rails, Redis (for sidekiq)
and RVM is recommended. Assuming git is already installed:

* [Install Redis](https://redis.io/topics/quickstart), start the server and
check that it works
* [Install RVM](https://rvm.io/rvm/install)
* Install Ruby 2.4.0

    rvm install 2.4.0

* Install Bundler

    rvm gemset use global
    gem install bundler

* Clone repository to local machine

    git clone https://github.com/durnin/competitor_monitor.git

* Install application dependencies

    cd competitor_monitor # should create new gemset in rvm
    bundle install

* Create DB with seed data

    rake db:setup

* Add to crontab the application background jobs with:

    whenever --update-crontab

## Running the application

To run in development, open a terminal, go to the application folder, then:

    rails s

You'll also need to run sidekiq on a different terminal:

    sidekiq -q default -q mailers

You can now access application at[http://localhost:3000](http://localhost:3000)

## Dev Tools

For development the following tools were used:

* Front-end: Rails, Bootstrap 4, FontAwesome
* View templates: HAML
* DB: SQLite3
* Code smells, linting, code analyzer: Rubocop, Bullet, Reek, Rails Best
Practices, HAML Lint, Flay. All of this run with Pronto on git-precommit
callback.
* Debug: Byebug, Coderay

## Testing Tools

For testing RSpec was used as testing framework including the following
tools:

* RSpec-Rails
* Faker: For fake data on tests
* FactoryGirl: Much cleaner way than fixtures
* Capybara: For feature tests
* Database-Cleaner: To clean DB before/after tests
* Simplecov: To check test coverage
* Webmock: To mock web requests
* VCR: To record http requests on integration tests

## Development Cycle

Mainly BDD using red - green - refactor cycle with very occasionally
one off tests.

## Design

### Front-End

As mentioned before front-end is just plain Rails with Bootstrap4 and FontAwesome.
Bootstrap4 is still in beta but I found some issues in the way so I went
back to alpha6.

### Models

Just two models were created:

* **Group:** Each group can have up to 8 competitors, there could only be 10
groups in the system at the same time
* **Competitor:** Records all the information for a product of a competitor
(including link/asin and all details)

### Getting data from Amazon

To get data from Amazon **Mechanize** gem was used for 2 reasons:

* Uses **nokogiri** under the hood which is fast
* Does cookie handling, which is needed for cart management

A scraper library was made under /lib folder that scrapes one product. A
competitor decorator class wraps the call to this library and saves the data,
and finally a service class was made to fetch data for all the competitors
products of a group.

This service class is called from within a background job (a rake task under
/tasks folder that iterates on all groups) that executes daily.

Background job processing is done through **sidekiq**. The idea behind having
a service that extracts data per group is that many jobs are enqueued so that
we can get better performance. There's a couple of problems with this right
now:

* SQLite doesn't support very well concurrency (locks entire db for updates)
* Can't do too much concurrency because Amazon could detect application as
a bot for the many requests.

### Saving History of Changes

For the purposes of saving the history of changes on competitors there were
some good alternatives like **audit** gem but I chose **paper_trail** for the
built-in functionality it provided.

The 2 key concepts on this were:

* Making sure that every time I fetch data for a competitor (which is once a
day) paper_trail would generate a new version. I did this by using:

```ruby
competitor.update_attributes(new_from_amazon.merge(updated_at: Time.now))
```

* Accessing last version **changeset** to get changes from last version to
current one.

Also in case we wanted to limit the history size of the product to just the
last one, **paper_trail** has an option to limit the size of versions it
stores.

### Notifications to User

Notifications were done using ActionMailer. A helper module was made to
encapsulate the code of getting the latest changes of all groups.

Right now the user email is a configuration on **secrets.yml**. On a many-user
system it would use the user email.

The mailer call is made through a rake task that is also called daily (and
is enqueued on **sidekiq**).

For the purposes of testing the functionality **letter_opener** gem was
installed. Once a mail is delivered, you can access web interface at:
[http://localhost:3000/letter_opener/](http://localhost:3000/letter_opener/)

## Force Data Extraction and Notifications

To force data extraction, open a terminal on the application folder and run:

    rake amazon:scrape_groups

To force notifications to user (after extracting some data), open a terminal
on the application folder and run:

    rake notifications:user_latest_changes

You can then check new email with changes at: [http://localhost:3000/letter_opener/](http://localhost:3000/letter_opener/)
Note that first email will show everything as a difference (because there
were no previous data on the system, but after another data extraction,
new notification should show minimal changes.

## Background Jobs

As mentioned before background jobs are processed by **sidekiq** and tasks
are scheduled using cron through **whenever** gem.

## Test & Coverage

To run all tests run:

    rspec

To access coverage information go to the coverage folder and access
**index.html** using a browser.

## TODO's

* Add User model to make the application many-user. User Devise for
registration and authentication.
* Add more validations on competitor CRUD operations, specially once
a competitor has history data.
* Amazon has different types of detail pages which differ in how they
should be scraped, I only covered some of them but a deeper analysis
is required to cover all cases.
* Change DB for PostgreSQL to get better performance.
* Rotate IP's using a list of proxy servers so that application doesn't
get banned for scraping.
* Add more tests in general. In most of the cases the happy path was
tested and very few alternative paths.
