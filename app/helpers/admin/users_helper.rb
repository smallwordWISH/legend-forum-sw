module Admin::UsersHelper

  def options_for_role
    [
      ['Normal', ''],
      ['Admin', 'admin']
    ]
  end
end
