require 'rails_helper'

RSpec.describe 'game CRUD', type: :request  do
    before(:example) do
        @company = Company.create(name: 'Game Test Company')
        @platform = Platform.create(name: 'First Person Shooter')
    end

    after(:example) do
        Company.destroy_all
        Game.destroy_all
    end

    describe 'POST create' do
        it 'creates a new game' do
            post games_path, params: { game: { name: 'New game!', price: 12.5, platform_id: @platform.id, company_id: @company.id  }}
            expect(Game.find_by(name: 'New game!')).to be_a Game
        end

        it 'fails if there are missing arguments' do
            expect{
                post games_path, params: { game: { name: 'Nope game!'}}
            }.to raise_exception(ActionController::ParameterMissing)
        end
    end

    describe 'PUT update' do
        it 'updates a game' do
            game = Game.create(name: 'Soon to be updated', price: 12, platform_id: @platform.id, company_id: @company.id )
            put game_path(game.id), params: {
                game: {
                    name: 'Now updated',
                    price: 12,
                    platform_id: @platform.id,
                    company_id: @company.id
                }
            }
            expect(Game.find_by(name: 'Now updated')).to be_a Game
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a game' do
            game = Game.new(name: 'Soon to be deleted', price: 12.5, platform_id: @platform.id, company_id: @company.id)
            game.save
            delete game_path(game.id)
            expect{ Game.find(id: game.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists games' do
            Game.create([
                { name: 'game #1', price: 12.5, platform_id: @platform.id, company_id: @company.id },
                { name: 'game #2', price: 12.5, platform_id: @platform.id, company_id: @company.id }
            ])

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
            game = Game.new(name: 'A Single game', price: 12.5, platform_id: @platform.id, company_id: @company.id)
            game.save
            get game_path(game.id)
            expect(response.body).to include('A Single game')
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single game' do
            game = Game.new(name: 'A Single game', price: 12.5, platform_id: @platform.id, company_id: @company.id)
            game.save
            get edit_game_path(game.id)
            expect(response.body).to include('value="A Single game"')
        end
    end
end
