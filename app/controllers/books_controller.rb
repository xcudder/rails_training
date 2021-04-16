class BooksController < ApplicationController
    def index
        @books = Book.all
        render "book/list"
    end

    def show
        @book = Book.find(params[:id])
        render "book/single"
    end

    def edit
        @book = Book.find(params[:id])
        @companies = Company.all
        @categories = Category.all
        render "book/form"
    end

    def new
        @companies = Company.all
        @categories = Category.all
        render "book/form"
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
