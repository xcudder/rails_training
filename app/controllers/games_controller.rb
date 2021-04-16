class GamesController < ApplicationController
    def index
        @games = Game.includes(:games, :games).all
        render "game/list"
    end

    def show
        @game = Game.find(params[:id])
        render "game/single"
    end

    def edit
        @game = Game.find(params[:id])
        render "game/form"
    end

    def new
        render "game/form"
    end

    def create
        game = Game.new(game_params)
        Game.save
        redirect_to game
    end

    def update
        game = Game.find(params[:id])
        Game.update!(game_params)
        redirect_to game
    end

    def destroy
        game = Game.find(params[:id])
        Game.destroy
        redirect_to companies_path
    end

    private def game_params
        params.require(:game).permit(:name)
    end
end
