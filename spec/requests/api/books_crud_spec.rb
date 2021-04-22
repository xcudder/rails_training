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
        subject { post api_books_path, params: params }

        before do
            subject
        end

        context 'when creates book successfully' do
            it 'creates a new book' do
                expect(Book.find_by(name: book_name)).to be_a Book
            end

            it 'returns the created book as json' do
                is_expected.to eq(201)
                expect(JSON.parse(response.body)['response']['book'] ).to eq(Book.find_by_name(book_name).to_json)
            end
        end

        context 'when creates book fails' do
            let(:params) do
                { book: { name: "Lalala" } }
            end

            it 'fails if there are missing arguments' do
                is_expected.to eq(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"company\":[\"must exist\"],\"category\":[\"must exist\"],\"author\":[\"is too short (minimum is 3 characters)\"],\"price\":[\"can't be blank\"]}}}")
            end
        end
    end

    describe 'PUT update' do
        subject { put api_book_path(pre_existing_book.id), params: params }

        before do
            subject
        end

        context 'when book is successfully updated' do
            let(:params) do
                { book: { name: "Now updated" } }
            end

            it 'updates a book' do
                is_expected.to eq(204)
                expect(Book.find_by(name: 'Now updated')).to be_a Book
            end
        end

        context 'when book is not successfully updated' do
            let(:params) do
                { book: { name: "Now updated", author: "S" } }
            end

            it 'fails if there are invalid arguments' do
                 is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Author is too short (minimum is 3 characters)"})
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete api_book_path(pre_existing_book.id) }

        it 'deletes a book' do
            subject
            is_expected.to eq(200)
            expect{ Book.find(pre_existing_book.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        subject { get api_books_path }

        it 'lists books' do
            subject
            expect(JSON.parse(response.body)['response']['books']).to eq(Book.all.to_json)
        end
    end

    describe 'GET show' do
        subject {  get api_book_path(pre_existing_book.id) }

        it 'displays a single book' do
            subject
            expect(JSON.parse(response.body)['response']['book']).to eq(pre_existing_book.to_json)
        end
    end
end
