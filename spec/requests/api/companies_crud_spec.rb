require 'rails_helper'

RSpec.describe 'company CRUD', type: :request  do
    before(:example) do
        @valid_company_params = { name: 'Newest company!' }
    end

    after(:example) do
        Company.destroy_all
    end

    describe 'POST create' do
        it 'creates a new company' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_companies_path, params: {company: @valid_company_params}
            expect(Company.find_by(name: @valid_company_params[:name])).to be_a Company
        end

        it 'returns the created company as json' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_companies_path, params: {company: @valid_company_params}
            expect(response).to have_http_status(200)
            expect( JSON.parse(response.body)['response']['company'] ).to eq(Company.find_by(name: @valid_company_params[:name]).to_json)
        end

        it 'fails if there are missing arguments' do
            headers = { 'ACCEPT' => 'application/json' }
            post api_companies_path, params: { company: {name: ''}}
            expect(response).to have_http_status(400)
            expect(response.body).to eq("{\"response\":{\"errors\":{\"name\":[\"can't be blank\",\"is too short (minimum is 3 characters)\"]}}}")
        end
    end

    describe 'PUT update' do
        it 'updates a company' do
            company = Company.create(@valid_company_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_company_path(company.id), params: {company: { name: 'Now updated'}}
            expect(Company.find_by(name: 'Now updated')).to be_a Company
        end

        it 'returns the created resource' do
            company = Company.create(@valid_company_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_company_path(company.id), params: {company: { name: 'Now updated'}}
            expect(response).to have_http_status(200)
            expect(JSON.parse(JSON.parse(response.body)['response']['company'] )['id']).to eq(company.id)
        end

        it 'fails if there are invalid arguments' do
            company = Company.create(@valid_company_params)
            headers = { 'ACCEPT' => 'application/json' }
            put api_company_path(company.id), params: { company: {name: ''}}
            expect(response).to have_http_status(400)
            expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Name can't be blank, Name is too short (minimum is 3 characters)"})
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a company' do
            company = Company.create(@valid_company_params)
            expect(Company.find(company.id)).to be_a Company
            delete api_company_path(company.id)
            expect(response).to have_http_status(200)
            expect{ Company.find(company.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists companies' do
            company1 = @valid_company_params.clone
            company1[:name] = 'company #1'

            company2 = @valid_company_params.clone
            company2[:name] = 'company #2'

            Company.create([company1, company2])

            headers = { 'ACCEPT' => 'application/json' }
            get api_companies_path
            expect(JSON.parse(response.body)['response']['companies']).to eq(Company.all.to_json)
        end
    end

    describe 'GET show' do
        it 'displays a single company' do
            company = Company.create(@valid_company_params)
            get api_company_path(company.id)
            expect(JSON.parse(response.body)['response']['company']).to eq(company.to_json)
        end
    end
end
