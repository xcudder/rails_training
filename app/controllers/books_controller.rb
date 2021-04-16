class BooksController < ApplicationController
    def index
        @books = Book.includes(:games, :books).all
        render "book/list"
    end

    def show
        @book = Book.find(params[:id])
        render "book/single"
    end

    def edit
        @book = Book.find(params[:id])
        render "book/form"
    end

    def new
        render "book/form"
    end

    def create
        book = Book.new(book_params)
        Book.save
        redirect_to book
    end

    def update
        book = Book.find(params[:id])
        Book.update!(book_params)
        redirect_to book
    end

    def destroy
        book = Book.find(params[:id])
        Book.destroy
        redirect_to companies_path
    end

    private def book_params
        params.require(:book).permit(:name)
    end
end
