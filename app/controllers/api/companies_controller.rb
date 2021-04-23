class Api::CompaniesController < ApplicationController
    def index
        @companies = Company.all
        render "api/companies/list"
    end

    def show
        @company = Company.find(params[:id])
        render "api/companies/show"
    end

    def create
        company = Company.new(params.require(:company).permit!)
        if !company.save
            render :json => {:response => {:errors => company.errors }},:status => 400
        else
            render :json => {:response => { :company => company.to_json }},:status => 201
        end
    end

    def update
        company = Company.find(params[:id])
        begin
            company.update!(params.require(:company).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end

    def destroy
        company = Company.find(params[:id])
        company.destroy
        render :json => {:response => "Success" },:status => 200
    end
end
