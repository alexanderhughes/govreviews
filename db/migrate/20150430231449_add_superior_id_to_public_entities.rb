class AddSuperiorIdToPublicEntities < ActiveRecord::Migration
  def change
    add_column :superior_id, :public_entities, :integer
  end
end
