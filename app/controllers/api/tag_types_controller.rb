class Api::TagTypesController < ApplicationController
    def index
        @tag_types = TagType.all
        render "api/tag_types/list"
    end
end
