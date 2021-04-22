require 'rails_helper'

RSpec.describe 'book request', type: :request  do

    let(:company) { Company.create(name: 'Book Test Company') }
    let(:category) { Category.create(name: 'Romance') }
    let(:book_name) { 'Newest book!' }
    let(:book) do
        {
            name: book_name,
            price: 12.5,
            author: 'Someone',
            category_id: category.id,
            company_id: company.id
        }
    end
    let(:pre_existing_book){ Book.create(book) }
    let(:params){{ book: book}}

    describe 'POST create' do
        subject { post books_path, params: params }

        context 'when a book is successfully created' do
            it 'redirects user to the created book' do
                is_expected.to redirect_to(book_path(Book.find_by_name(book_name).id))
            end
        end

        context 'when creates book fails' do
            let(:book){{ name: book_name }}

            it 'fails if there are missing arguments' do
                puts params
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'PUT update' do
        subject { put book_path(pre_existing_book.id), params: params }

        context 'when book is successfully updated' do
            before do
                subject
            end

            let(:params) do
                { book: { name: "Now updated" } }
            end

            it 'updates a book' do
                expect(Book.find_by(name: 'Now updated')).to be_a Book
            end

            it 'redirects to the updated book' do
                is_expected.to redirect_to(book_path(pre_existing_book.id))
            end
        end

        context 'when book is not successfully updated' do
            let(:params) do
                { book: { name: "Now updated", author: "S" } }
            end

            it 'raise an ActiveRecord::RecordInvalid exception' do
                expect{ subject }.to raise_exception(ActiveRecord::RecordInvalid)
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete book_path(pre_existing_book.id) }

        context 'when the deletion is successful' do
            before do
                subject
            end

            it 'deletes a book' do
                expect{ Book.find(pre_existing_book.id) }.to raise_exception(ActiveRecord::RecordNotFound)
            end

            it 'redirects the user to the book listing' do
                is_expected.to redirect_to(books_path)
            end
        end

         context 'when the deletion is unsuccessfull' do
            it 'raises an ActiveRecord::RecordInvalid exception' do
                expect{ delete book_path(0) }.to raise_exception(ActiveRecord::RecordNotFound)
            end
        end

    end

    describe 'GET index' do
        subject{ get books_path }

        it 'renders the correct view' do
            is_expected.to render_template("book/list")
        end
    end

    describe 'GET new' do
        subject{ get new_book_path }

        it 'renders the correct view' do
            is_expected.to render_template("book/form")
        end
    end

    describe 'GET show' do
        subject{ get book_path(pre_existing_book.id) }

        it 'loads the requested book' do
            subject
            expect(response.body).to include("<p>#{book_name}")
        end

        it 'renders the correct view' do
            is_expected.to render_template("book/single")
        end
    end

    describe 'GET edit' do
        subject{ get edit_book_path(pre_existing_book.id) }

        it 'loads the requested book' do
            subject
            expect(response.body).to include("value=\"#{book_name}\"")
        end

        it 'renders the correct view' do
            is_expected.to render_template("book/form")
        end
    end
end
