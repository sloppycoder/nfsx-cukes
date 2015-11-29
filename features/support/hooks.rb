# encoding: utf-8

def configure_browser
  env = ENV['BROWSER'] || 'firefox'
  browser_conf = YAML.load_file('config/browsers.yml')[env.downcase]
  fail "Unknow browser preset #{env}" unless browser_conf

  options = browser_conf[:options]
  case browser_conf[:driver]
  when :poltergeist
    register_poltergeist(options)
  when :selenium
    require 'selenium-webdriver'
    caps = remote_browser_capabilites(browser_conf)
    options[:desired_capabilities] = caps if caps
    register_selenium(options)
  else
    fail "Unknown browser driver specified for #{env}"
  end
end

def register_poltergeist(options)
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
  end
  Capybara.default_driver = :poltergeist
end

def register_selenium(options)
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, options)
  end
  Capybara.default_driver = :selenium
end

def remote_browser_capabilites(browser_conf)
  capabilities = browser_conf[:capabilities]
  return nil unless capabilities

  browser = capabilities.delete(:browser)
  caps = Selenium::WebDriver::Remote::Capabilities.public_send(browser)
  capabilities.keys.each { |c| caps[c] = capabilities[c] }
  caps
end
# hooks

AfterConfiguration do
  configure_browser
end

Before do |scenario|
  # we will use current scenario to determine various configuration
  # parameters when executing the steps
  @current_scenario = scenario

  # to track which step we're on within a scenario
  @step_count = 0
end

# take a screenshot and embed into report
# in case of console formatter, only take screenshot when scenario
# files.
#
def embed_screenshot(label)
  return unless self.respond_to?('embed')

  screenshot =  "#{SecureRandom.urlsafe_base64}.png"
  page.save_screenshot(screenshot)
  begin
    embed(screenshot, 'image/png', label)
  rescue NoMethodError
    STDERR.puts '...'
  ensure
    FileUtils.rm_f(screenshot)
  end
end

def using_console_formatter?
  'constant' == defined?(Cucumber::Formatter::Console)
end

After do |scenario|
  if using_console_formatter? && scenario.failed?
    feature_name = File.basename(current_feature_file).gsub('.feature', '')
    page.save_screenshot "#{feature_name}_#{scenario.line}.png"
  else
    scenario_name = scenario
                    .instance_variable_get('@gherkin_statement')
                    .instance_variable_get('@name')
    if scenario_name.nil?
      # scenario with examples table
      scenario_name = scenario
                      .instance_variable_get('@table')
                      .instance_variable_get('@scenario_outline')
                      .instance_variable_get('@gherkin_statement')
                      .instance_variable_get('@name')
    end

    case $screen_shot_mode
    when :after_scenario
      embed_screenshot "Screenshot: #{scenario_name}"
    when :failed_scenario
      embed_screenshot "Screenshot: #{scenario_name}" if scenario.failed?
    when :after_step
      # screenshot after taken after the step, so nothing to be done here
    end
  end
end
# rubocop:enable Style/AlignParameters

AfterStep do
  if !using_console_formatter? && $screen_shot_mode == :after_step
    embed_screenshot 'screenshot'
  end

  @step_count += 1
end

# end of hooks

World do
  MyWorld.new
end
