class AddChiefIdToPublicEntities < ActiveRecord::Migration
  def change
    add_column :public_entities, :chief_id, :integer
  end
end
