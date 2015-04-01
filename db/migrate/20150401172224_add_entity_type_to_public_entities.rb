class AddEntityTypeToPublicEntities < ActiveRecord::Migration
  def change
    add_column :public_entities, :entity_type, :string
  end
end
