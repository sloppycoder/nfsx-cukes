#!/bin/bash


killall phantomjs
phantomjs --webdriver= &

export BROWSER=ghostdriver; rake
RET=$?

killall phantomjs ; true

echo Rake returned $RET

exit 0
