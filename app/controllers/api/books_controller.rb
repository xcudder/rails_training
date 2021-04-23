class Api::BooksController < ApplicationController
    def index
        @books = Book.all
        render "api/books/list"
    end

    def show
        @book = Book.find(params[:id])
        render "api/books/show"
    end

    def create
        book = Book.new(params.require(:book).permit!)
        if !book.save
            render :json => {:response => {:errors => book.errors }},:status => 400
        else
            render :json => {:response => { :book => book.to_json }},:status => 201
        end
    end

    def update
        book = Book.find(params[:id])
        begin
            book.update!(params.require(:book).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
