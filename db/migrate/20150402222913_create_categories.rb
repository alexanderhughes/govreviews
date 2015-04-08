class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
    end

    create_table :categories_public_entities, id: false do |t|
      t.belongs_to :category, index: true
      t.belongs_to :public_entity, index: true
    end
  end
end
