class Sgfile < ActiveRecord::Base
  establish_connection "mssql_#{Rails.env}".to_sym
  self.table_name = 'sgfile'
  scope :download, -> { where(sgdir_id: 12)}
end