class AnimalsController < ApplicationController
    def index
        animal = Animal.all
        render json: animal
    end
end
