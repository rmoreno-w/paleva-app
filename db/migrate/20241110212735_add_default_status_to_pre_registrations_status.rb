class AddDefaultStatusToPreRegistrationsStatus < ActiveRecord::Migration[7.2]
  def change
    change_column_default :pre_registrations, :status, to: 0
  end
end
