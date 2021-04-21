require 'rails_helper'

RSpec.describe 'book request', type: :request  do

    let(:company) { Company.create(name: 'Book Test Company') }
    let(:category) { Category.create(name: 'Romance') }
    let(:book_name) { 'Newest book!' }

    let(:params) do
        {
            book:{
                name: book_name,
                price: 12.5,
                author: 'Someone',
                category_id: category.id,
                company_id: company.id
            }
        }
    end

    describe 'POST create' do
        subject { post api_books_path, params: params }

        before do
            subject
        end

        context 'when creates book successfully' do
            it 'creates a new book' do
                expect(Book.find_by(name: book_name)).to be_a Book
            end

            it 'returns the created book as json' do
                expect(response).to have_http_status(200)
                is_expected.to eq(200)
                expect(JSON.parse(response.body)['response']['book'] ).to eq(Book.find_by_name(book_name).to_json)
            end
        end

        context 'when creates book fails' do
            let(:params) do
                { book: { name: "Lalala" } }
            end

            it 'fails if there are missing arguments' do
                expect(response).to have_http_status(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"company\":[\"must exist\"],\"category\":[\"must exist\"],\"author\":[\"is too short (minimum is 3 characters)\"],\"price\":[\"can't be blank\"]}}}")
            end
        end
    end

    # describe 'PUT update' do
    #     it 'updates a book' do
    #         book = Book.create(@valid_book_params)
    #         headers = { 'ACCEPT' => 'application/json' }
    #         put api_book_path(book.id), params: {book: { name: 'Now updated'}}
    #         expect(Book.find_by(name: 'Now updated')).to be_a Book
    #     end

    #     it 'returns the created resource' do
    #         book = Book.create(@valid_book_params)
    #         headers = { 'ACCEPT' => 'application/json' }
    #         put api_book_path(book.id), params: {book: { name: 'Now updated'}}
    #         expect(response).to have_http_status(200)
    #         expect(JSON.parse(JSON.parse(response.body)['response']['book'] )['id']).to eq(book.id)
    #     end

    #     it 'fails if there are invalid arguments' do
    #         book = Book.create(@valid_book_params)
    #         headers = { 'ACCEPT' => 'application/json' }
    #         put api_book_path(book.id), params: { book: {name: 'Now updated', author: 'S'}}
    #         expect(response).to have_http_status(400)
    #         expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Author is too short (minimum is 3 characters)"})
    #     end
    # end

    # describe 'DELETE destroy' do
    #     it 'deletes a book' do
    #         book = Book.create(@valid_book_params)
    #         expect(Book.find(book.id)).to be_a Book
    #         delete api_book_path(book.id)
    #         expect(response).to have_http_status(200)
    #         expect{ Book.find(book.id) }.to raise_exception(ActiveRecord::RecordNotFound)
    #     end
    # end

    # describe 'GET index' do
    #     it 'lists books' do
    #         book1 = @valid_book_params.clone
    #         book1[:name] = 'book #1'

    #         book2 = @valid_book_params.clone
    #         book2[:name] = 'book #2'

    #         Book.create([book1, book2])

    #         headers = { 'ACCEPT' => 'application/json' }
    #         get api_books_path
    #         expect(JSON.parse(response.body)['response']['books']).to eq(Book.all.to_json)
    #     end
    # end

    # describe 'GET show' do
    #     it 'displays a single book' do
    #         book = Book.create(@valid_book_params)
    #         get api_book_path(book.id)
    #         expect(JSON.parse(response.body)['response']['book']).to eq(book.to_json)
    #     end
    # end
end
