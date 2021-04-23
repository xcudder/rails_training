class Api::GamesController < ApplicationController
    def index
        @games = Game.all
        render "api/games/list"
    end

    def show
        @game = Game.find(params[:id])
        render "api/games/show"
    end

    def create
        game = Game.new(params.require(:game).permit!)
        if !game.save
            render :json => {:response => {:errors => game.errors }},:status => 400
        else
            render :json => {:response => { :game => game.to_json }},:status => 201
        end
    end

    def update
        game = Game.find(params[:id])
        begin
            game.update!(params.require(:game).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end

    def destroy
        game = Game.find(params[:id])
        game.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
