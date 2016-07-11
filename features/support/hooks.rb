require 'watir-webdriver'
include BrowserInit

def change_browser
  browser_name = "firefox"
  browser_name = ENV['browser'] unless ENV['browser'].nil?
  browser_name = "remote_#{browser_name}" unless ENV['hub'].nil?
  browser_name
end

Before do |scenario|
  @scenario_name = scenario.name
  @browser = send(change_browser)
end

After do |scenario|
  if scenario.failed?
    encoded_img = @browser.driver.screenshot_as(:base64)
    embed("data:image/png;base64,#{encoded_img}",'image/png')
    embed("data:image/png;base64,#{@compared_shot}",'image/png') unless @compared_shot.nil?
    debug unless (ENV['debug']).nil?
  end
  @browser.close unless @browser.nil?
end