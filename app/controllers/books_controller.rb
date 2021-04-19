class BooksController < ApplicationController
    def index
        @books = Book.all
        render "book/list", layout: 'application'
    end

    def show
        @book = Book.find(params[:id])
        render "book/single", layout: 'application'
    end

    def edit
        @book = Book.find(params[:id])
        @companies = Company.all
        @categories = Category.all
        render "book/form", layout: 'application'
    end

    def new
        @book = Book.new
        @companies = Company.all
        @categories = Category.all
        render "book/form", layout: 'application'
    end

    def create
        book = Book.new(book_params)
        book.save
        redirect_to book
    end

    def update
        book = Book.find(params[:id])
        book.update!(book_params)
        redirect_to book
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end

    private def book_params
        params.require(:book).require([:name, :price, :author, :category_id, :company_id])
        params.require(:book).permit!
    end
end
