require 'bundler/setup'
Bundler.require

require 'capybara/dsl'
require 'test/unit'

class MyApp < Sinatra::Base
  configure do
    disable :run
  end

  get '/' do
    erb <<-HTML
<html>
<head><title>hello</title></head>
<body>
<script type="text/javascript">
var box = document.getElementById('content');
box.innerHTML = 'zomg';
</script>
<p id='content'></p>
</body>
<html>
HTML
  end
end

Capybara.configure do |c|
  c.current_driver = :rack_test
  c.javascript_driver = :webkit
  c.app = MyApp
end

class BasicTest < Test::Unit::TestCase
  include Capybara
  def test_basic_url
    visit '/'
    look_for = 'zomg'
    assert find("p#content").text == look_for, "'#{look_for}' not found in content."
  end
end
