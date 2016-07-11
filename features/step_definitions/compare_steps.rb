#coding: utf-8
require 'rubygems'
require 'watir-webdriver'
require 'page-object'

include Selenium
include ScreenshotComparer

Given(/^Im on main qasquad page$/) do
  visit(MainPage)
end

When(/^I take screenshot$/) do
  save_screenshot("screen_1.png")
end

When(/^Compare screenshots$/) do
  @result = compare_screenshots("reports/img/screen_1.png", "sample_screenshots/screen_1.png")
end

Then(/^I should see difference not more than "([^"]*)" percent$/) do |percent|
  expect(@result <= percent.to_f).to be, "Difference found: '#{@result}%'"
end