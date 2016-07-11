require 'page-object'

module PageHelper
  include PageObject

  def load_page(url)
    @browser.goto url
  end

  def go_to_previous_page
    @browser.back
  end

  def wait_and_refresh(update_frequency_in_seconds)
    sleep update_frequency_in_seconds
    @browser.refresh
  end

  def save_screenshot(img_name)
    path = 'reports/img/'
    screenshot_file = path + img_name
    FileUtils.mkdir_p path unless File.exists?(path)
    @browser.windows.last.use do
      @browser.screenshot.save screenshot_file
    end
    screenshot_file
  end

  def wait_end_of_effects
    @browser.wait_until(10, "Div с классом 'md-dialog-container' не дает взаимодействовать со страницей!") do
      !@browser.div(xpath: "//div[@class='md-dialog-container showed']").exists?
    end
  end

  def collect_logs
    create_log_file
    File.open('log/selenium.log', 'a+') {|f| f.puts "#{"\n" + @scenario_name}"}
    begin
      raise get_js_error_feedback() unless get_js_error_feedback().empty?
    rescue
    end # begin
  end

  private

  def get_js_error_feedback()
    jserror_descriptions = ""
    begin
      jserrors = @browser.execute_script("return window.JSErrorCollector_errors.pump()")
      jserrors.each do |jserror|
        $log.debug "ERROR: JS error detected:n#{jserror["errorMessage"]} (#{jserror["sourceName"]}:#{jserror["lineNumber"]})"
        jserror_descriptions += "JS error detected:
  #{jserror["errorMessage"]} (#{jserror["sourceName"]}:#{jserror["lineNumber"]})"
      end
    rescue Exception => e
      $log.debug "Checking for JS errors failed with: #{e.message}"
    end
    jserror_descriptions
  end

  def create_log_file
    $opened ||= false  # have to define a variable before we can reference its value
    unless $opened
      File.open('log/selenium.log', 'w')
      $opened = true
      $log = Logger.new('log/selenium.log')
    end
  end

end
