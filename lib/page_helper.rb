module PageHelper

  def save_screenshot(img_name)
    path = 'reports/img/'
    screenshot_file = path + img_name
    FileUtils.mkdir_p path unless File.exists?(path)
    @browser.windows.last.use do
      @browser.screenshot.save screenshot_file
    end
    screenshot_file
  end

end
