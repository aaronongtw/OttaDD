module ApplicationHelper
  def navhelp
    nav = ''

    if @current_user.present? && @current_user.admin?
      nav += '<li>' + link_to('Show Users', users_path) + '</li>'
      nav += '<li>' + link_to('View Relationships', relationships_path) + '</li>'
      nav += '<li>' + link_to('View Databases', databases_path) + '</li>'
      
    end

    if @current_user.present?
      nav += '<li>' + link_to("Account", edit_users_path(@current_user))
      nav += '<li>' + link_to("Log out #{ @current_user.email }",  login_path, :method => :delete)
      nav += '<li>' + link_to("#{@current_user.email}'s Databases", user_path(@current_user))
    else
      nav += '<li>' + link_to('Login', login_path) + '</li>'
      nav += '<li>' + link_to('Sign Up', new_user_path) + '</li>'
    end
    nav
  end
end
