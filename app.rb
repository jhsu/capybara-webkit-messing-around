require 'bundler/setup'
Bundler.require

require 'capybara/dsl'
require 'test/unit'

class MyApp < Sinatra::Base
  configure do
    disable :run
  end

  get '/' do
    erb "hello"
  end

  get '/zomg' do
    erb "zomg <a href='/'>Home</a>"
  end
end

Capybara.configure do |c|
  c.javascript_driver = :webkit
  c.app = MyApp
end

class BasicTest < Test::Unit::TestCase
  include Capybara
  def test_basic_url
    visit '/zomg'
    look_for = 'zomg'
    assert page.has_content?(look_for), "'#{look_for}' not found in content."

    click_link("Home")
    look_for = 'hello'
    assert page.has_content?(look_for), "'#{look_for}' not found in content."
  end
end
