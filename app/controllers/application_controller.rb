class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "hello, hoge hoge huga world! #{Time.now()}"
  end
end
