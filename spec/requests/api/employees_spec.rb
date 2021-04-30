require 'rails_helper'

RSpec.describe 'employee request', type: :request  do
    let(:tag_types) do
        TagType.create [{name: 'project'}, {name: 'country'}, {name: 'role'}]
    end

    let(:employee_name) { 'Newest employee!' }
    let(:employee) {{ name: employee_name }}
    let(:pre_existing_employee){ Employee.create(employee) }
    let(:params){{ employee: employee}}

    let(:tags) do
        Tag.create [
            {name: 'Some project',  tag_type_id: tag_types[0].id},
            {name: 'Some country',  tag_type_id: tag_types[1].id},
            {name: 'Some role',     tag_type_id: tag_types[2].id}
        ]
    end

    let(:tagged_employee) do
        tagged = Employee.create(name: 'Jeremiah')
        tagged.tags = tags
        tagged
    end

    describe 'POST create' do
        subject { post api_employees_path, params: params }

        before do
            subject
        end

        context 'when creates employee successfully' do
            it 'creates a new employee' do
                expect(Employee.find_by(name: employee_name)).to be_a Employee
            end

            it 'returns the created employee as json' do
                is_expected.to eq(201)
                expect(JSON.parse(response.body)['response']['employee'] ).to eq(Employee.find_by_name(employee_name).to_json)
            end
        end

        context 'when creates employee fails' do
            let(:params) do
                { employee: { name: "" } }
            end

            it 'fails if there are missing arguments' do
                is_expected.to eq(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"name\":[\"can't be blank\",\"is too short (minimum is 3 characters)\"]}}}")
            end
        end
    end

    describe 'PUT update' do
        subject { put api_employee_path(pre_existing_employee.id), params: params }

        before do
            subject
        end

        context 'when employee is successfully updated' do
            let(:params) do
                { employee: { name: "Now updated" } }
            end

            it 'updates a employee' do
                is_expected.to eq(204)
                expect(Employee.find_by(name: 'Now updated')).to be_a Employee
            end
        end

        context 'when employee is not successfully updated' do
            let(:params) do
                { employee: { name: "" } }
            end

            it 'fails if there are invalid arguments' do
                is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Name can't be blank, Name is too short (minimum is 3 characters)"})
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete api_employee_path(pre_existing_employee.id) }

        it 'deletes a employee' do
            subject
            is_expected.to eq(200)
            expect{ Employee.find(pre_existing_employee.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        subject { get api_employees_path }

        it 'renders the correct view' do
            expect(subject).to render_template('api/employees/list')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Employee.select('id, name').all.to_json)
        end
    end

    describe 'GET show' do
        subject {  get api_employee_path(pre_existing_employee.id) }

        it 'renders the correct view' do
            expect(subject).to render_template('api/employees/show')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Employee.select('id, name').find(pre_existing_employee.id).to_json)
        end
    end

    describe 'GET tags' do
        subject {  get tags_api_employee_path(tagged_employee.id) }

        it 'renders the correct view' do
            expect(subject).to render_template('api/employees/tags')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Employee.find(tagged_employee.id).tags.select('id, name').to_json)
        end
    end

    describe 'PUT tags' do
        subject {  put tags_api_employee_path(tagged_employee.id), params: params }

        before do
            subject
        end

        context 'when an empty tags property is passed on' do
            let(:params){{tags:[]}}

            it 'empties the employee\'s tags' do
                expect(Employee.find(tagged_employee.id).tags.count).to be 0
            end
        end

        context 'when new tags are passed on' do
            let(:params){{tags:[tags[0].id, tags[1].id]}}

            it 'it replaces the old tags for the new ones' do
                expect(Employee.find(tagged_employee.id).tags).to contain_exactly(tags[0], tags[1])
            end
        end

        context 'when invalid tags are passed on' do
            let(:params){{tags:[0]}}

            it 'fails if there are invalid arguments' do
                is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Couldn't find Tag with 'id'=0"})
            end
        end
    end
end
