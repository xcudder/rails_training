class Api::BooksController < ApplicationController
    def index
        @books = Book.all
        render :json => {:response => { :books => @books.to_json }},:status => 200
    end

    def show
        @book = Book.find(params[:id])
        render :json => {:response => { :book => @book.to_json }},:status => 200
    end

    def create
        book = Book.new(params.require(:book).permit!)
        if !book.save
            render :json => {:response => {:errors => book.errors }},:status => 400
        else
            render :json => {:response => { :book => book.to_json }},:status => 200
        end
    end

    def update
        book = Book.find(params[:id])
        book.update!(params.require(:book).permit!)
        render :json => {:response => { :book => book.to_json }},:status => 200
    end

    def destroy
        book = Book.find(params[:id])
        book.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
