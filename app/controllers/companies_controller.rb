class CompaniesController < ApplicationController
    def index
        @companies = Company.includes(:games, :books).all
        render "company/list"
    end

    def show
        @company = Company.find(params[:id])
        render "company/single"
    end

    def edit
        @company = Company.find(params[:id])
        render "company/form"
    end

    def new
        render "company/form"
    end

    def create
        company = Company.new(company_params)
        company.save
        redirect_to company
    end

    def update
        company = Company.find(params[:id])
        company.update!(company_params)
        redirect_to company
    end

    def destroy
        company = Company.find(params[:id])
        company.destroy
        redirect_to companies_path
    end

    private def company_params
        params.require(:company).permit(:name)
    end
end
