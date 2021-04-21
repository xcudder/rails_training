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
        book = Book.new(params.require(:book).permit!)
        if !book.save
            raise ActiveRecord::RecordInvalid
        else
            redirect_to book
        end
    end

    def update
        book = Book.find(params[:id])
        book.update!(params.require(:book).permit!)
        redirect_to book
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        redirect_to books_path
    end
end
