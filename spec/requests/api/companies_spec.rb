require 'rails_helper'

RSpec.describe 'company request', type: :request  do
    let(:company_name) { 'Newest company!' }
    let(:company) {{ name: company_name }}
    let(:pre_existing_company){ Company.create(company) }
    let(:params){{ company: company}}

    describe 'POST create' do
        subject { post api_companies_path, params: params }

        before do
            subject
        end

        context 'when creates company successfully' do
            it 'creates a new company' do
                expect(Company.find_by(name: company_name)).to be_a Company
            end

            it 'returns the created company as json' do
                is_expected.to eq(201)
                expect(JSON.parse(response.body)['response']['company'] ).to eq(Company.find_by_name(company_name).to_json)
            end
        end

        context 'when creates company fails' do
            let(:params) do
                { company: { name: "" } }
            end

            it 'fails if there are missing arguments' do
                is_expected.to eq(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"name\":[\"can't be blank\",\"is too short (minimum is 3 characters)\"]}}}")
            end
        end
    end

    describe 'PUT update' do
        subject { put api_company_path(pre_existing_company.id), params: params }

        before do
            subject
        end

        context 'when company is successfully updated' do
            let(:params) do
                { company: { name: "Now updated" } }
            end

            it 'updates a company' do
                is_expected.to eq(204)
                expect(Company.find_by(name: 'Now updated')).to be_a Company
            end
        end

        context 'when company is not successfully updated' do
            let(:params) do
                { company: { name: "" } }
            end

            it 'fails if there are invalid arguments' do
                 is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Name can't be blank, Name is too short (minimum is 3 characters)"})
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete api_company_path(pre_existing_company.id) }

        it 'deletes a company' do
            subject
            is_expected.to eq(200)
            expect{ Company.find(pre_existing_company.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        subject { get api_companies_path }

        it 'renders the correct view' do
            expect(subject).to render_template('api/companies/list')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Company.all.to_json)
        end
    end

    describe 'GET show' do
        subject {  get api_company_path(pre_existing_company.id) }

        it 'renders the correct view' do
            expect(subject).to render_template('api/companies/show')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Company.find(pre_existing_company.id).to_json)
        end
    end
end
