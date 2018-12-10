class ApplicationController < ActionController::Base
  helper_method :user_signed_in?, :current_user, :get_user_type, :get_logout, :filter_on_signed_in, :get_css_color, :get_dashboard, :get_profil

  before_action :configure_devise_parameters, if: :devise_controller?

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:name,:address, :last_name, :first_name, :email, :phone, :siret, :description, :password, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) {|u| u.permit(:name, :last_name, :first_name, :email, :phone, :siret, :description, :password, :password_confirmation, :current_password)}
  end

  def filter_on_signed_in
    unless user_signed_in?
      redirect_to root_path
    end
  end

  def user_signed_in? 
    return student_signed_in? || teacher_signed_in? || establishment_signed_in?
  end

  def current_user
    if current_student
      return current_student
    elsif current_teacher
      return current_teacher
    elsif current_establishment
      return current_establishment
    end
  end

  def get_user_id
    @student = Student.find(params[:id])
    @teacher = Teacher.find(params[:id])
    @establishment = Establishment.find(params[:id])
  end

  def get_user_type
    if current_user
      return current_user.class.name
    else
      return false
    end
  end

  def get_logout
    if student_signed_in?
      return destroy_student_session_path
    elsif teacher_signed_in?
      return destroy_teacher_session_path
    elsif establishment_signed_in?
      return destroy_establishment_session_path
    else
      return ""
    end
  end

  def get_dashboard(user_object)
    if student_signed_in?
      return student_dashboard_path(user_object)
    elsif teacher_signed_in?
      return teacher_dashboard_path(user_object)
    elsif establishment_signed_in?
      return establishment_dashboard_path(user_object)
    else
      return ""
    end
  end

  def get_profil(user_object)
    if student_signed_in?
      return student_path(user_object)
    elsif teacher_signed_in?
      return teacher_path(user_object)
    elsif establishment_signed_in?
      return establishment_path(user_object)
    else
      return ""
    end
  end

  def get_css_color(class_name)
   if class_name == "Student"
     return "warning"
    elsif class_name == "Teacher"
      return "danger"
    elsif class_name == "Establishment"
      return "success"
    end
  end

  before_action :configure_devise_parameters, if: :devise_controller?

  def configure_devise_parameters
    devise_parameter_sanitizer.permit(:sign_up) {|u| u.permit(:last_name, :first_name, :email, :phone, :siret, :description, :password, :password_confirmation)}
  end

end
