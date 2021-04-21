require 'rails_helper'

RSpec.describe 'game CRUD', type: :request  do
    before(:example) do
        @company = Company.create(name: 'Game Test Company')
        @platform = Platform.create(name: 'PC')
        @valid_game_params = { name: 'Newest game!', price: 12.5, platform_id: @platform.id, company_id: @company.id  }
    end

    after(:example) do
        Company.destroy_all
        Game.destroy_all
    end

    describe 'POST create' do
        it 'creates a new game' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_games_path, params: {game: @valid_game_params}
            expect(Game.find_by(name: @valid_game_params[:name])).to be_a Game
        end

        it 'returns the created game as json' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_games_path, params: {game: @valid_game_params}
            expect(response).to have_http_status(200)
            expect( JSON.parse(response.body)['response']['game'] ).to eq(Game.find_by(name: @valid_game_params[:name]).to_json)
        end

        it 'fails if there are missing arguments' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_games_path, params: { game: {name: 'Lalala', description: 'a'}}
            expect(response).to have_http_status(400)
            expect(response.body).to eq("{\"response\":{\"errors\":{\"company\":[\"must exist\"],\"platform\":[\"must exist\"],\"price\":[\"can't be blank\"]}}}")
        end
    end

    describe 'PUT update' do
        it 'updates a game' do
            game = Game.create(@valid_game_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_game_path(game.id), params: {game: { name: 'Now updated'}}
            expect(Game.find_by(name: 'Now updated')).to be_a Game
        end

        it 'returns the created resource' do
            game = Game.create(@valid_game_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_game_path(game.id), params: {game: { name: 'Now updated'}}
            expect(response).to have_http_status(200)
            expect(JSON.parse(JSON.parse(response.body)['response']['game'] )['id']).to eq(game.id)
        end

        it 'fails if there are invalid arguments' do
            game = Game.create(@valid_game_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_game_path(game.id), params: { game: {description:(1...200).to_a.to_s}}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Description is too long (maximum is 200 characters)"})
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a game' do
            game = Game.create(@valid_game_params)
            expect(Game.find(game.id)).to be_a Game
            delete api_game_path(game.id)
            expect(response).to have_http_status(200)
            expect{ Game.find(game.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists games' do
            game1 = @valid_game_params.clone
            game1['name'] = 'game #1'

            game2 = @valid_game_params.clone
            game2['name'] = 'game #2'

            Game.create([game1, game2])

            headers = { 'ACCEPT' => 'application/json' }
            get api_games_path
            expect(JSON.parse(response.body)['response']['games']).to eq(Game.all.to_json)
        end
    end

    describe 'GET show' do
        it 'displays a single game' do
            game = Game.create(@valid_game_params)
            get api_game_path(game.id)
            expect(JSON.parse(response.body)['response']['game']).to eq(game.to_json)
        end
    end
end
