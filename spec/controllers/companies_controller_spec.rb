require 'rails_helper'

RSpec.describe "Company CRUD", type: :request  do
    after(:each) do
        Company.destroy_all
    end

    describe 'POST create' do
        it 'creates a new company' do
            post companies_path, params: { company: { name: 'New company!' }}
            expect(Company.find_by(name: 'New company!')).to be_a Company
        end
    end

    describe 'PUT update' do
        it 'updates a company' do
            company = Company.new(name: 'Soon to be updated')
            company.save
            put company_path(company.id), params: { company: { name: 'Now updated' }}
            expect(Company.find_by(name: "Now updated")).to be_a Company
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a company' do
            company = Company.new(name: 'Soon to be deleted')
            company.save
            delete company_path(company.id)
            expect{ Company.find(id: company.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        Company.create([{ name: 'Company #1' }, { name: 'Company #2' }])

        it 'lists companies' do
            get companies_path
            expect(response.body).to include("Company #1")
            expect(response.body).to include("Company #2")
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
            company = Company.new(name: 'A Single Company')
            company.save
            get company_path(company.id)
            expect(response.body).to include('A Single Company')
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single company' do
            company = Company.new(name: 'A Single Company')
            company.save
            get edit_company_path(company.id)
            expect(response.body).to include('value="A Single Company"')
        end
    end
end
