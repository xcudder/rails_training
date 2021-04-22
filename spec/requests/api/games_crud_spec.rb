require 'rails_helper'

RSpec.describe 'game request', type: :request  do

    let(:company) { Company.create(name: 'Game Test Company') }
    let(:platform) { Platform.create(name: 'Romance') }
    let(:game_name) { 'Newest game!' }
    let(:game) do
        {
            name: game_name,
            price: 12.5,
            platform_id: platform.id,
            company_id: company.id
        }
    end
    let(:pre_existing_game){ Game.create(game) }
    let(:params){{ game: game}}

    describe 'POST create' do
        subject { post api_games_path, params: params }

        before do
            subject
        end

        context 'when creates game successfully' do
            it 'creates a new game' do
                expect(Game.find_by(name: game_name)).to be_a Game
            end

            it 'returns the created game as json' do
                is_expected.to eq(201)
                expect(JSON.parse(response.body)['response']['game'] ).to eq(Game.find_by_name(game_name).to_json)
            end
        end

        context 'when creates game fails' do
            let(:params) do
                { game: { name: "Lalala" } }
            end

            it 'fails if there are missing arguments' do
                is_expected.to eq(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"company\":[\"must exist\"],\"platform\":[\"must exist\"],\"price\":[\"can't be blank\"]}}}")
            end
        end
    end

    describe 'PUT update' do
        subject { put api_game_path(pre_existing_game.id), params: params }

        before do
            subject
        end

        context 'when game is successfully updated' do
            let(:params) do
                { game: { name: "Now updated" } }
            end

            it 'updates a game' do
                is_expected.to eq(204)
                expect(Game.find_by(name: 'Now updated')).to be_a Game
            end
        end

        context 'when game is not successfully updated' do
            let(:params) do
                { game: { price: '' } }
            end

            it 'fails if there are invalid arguments' do
                # is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Price can't be blank"})
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete api_game_path(pre_existing_game.id) }

        it 'deletes a game' do
            subject
            is_expected.to eq(200)
            expect{ Game.find(pre_existing_game.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        subject { get api_games_path }

        it 'lists games' do
            subject
            expect(JSON.parse(response.body)['response']['games']).to eq(Game.all.to_json)
        end
    end

    describe 'GET show' do
        subject {  get api_game_path(pre_existing_game.id) }

        it 'displays a single game' do
            subject
            expect(JSON.parse(response.body)['response']['game']).to eq(pre_existing_game.to_json)
        end
    end
end
