class RemoveEntitySubgroupFromPublicEntities < ActiveRecord::Migration
  def change
    remove_column :public_entities, :entity_subgroup
  end
end
