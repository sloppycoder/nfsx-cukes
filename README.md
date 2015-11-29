## BDD style functional testing for NFS X based applications 

This is the next generation automated UI testing tool based on

* [Cucumber](http://cukes.info) the pioneer of BDD style test framework for Ruby, Java, Javascript 
* [Capybara](https://github.com/jnicklas/capybara) Autoamted UI testing tool for Ruby
* [Selenium 2](http://www.seleniumhq.org) the standard toolkit for automated browser testing

To run the example:

```
  bundle install

  # run tests with firefox browser and generate html report
  bundle exec cucumber 

  #uses phantomjs for headless testing and generate json report
  bundle exec cucumber --tag @t

  #if you only 1 ruby installation on your computer, just use
  cucumber --tag @t

```

## Test cases structure

All test cases are organized under features folder and grouped by functionality based on navigation menu strucuture.

### Tips on naming and grouping of features and scenarios

1. Create feature files based on functional area, and use tags to group test execution and projects.
2. Tag can also be used to provide tracitbility to requirement.
3. Use tags in indicate host system dependency, e.g. @eibm.

```
  # good
  payee_management.feature

  # bad
  r9_g3_phase2.feature 
  cn_regression_mar_15.feature 


  # good
  @regression
  Scenario: Transfer fund to own account

  #good
  @R9_multiple_browser_FSD_1.2.1 
  Scenario: whatever chapter 1.2.1 in FSD document describes

```

to execute test by grouping or project,

```
# execute regression pack
cucumber --tags @regression

# execute all test that does not rely on ibm host
cucumber --tags ~@ibm

# execute individual feature and scenario (by indicating line number)
cucumber -r features features/ibank/bill_payment/manage_payee.feature:12

```

See [Cucumber Wiki](https://github.com/cucumber/cucumber/wiki/Tags) for more details.


### Tips on writing scearnios
1. use "I should see some message" instead of "Some message is displayed"
2. always quote test data or what is displayed on screen in step description
3. be DRY. Try to use existing common steps for clicking menu, button, checking text in page etc

```
# good
I select payee type "Registered Payee"

# bad
I select payee type Registered Payee

```


