class PublicEntitiesController < ApplicationController
  def index
    @public_entity = PublicEntity.all
  end
end
