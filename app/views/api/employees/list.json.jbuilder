json.array! @employees  do |employee|
    json.id employee.id
    json.name employee.name
    # json.tags employee.tags do |tag|
    #     json.id tag.id
    #     json.name tag.name
    # end
end