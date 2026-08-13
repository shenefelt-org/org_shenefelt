class FilesPolicy < ApplicationPolicy
  def view_files_button?
    user.present? && user.admin?
  end

  def view_delete_button?
    user.present? && user.admin?
  end

  def view_curl_command?
    user.present? && user.admin?
  end
end
