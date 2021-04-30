require 'rails_helper'

RSpec.describe 'tag request', type: :request  do
    let(:tag_types) do
        TagType.create [{name: 'project'}, {name: 'country'}, {name: 'role'}]
    end

    let(:tag_name) { 'Newest tag!' }
    let(:tag) {{ name: tag_name, tag_type_id: tag_types.first.id }}
    let(:pre_existing_tag){ Tag.create(tag) }
    let(:params){{ tag: tag}}

    let(:employees) do
        Employee.create [{name:'Jonas'},{name:'Jota'},{name:'Jameson'}]
    end

    let(:tag_with_employees) do
        t = Tag.create(name: 'Whole world', tag_type_id: tag_types[1].id )
        t.employees = employees
        t
    end

    describe 'POST create' do
        subject { post api_tags_path, params: params }

        before do
            subject
        end

        context 'when creates tag successfully' do
            it 'creates a new tag' do
                expect(Tag.find_by(name: tag_name)).to be_a Tag
            end

            it 'returns the created tag as json' do
                is_expected.to eq(201)
                expect(JSON.parse(response.body)['response']['tag'] ).to eq(Tag.find_by_name(tag_name).to_json)
            end
        end

        context 'when creates tag fails' do
            let(:params) do
                { tag: { name: "" } }
            end

            it 'fails if there are missing arguments' do
                is_expected.to eq(400)
                expect(response.body).to eq("{\"response\":{\"errors\":{\"tag_type\":[\"must exist\"],\"name\":[\"can't be blank\",\"is too short (minimum is 3 characters)\"]}}}")
            end
        end
    end

    describe 'PUT update' do
        subject { put api_tag_path(pre_existing_tag.id), params: params }

        before do
            subject
        end

        context 'when tag is successfully updated' do
            let(:params) do
                { tag: { name: "Now updated" } }
            end

            it 'updates a tag' do
                is_expected.to eq(204)
                expect(Tag.find_by(name: 'Now updated')).to be_a Tag
            end
        end

        context 'when tag is not successfully updated' do
            let(:params) do
                { tag: { name: "" } }
            end

            it 'fails if there are invalid arguments' do
                 is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Validation failed: Name can't be blank, Name is too short (minimum is 3 characters)"})
            end
        end
    end

    describe 'DELETE destroy' do
        subject { delete api_tag_path(pre_existing_tag.id) }

        it 'deletes a tag' do
            subject
            is_expected.to eq(200)
            expect{ Tag.find(pre_existing_tag.id) }.to raise_exception(ActiveRecord::RecordNotFound)
        end
    end

    describe 'GET index' do
        subject { get api_tags_path }

        it 'renders the correct view' do
            expect(subject).to render_template('api/tags/list')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Tag.all.to_json)
        end
    end

    describe 'GET show' do
        subject {  get api_tag_path(pre_existing_tag.id) }

        it 'renders the correct view' do
            expect(subject).to render_template('api/tags/show')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Tag.select('id, name').find(pre_existing_tag.id).to_json)
        end
    end

    describe 'GET employees' do
        subject {  get employees_api_tag_path(tag_with_employees.id) }

        it 'renders the correct view' do
            expect(subject).to render_template('api/tags/employees')
        end

        it 'loads the proper data' do
            subject
            expect(response.body).to include(Tag.find(tag_with_employees.id).employees.select('id, name').to_json)
        end
    end

    describe 'PUT employees' do
        subject {  put employees_api_tag_path(tag_with_employees.id), params: params }

        before do
            subject
        end

        context 'when an empty employees property is passed on' do
            let(:params){{employees:[]}}

            it 'empties the tag\'s employees' do
                expect(Tag.find(tag_with_employees.id).employees.count).to be 0
            end
        end

        context 'when new employees are passed on' do
            let(:params){{employees:[employees[0].id, employees[1].id]}}

            it 'it replaces the old tags for the new ones' do
                expect(Tag.find(tag_with_employees.id).employees).to contain_exactly(employees[0], employees[1])
            end
        end

        context 'when invalid employees are passed on' do
            let(:params){{employees:[0]}}

            it 'fails if there are invalid arguments' do
                is_expected.to eq(400)
                expect(JSON.parse(response.body)).to eq("response" => {"errors"=>"Couldn't find Employee with 'id'=0"})
            end
        end
    end
end
