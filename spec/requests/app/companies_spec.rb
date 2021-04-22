require 'rails_helper'

RSpec.describe 'company request', type: :request  do

    let(:company_name) { 'Newest company!' }
    let(:company) {{ name: company_name }}
    let(:pre_existing_company){ Company.create(company) }
    let(:params){{ company: company}}

    describe 'POST create' do
        subject { post companies_path, params: params }

        context 'when a company is successfully created' do
            it 'redirects user to the created company' do
                is_expected.to redirect_to(company_path(Company.find_by_name(company_name).id))
            end
        end

        context 'when creates company fails' do
            let(:params) do
                { company: { name: "" } }
            end

            it 'fails if there are missing arguments' do
                puts params
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'PUT update' do
        subject { put company_path(pre_existing_company.id), params: params }

        context 'when company is successfully updated' do
            before do
                subject
            end

            let(:params) do
                { company: { name: "Now updated" } }
            end

            it 'updates a company' do
                expect(Company.find_by(name: 'Now updated')).to be_a Company
            end

            it 'redirects to the updated company' do
                is_expected.to redirect_to(company_path(pre_existing_company.id))
            end
        end

        context 'when company is not successfully updated' do
            let(:params) do
                { company: { name: "" } }
            end

            it 'raise an ActiveRecord::RecordInvalid exception' do
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete company_path(pre_existing_company.id) }

        context 'when the deletion is successful' do
            before do
                subject
            end

            it 'deletes a company' do
                expect{ Company.find(pre_existing_company.id) }.to raise_exception(ActiveRecord::RecordNotFound)
            end

            it 'redirects the user to the company listing' do
                is_expected.to redirect_to(companies_path)
            end
        end

         context 'when the deletion is unsuccessfull' do
            it 'raises an ActiveRecord::RecordInvalid exception' do
                expect{ delete company_path(0) }.to raise_exception(ActiveRecord::RecordNotFound)
            end
        end

    end

    describe 'GET index' do
        subject{ get companies_path }

        it 'renders the correct view' do
            is_expected.to render_template("company/list")
        end
    end

    describe 'GET new' do
        subject{ get new_company_path }

        it 'renders the correct view' do
            is_expected.to render_template("company/form")
        end
    end

    describe 'GET show' do
        subject{ get company_path(pre_existing_company.id) }

        it 'loads the requested company' do
            subject
            expect(response.body).to include("<p>#{company_name}")
        end

        it 'renders the correct view' do
            is_expected.to render_template("company/single")
        end
    end

    describe 'GET edit' do
        subject{ get edit_company_path(pre_existing_company.id) }

        it 'loads the requested company' do
            subject
            expect(response.body).to include("value=\"#{company_name}\"")
        end

        it 'renders the correct view' do
            is_expected.to render_template("company/form")
        end
    end
end
