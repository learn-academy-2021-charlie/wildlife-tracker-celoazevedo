class AnimalsController < ApplicationController
    def index
        animal = Animal.all
        render json: animal
    end
    def edit
        animal = Animal.find(params[:id])
        if animal.valid?
            render json: animal
        else
            render json: animal.errors
        end
    end
    def destroy
        animal = Animal.find(params[:id])
        if animal.valid?
            render json: animal
        else
            render json: animal.errors
        end
    end

    private
    def animal_params
        params.require(:animal).permit(:common_name, :latin_name, :kingdom)
    end
end
