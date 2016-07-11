require 'page-object'

module Helper
  include PageObject

  def random_text(number = 6)
    SecureRandom.hex(number)
  end

  def random_number(length = 9)
    ((SecureRandom.random_number * (10**length)).round + 2)
  end

  def random_number_in_range(range_a, range_b)
    rand(range_a..range_b)
  end

  # return random email like a asdadasd@asdasd.asd
  def random_email
    format('%s@%s.%s', random_text(8), random_text, random_text(3))
  end

  # return random email like a asdadasd@gmail.com
  def random_email_with_domen(domen = Conf[:user][:email_domen])
    format('%s@%s', random_text(8), domen)
  end

  # return random email like a login+sdfsdf@gmail.com
  def random_multiple_email(login = Conf[:user][:email_name], domen = Conf[:user][:email_domen])
    format('%s+%s@%s', login, random_text, domen)
  end

  def random_user_data
    OpenStruct.new(user_name: random_text, user_password: get_random_text(10), user_email: get_random_email, user_phone: get_random_number(20))
  end

  def debug
    require 'byebug'
    byebug
  end
end
