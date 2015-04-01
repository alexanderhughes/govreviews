class AddEntitySubgroupToPublicEntities < ActiveRecord::Migration
  def change
    add_column :public_entities, :entity_subgroup, :string
  end
end
