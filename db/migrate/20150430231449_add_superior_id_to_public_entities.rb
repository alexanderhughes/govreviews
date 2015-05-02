class AddSuperiorIdToPublicEntities < ActiveRecord::Migration
  def change
    add_column :superior_id, :public_entities
  end
end
