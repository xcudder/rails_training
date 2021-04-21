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
            post companies_path, params: { company: @valid_company_params}
            expect(Company.find_by(name: @valid_company_params[:name])).to be_a Company
        end

        it 'fails if there are missing/invalid arguments' do
            expect{ post companies_path, params: { company: {name: ''}} }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'PUT update' do
        it 'updates a company' do
            company = Company.create(@valid_company_params)
            put company_path(company.id), params: { company: {name: 'Now updated'} }
            expect(Company.find_by(name: 'Now updated')).to be_a Company
        end

        it 'fails if there are invalid arguments' do
            company = Company.create(@valid_company_params)
            expect{ put company_path(company.id), params: { company: {name: ''}} }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a company' do
            company = Company.create(@valid_company_params)
            delete company_path(company.id)
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

            get companies_path
            expect(response.body).to include('company #1')
            expect(response.body).to include('company #2')
        end

        it 'shows a create company link' do
            get companies_path
            expect(response.body).to include('<a href="/companies/new">Create Company</a>')
        end
    end

    describe 'GET new' do
        it 'displays a the form for company creation' do
            get new_company_path
            expect(response.body).to include('<form action="/companies" accept-charset="UTF-8" data-remote="true" method="post">')
        end
    end

    describe 'GET show' do
        it 'displays a single company' do
            company = Company.create(@valid_company_params)
            get company_path(company.id)
            expect(response.body).to include(@valid_company_params[:name])
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single company' do
            company = Company.create(@valid_company_params)
            get edit_company_path(company.id)
            expect(response.body).to include("value=\"#{@valid_company_params[:name]}\"")
        end
    end
end
