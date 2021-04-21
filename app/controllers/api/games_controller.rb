class Api::GamesController < ApplicationController
    def index
        @games = Game.all
        render :json => {:response => { :games => @games.to_json }},:status => 200
    end

    def show
        @game = Game.find(params[:id])
        render :json => {:response => { :game => @game.to_json }},:status => 200
    end

    def create
        game = Game.new(params.require(:game).permit!)
        if !game.save
            render :json => {:response => {:errors => game.errors }},:status => 400
        else
            render :json => {:response => { :game => game.to_json }},:status => 200
        end
    end

    def update
        game = Game.find(params[:id])
        begin
            game.update!(params.require(:game).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            render :json => {:response => { :game => game.to_json }},:status => 200
        end
    end

    def destroy
        game = Game.find(params[:id])
        game.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
