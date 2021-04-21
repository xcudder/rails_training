require 'rails_helper'

RSpec.describe 'book CRUD', type: :request  do
    before(:example) do
        @company = Company.create(name: 'Book Test Company')
        @category = Category.create(name: 'Romance')
        @valid_book_params = { name: 'Newest book!', price: 12.5, author: 'Someone', category_id: @category.id, company_id: @company.id  }
    end

    after(:example) do
        Company.destroy_all
        Book.destroy_all
    end

    describe 'POST create' do
        it 'creates a new book' do
            post books_path, params: { book: @valid_book_params}
            expect(Book.find_by(name: @valid_book_params[:name])).to be_a Book
        end

        it 'fails if there are missing arguments' do
            expect{ post books_path, params: { book: {name: "Lalala"}} }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'PUT update' do
        it 'updates a book' do
            book = Book.create(@valid_book_params)
            put book_path(book.id), params: { book: {name: 'Now updated'} }
            expect(Book.find_by(name: 'Now updated')).to be_a Book
        end

        it 'fails if there are invalid arguments' do
            book = Book.create(@valid_book_params)
            expect{
                put book_path(book.id), params: { book: {description:(1...200).to_a.to_s}}
            }.to raise_exception(ActiveRecord::RecordInvalid)
        end
    end

    describe 'DELETE destroy' do
        it 'deletes a book' do
            book = Book.create(@valid_book_params)
            delete book_path(book.id)
            expect{ Book.find(book.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        it 'lists books' do
            book1 = @valid_book_params.clone
            book1[:name] = 'book #1'

            book2 = @valid_book_params.clone
            book2[:name] = 'book #2'

            Book.create([book1, book2])

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
            book = Book.create(@valid_book_params)
            get book_path(book.id)
            expect(response.body).to include(@valid_book_params[:name])
        end
    end

    describe 'GET edit' do
        it 'displays a form filled with info of a single book' do
            book = Book.create(@valid_book_params)
            get edit_book_path(book.id)
            expect(response.body).to include("value=\"#{@valid_book_params[:name]}\"")
        end
    end
end
