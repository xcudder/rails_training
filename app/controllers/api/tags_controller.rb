class Api::TagsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @tags = Tag.includes(:employees).all
        render "api/tags/list"
    end

    def show
        @tag = Tag.includes(:employees).find(params[:id])
        render "api/tags/show"
    end

    def create
        tag = Tag.new(params.require(:tag).permit!)
        if !tag.save
            render :json => {:response => {:errors => tag.errors }},:status => 400
        else
            render :json => {:response => { :tag => tag.to_json }},:status => 201
        end
    end

    def update
        tag = Tag.find(params[:id])
        begin
            tag.update!(params.require(:tag).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end

    def destroy
        tag = Tag.find(params[:id])
        tag.destroy
        render :json => {:response => "Success" },:status => 200
    end

    def employees
        @tag = Tag.includes(:employees).find(params[:id])
        render "api/tags/employees"
    end

    def associate_employees
        begin
            tag = Tag.find(params[:id])
            tag.employees = Employee.find(params[:employees].select{|id| id != ''})
        rescue ActiveRecord::RecordNotFound => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end
end
