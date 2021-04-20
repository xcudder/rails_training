require 'rails_helper'

RSpec.describe 'book CRUD', type: :request  do
    before(:example) do
        @company = Company.create(name: 'Book Test Company')
        @category = Category.create(name: 'First Person Shooter')
    end

    after(:example) do
        Company.destroy_all
        Book.destroy_all
    end

    describe 'POST create' do
        it 'creates a new book' do
            post books_path, params: { book: { name: 'Newest book!', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id  }}
            expect(Book.find_by(name: 'Newest book!')).to be_a Book
        end

        it 'fails if there are missing arguments' do
            post books_path, params: { book: {name: "Lalala"}}
            expect(response).to have_http_status(401)
        end
    end

    describe 'PUT update' do
        it 'updates a book' do
            book = Book.create(name: 'Soon to be updated', price: 12, author: 'Someone', category_id: @category.id, company_id: @company.id )
            put book_path(book.id), params: {
                book: {
                    name: 'Now updated',
                    price: 12,
                    author: 'Someone',
                    category_id: @category.id,
                    company_id: @company.id
                }
            }
            expect(Book.find_by(name: 'Now updated')).to be_a Book
        end

        it 'fails if there are invalid arguments' do
            book = Book.create(name: 'Soon to be updated', price: 12, author: 'Someone', category_id: @category.id, company_id: @company.id )
            params = {
                book: {
                    name: 'Now updated',
                    author: 'S',
                    category_id: @category.id,
                    company_id: @company.id
                }
            }
            expect{
                put book_path(book.id), params: params
            }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a book' do
            book = Book.new(name: 'Soon to be deleted', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id)
            book.save
            delete book_path(book.id)
            expect{ Book.find(id: book.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists books' do
            Book.create([
                { name: 'book #1', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id },
                { name: 'book #2', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id }
            ])

            get books_path
            expect(response.body).to include('book #1')
            expect(response.body).to include('book #2')
        end

        it 'shows a create book link' do
            get books_path
            expect(response.body).to include('<a href="/books/new">Create Book</a>')
        end
    end

    describe 'GET new' do
        it 'displays a the form for book creation' do
            get new_book_path
            expect(response.body).to include('<form action="/books" accept-charset="UTF-8" data-remote="true" method="post">')
        end
    end

    describe 'GET show' do
        it 'displays a single book' do
            book = Book.new(name: 'A Single book', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id)
            book.save
            get book_path(book.id)
            expect(response.body).to include('A Single book')
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single book' do
            book = Book.new(name: 'A Single book', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id)
            book.save
            get edit_book_path(book.id)
            expect(response.body).to include('value="A Single book"')
        end
    end
end
