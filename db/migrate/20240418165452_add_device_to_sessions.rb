class AddDeviceToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :device, :string
  end
end
