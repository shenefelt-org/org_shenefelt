class AddNameToSolidQueueProcesses < ActiveRecord::Migration[8.0]
  def change
    add_column :solid_queue_processes, :name, :string, null: false
    add_index :solid_queue_processes, [ :name, :supervisor_id ], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
  end
end