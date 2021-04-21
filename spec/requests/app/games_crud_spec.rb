require 'rails_helper'

RSpec.describe 'game CRUD', type: :request  do
    before(:example) do
        @company = Company.create(name: 'Game Test Company')
        @platform = Platform.create(name: 'Romance')
        @valid_game_params = { name: 'Newest game!', price: 12.5, platform_id: @platform.id, company_id: @company.id  }
    end

    after(:example) do
        Company.destroy_all
        Game.destroy_all
    end

    describe 'POST create' do
        it 'creates a new game' do
            post games_path, params: { game: @valid_game_params}
            expect(Game.find_by(name: @valid_game_params[:name])).to be_a Game
        end

        it 'fails if there are missing arguments' do
            expect{ post games_path, params: { game: {name: "Lalala"}} }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'PUT update' do
        it 'updates a game' do
            game = Game.create(@valid_game_params)
            put game_path(game.id), params: { game: {name: 'Now updated'} }
            expect(Game.find_by(name: 'Now updated')).to be_a Game
        end

        it 'fails if there are invalid arguments' do
            game = Game.create(@valid_game_params)
            expect{
                put game_path(game.id), params: { game: {description:(1...200).to_a.to_s}}
            }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a game' do
            game = Game.create(@valid_game_params)
            delete game_path(game.id)
            expect{ Game.find(game.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists games' do
            game1 = @valid_game_params.clone
            game1[:name] = 'game #1'

            game2 = @valid_game_params.clone
            game2[:name] = 'game #2'

            Game.create([game1, game2])

            get games_path
            expect(response.body).to include('game #1')
            expect(response.body).to include('game #2')
        end

        it 'shows a create game link' do
            get games_path
            expect(response.body).to include('<a href="/games/new">Create Game</a>')
        end
    end

    describe 'GET new' do
        it 'displays a the form for game creation' do
            get new_game_path
            expect(response.body).to include('<form action="/games" accept-charset="UTF-8" data-remote="true" method="post">')
        end
    end

    describe 'GET show' do
        it 'displays a single game' do
            game = Game.create(@valid_game_params)
            get game_path(game.id)
            expect(response.body).to include(@valid_game_params[:name])
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single game' do
            game = Game.create(@valid_game_params)
            get edit_game_path(game.id)
            expect(response.body).to include("value=\"#{@valid_game_params[:name]}\"")
        end
    end
end
