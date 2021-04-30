class Api::EmployeesController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @employees = Employee.includes(:tags).all
        render "api/employees/list"
    end

    def show
        @employee = Employee.includes(:tags).find(params[:id])
        render "api/employees/show"
    end

    def create
        employee = Employee.new(params.require(:employee).permit!)
        if !employee.save
            render :json => {:response => {:errors => employee.errors }},:status => 400
        else
            render :json => {:response => { :employee => employee.to_json }},:status => 201
        end
    end

    def update
        employee = Employee.find(params[:id])
        begin
            employee.update!(params.require(:employee).permit!)
        rescue ActiveRecord::RecordInvalid => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end

    def destroy
        employee = Employee.find(params[:id])
        employee.destroy
        render :json => {:response => "Success" },:status => 200
    end

    def tags
        @employee = Employee.includes(:tags).find(params[:id])
        render "api/employees/tags"
    end

    def associate_tags
        begin
            employee = Employee.find(params[:id])
            employee.tags = Tag.find(params[:tags].select{|id| id != ''})
        rescue ActiveRecord::RecordNotFound => e
            render :json => {:response => {:errors => e.message }},:status => 400
        else
            head :no_content
        end
    end
end
