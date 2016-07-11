module BrowserInit

  def firefox(timeout=120)
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['intl.accept_languages'] = "ru"
    profile['browser.privatebrowsing.autostart'] = "true"
    get_browser {Watir::Browser.new :firefox, :profile => profile, :http_client => client(timeout)}
  end

  def chrome(timeout=120)
    caps = Selenium::WebDriver::Remote::Capabilities.chrome(:loggingPrefs => {:browser => "ALL"})
    get_browser {Watir::Browser.new :chrome, :desired_capabilities => caps, :http_client => client(timeout)}
  end

  def ie(timeout=120)
    get_browser {Watir::Browser.new :internet_explorer, :http_client => client(timeout)}
  end

  def remote_firefox(hub_url='http://localhost:4444/wd/hub', timeout=120)
    caps = Selenium::WebDriver::Remote::Capabilities.firefox
    get_remote_browser(caps, timeout, hub_url)
  end

  def remote_chrome(hub_url='http://localhost:4444/wd/hub', timeout=120)
    caps = Selenium::WebDriver::Remote::Capabilities.chrome
    get_remote_browser(caps, timeout, hub_url)
  end

  def remote_ie(hub_url='http://localhost:4444/wd/hub', timeout=120)
    caps = Selenium::WebDriver::Remote::Capabilities.ie
    get_remote_browser(caps, timeout, hub_url)
  end

  private

  def client(timeout)
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.timeout = timeout
    client
  end

  def get_remote_browser(caps, timeout, hub_url)
    get_browser {Watir::Browser.new :remote, :url => hub_url, :desired_capabilities => caps, :http_client => client(timeout), :profile => profile}
  end

  def get_browser
    begin
      browser = yield
    rescue Net::ReadTimeout
      raise("<b>Page is loading more than #{client.timeout} seconds!</b>")
    end
    browser.driver.manage.delete_cookie "cart"
    browser.driver.manage.delete_all_cookies
    browser.window.resize_to(1920, 1080)
    browser.window.maximize
    puts "Browser: '#{browser.execute_script('return window.navigator.userAgent')}'"
    browser
  end
end