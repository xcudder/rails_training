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
        @companies = Company.all
        @platforms = Platform.all
        render "game/form", layout: 'application'
    end

    def create
        game = Game.new(game_params)
        game.save
        redirect_to game
    end

    def update
        game = Game.find(params[:id])
        game.update!(game_params)
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
