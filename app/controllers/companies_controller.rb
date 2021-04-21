class CompaniesController < ApplicationController
    def index
        @companies = Company.includes(:games, :books).all
        render "company/list", layout: 'application'
    end

    def show
        @company = Company.find(params[:id])
        render "company/single", layout: 'application'
    end

    def edit
        @company = Company.find(params[:id])
        render "company/form", layout: 'application'
    end

    def new
        render "company/form", layout: 'application'
    end

    def create
        company = Company.new(params.require(:company).permit!)
        if !company.save
            raise ActiveRecord::RecordInvalid
        else
            redirect_to company
        end
    end

    def update
        company = Company.find(params[:id])
        company.update!(params.require(:company).permit!)
        redirect_to company
    end

    def destroy
        company = Company.find(params[:id])
        company.destroy
        redirect_to companies_path
    end
end
