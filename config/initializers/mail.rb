ActionMailer::Base.delivery_method = :smtp unless Rails.env.test?
ActionMailer::Base.smtp_settings = {
    :port =>           '587',
    :address =>        'smtp.mandrillapp.com',
    :user_name =>      'itayadler@gmail.com',
    :password =>       '9H2-xO6oZN4pctZtyui0Jg',
    :domain =>         'nadlan.giftsproject.com',
    :authentication => :plain
}

