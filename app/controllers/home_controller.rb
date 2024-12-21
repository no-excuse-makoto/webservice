class HomeController < ApplicationController
  #application_controller.rbで定義したメソッドを使うためにbefore_actionを使っている
  before_action :forbid_login_user, {only: [:top]}
  

  def top
  end

  def about
  end
end
