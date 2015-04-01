class AddPublicEntityIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :public_entity_id, :integer
  end
end
