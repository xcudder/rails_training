require 'rails_helper'

RSpec.describe 'game request', type: :request  do

    let(:company) { Company.create(name: 'Game Test Company') }
    let(:platform) { Platform.create(name: 'PC') }
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
        subject { post games_path, params: params }

        context 'when a game is successfully created' do
            it 'redirects user to the created game' do
                is_expected.to redirect_to(game_path(Game.find_by_name(game_name).id))
            end
        end

        context 'when creates game fails' do
            let(:game){{ name: game_name }}

            it 'fails if there are missing arguments' do
                puts params
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'PUT update' do
        subject { put game_path(pre_existing_game.id), params: params }

        context 'when game is successfully updated' do
            before do
                subject
            end

            let(:params) do
                { game: { name: "Now updated" } }
            end

            it 'updates a game' do
                expect(Game.find_by(name: 'Now updated')).to be_a Game
            end

            it 'redirects to the updated game' do
                is_expected.to redirect_to(game_path(pre_existing_game.id))
            end
        end

        context 'when game is not successfully updated' do
            let(:params) do
                { game: { name: "" } }
            end

            it 'raise an ActiveRecord::RecordInvalid exception' do
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete game_path(pre_existing_game.id) }

        context 'when the deletion is successful' do
            before do
                subject
            end

            it 'deletes a game' do
                expect{ Game.find(pre_existing_game.id) }.to raise_exception(ActiveRecord::RecordNotFound)
            end

            it 'redirects the user to the game listing' do
                is_expected.to redirect_to(games_path)
            end
        end

         context 'when the deletion is unsuccessfull' do
            it 'raises an ActiveRecord::RecordInvalid exception' do
                expect{ delete game_path(0) }.to raise_exception(ActiveRecord::RecordNotFound)
            end
        end

    end

    describe 'GET index' do
        subject{ get games_path }

        it 'renders the correct view' do
            is_expected.to render_template("game/list")
        end
    end

    describe 'GET new' do
        subject{ get new_game_path }

        it 'renders the correct view' do
            is_expected.to render_template("game/form")
        end
    end

    describe 'GET show' do
        subject{ get game_path(pre_existing_game.id) }

        it 'loads the requested game' do
            subject
            expect(response.body).to include("<p>#{game_name}")
        end

        it 'renders the correct view' do
            is_expected.to render_template("game/single")
        end
    end

    describe 'GET edit' do
        subject{ get edit_game_path(pre_existing_game.id) }

        it 'loads the requested game' do
            subject
            expect(response.body).to include("value=\"#{game_name}\"")
        end

        it 'renders the correct view' do
            is_expected.to render_template("game/form")
        end
    end
end
