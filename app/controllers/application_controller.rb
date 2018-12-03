class ApplicationController < ActionController::Base
  helper_method :user_signed_in?, :current_user, :get_logout

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
      return false
    end
  end
end
