class AddGeotagToPublicEntities < ActiveRecord::Migration
  def change
    add_column :public_entities, :geotag, :string
  end
end
