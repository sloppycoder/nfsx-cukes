# encoding: utf-8
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'pry'

$enable_debug_output = true
$capybara_wait_time = 15
$screen_shot_mode = :failed_scenario