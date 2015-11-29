# Encoding: utf-8

#
# rubocop:disable Style/GlobalVars
module LoggingHelper
  def plog(msg)
    STDERR.puts "*** #{msg} ***" if $enable_debug_output
  end
end
# rubocop:enable Style/GlobalVars

#
module BrowserHelpers
 
  def ie8?
    # poltergeist driver does not define browser method
    browser = page.driver.browser
    browser.respond_to?('browser') && 
      browser.browser.to_s == 'internet_explorer' && 
      browser.capabilities[:version] == '8'
  end

  def wait_ie8(duration = 2)
    sleep(duration) if ie8?
  end

  def select_option(locator, option)
    wait_ie8(1)
    page.find(locator).find('option', text: option).select_option
  end

  def visit_home_page(url)
    visit url
    # work around IE8 warning about self signed certificate
    return unless ie8?

    if page.html.index('Continue to this website (not recommended)') 
      visit "javascript:document.getElementById('overridelink').click()"
    end
    wait_ie8
  end
end

#
class MyWorld
 
  include BrowserHelpers, LoggingHelper

  attr_accessor :current_scenario

  def initiailize
    Capybara.default_wait_time = $capybara_wait_time || 10
  end

  def current_feature
    if current_scenario.respond_to?('scenario_outline')
      current_scenario.scenario_outline.feature
    else
      current_scenario.feature
    end
  end

  def current_feature_file
    current_feature.location.file
  end

  TEMP_STORE_FILE = 'tmp_store.yml'

  def global_store
    File.exist?(TEMP_STORE_FILE) ? YAML.load_file(TEMP_STORE_FILE) : {}
  end

  def with_global_store
    store = global_store
    yield store
    open(TEMP_STORE_FILE, 'w') { |f| f.write store.to_yaml }
  end
end
