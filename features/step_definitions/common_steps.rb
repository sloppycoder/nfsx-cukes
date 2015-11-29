# encoding: utf-8
#
# page name and their URL matcher
#
# rubocop:disable Metrics/LineLength

PAGE_URL = {

  'login' => /uaa\/login/,
  'dashboard' => /dashboard/,
}

Then(/I should see (.*?) page/) do |p|
  wait_ie8 
  expect(page.current_url).to match(PAGE_URL[p])
end

Given(/I am on (.*?) page/) do |p|
  step "I should see #{p} page"
end

#
# login and logout
#
Given('I am ready to login') do
  visit_home_page ENV['MAIN_APP_URL'] || 'http://localhost:8000/app'

  # HACK: around IE8 warning about self signed certificate
  if ie8?
    if page.html.index('Continue to this website (not recommended)') 
      visit "javascript:document.getElementById('overridelink').click()"
    end
    wait_ie8
  end

  binding.pry

  expect(page).to have_content('Username')
  expect(page).to have_content('Password')
end

When(/^I login as "(\w*)" with password "(\w*)"$/) do |user, password|
  fill_in 'username', with: user
  fill_in 'password', with: password
  click_button 'Login'
end

When('I logout') do
  click_button 'Logout'
end

#
# generic actions like select menu, click button
# check what is on screen etc.
#
Then(/I should see "(.*?)" on the screen/) do |txt|
  wait_ie8 
  expect(page).to have_content(txt)
end

Then(/I should not see "(.*?)" on the screen/) do |txt|
  wait_ie8 
  expect(page).not_to have_content(txt)
end


When(/^I click hyperlink "(.*?)"$/) do |text|
  page.find('a', text: text).click
end

# put this line into your scenario will drop you into pry console
# then you can use inspector to look around on the page
Then('I want to poke around') do
  # rubocop:disable Lint/Debugger
  binding.pry
  # rubocop:enable Lint/Debugger
end

Then('wait a sec') do
  step 'I want to poke around'
end
