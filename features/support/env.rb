$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'lib'))

require 'rubygems'
require 'rspec'
require 'page-object'
require 'watir-webdriver'
require 'yaml'
require 'require_all'

reports_path = "reports"
log_path = "log"
FileUtils.mkdir_p(reports_path) unless File.directory?(reports_path)
FileUtils.mkdir_p(log_path) unless File.directory?(log_path)
Conf = YAML.load(File.read("config/data/conf.yml"))
$server = ENV['prod'].nil? ? Conf[:url][:server_developer] : Conf[:url][:server_production]
require_all 'lib'

World(PageObject::PageFactory, PageHelper, Helper)