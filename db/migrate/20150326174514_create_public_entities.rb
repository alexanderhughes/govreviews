class CreatePublicEntities < ActiveRecord::Migration
  def change
    create_table :public_entities do |t|
      t.string :name
      t.string :authority_level
      t.string :address
      t.string :description
      t.string :website
      t.references :superior, index: true

      t.timestamps null: false
    end
  end
end
