class GamesController < ApplicationController
    def index
        @games = Game.all
        render "game/list", layout: 'application'
    end

    def show
        @game = Game.find(params[:id])
        render "game/single", layout: 'application'
    end

    def edit
        @game = Game.find(params[:id])
        @companies = Company.all
        @platforms = Platform.all
        render "game/form", layout: 'application'
    end

    def new
        @game = Game.new
        @companies = Company.all
        @platforms = Platform.all
        render "game/form", layout: 'application'
    end

    def create
        game = Game.new(params.require(:game).permit!)
        if !game.save
            raise ActiveRecord::RecordInvalid
        else
            redirect_to game
        end
    end

    def update
        game = Game.find(params[:id])
        game.update!(params.require(:game).permit!)
        redirect_to game
    end

    def destroy
        game = Game.find(params[:id])
        game.destroy
        redirect_to games_path
    end

    private def game_params
        params.require(:game).require([:name, :price, :platform_id, :company_id])
        params.require(:game).permit!
    end
end
