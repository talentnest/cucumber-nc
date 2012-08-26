# Cucumber Notification Center

cucumber-nc is a Cucumber formatter for Mountain Lion's Notification Center.

## Installation

Installing cucumber-nc is easy. Just put it in your Gemfile
(`gem 'cucumber-nc'`) and run your features like this from now on:

```
$ cucumber --format pretty --format CucumberNc --out /dev/null
```

You will want to specify another formatter as cucumber-nc does not provide any
other output.

If you want to use cucumber-nc as your default formatter, simply put this option
in your cucumber.yml file:

```
--format CucumberNc --out /dev/null
```

## Contributing

Found an issue? Have a great idea? Want to help? Great! Create an issue issue
for it, or even better; fork the project and fix the problem yourself. Pull
requests are always welcome. :)
