class Api::CompaniesController < ApplicationController
    def index
        @companies = Company.all
        render :json => {:response => { :companies => @companies.to_json }},:status => 200
    end

    def show
        @company = Company.find(params[:id])
        render :json => {:response => { :company => @company.to_json }},:status => 200
    end

    def create
        company = Company.new(params.require(:company).permit!)
        if !company.save
            render :json => {:response => {:errors => company.errors }},:status => 400
        else
            render :json => {:response => { :company => company.to_json }},:status => 200
        end
    end

    def update
        company = Company.find(params[:id])
        company.update!(params.require(:company).permit!)
        render :json => {:response => { :company => company.to_json }},:status => 200
    end

    def destroy
        company = Company.find(params[:id])
        company.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
