class UsersController < ApplicationController
  # render new.rhtml
  def new
  end
  
  def show
    @user = User.find_by_login!(params[:id])
    @projects = @user.projects.find(:all, :include => [:tags])
    @repositories = @user.repositories.find(:all, :conditions => ["mainline = ?", false])
  end

  def create
    @user = User.new(params[:user])
    @user.login = params[:user][:login]
    @user.save!
    
    confirmation = (GitoriousConfig["require_confirmation"].nil? ? true : GitoriousConfig["require_confirmation"])
    
    redirect_to root_path
    
    if confirmation
        flash[:notice] = "Thanks for signing up! You will receive an account activation email soon"
    else
        @user.activate
    end
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end

  def activate
    if user = User.find_by_activation_code(params[:activation_code])
      self.current_user = user
      if logged_in? && !current_user.activated?
        current_user.activate
        flash[:notice] = "Your account has been activated, welcome!"
      end
    else
      flash[:error] = "Invalid activation code"
    end
    redirect_back_or_default('/')
  end

end
