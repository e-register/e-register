# Check if the :klass_name model is invalid if the :fields are not unique
# It checks against each pair(field, value) if a record with the same fields
# in the database cause the not-valid status
# Params:
#   - klass_name: a symbol with the name of the model to check
#   - fields: a symbol or an array of symbols with the attributes to check
#   - values: a value or an array of values to check with the corresponding field
#   - opt: optional
#       - create_method: :factory or :new. If it is :factory it will use FactoryGirl
#            to create and build instances. If :new it will use Class.new and Class.create!
#       - create_params: other params to give to the creation method. The fields specified
#            above will overwrite this ones
#
def check_unique_field(klass_name, fields, values, opt = {})
  opt[:create_method] ||= 'factory'
  opt[:create_params] ||= {}

  opt[:create_method] = opt[:create_method].to_s

  Array(fields).zip(Array(values)).each do |field, value|
    it "has unique field '#{field}'" do
      params = opt[:create_params].merge({ "#{field}" => value })
      if opt[:create_method] == 'factory'
        create(klass_name, params)
        x = build(klass_name, params)
      elsif opt[:create_method] == 'new'
        klass = klass_name.to_s.split("_").collect(&:capitalize).join.constantize
        klass.create!(params)
        x = klass.new(params)
      else
        raise "Unknown generation mode #{opt[:create_method].inspect}"
      end

      expect(x).not_to be_valid
    end
  end
end

# Check if the :klass_name model is invalid if the :fields are missing
# Params:
#   - klass_name: a symbol with the name of the model to check
#   - fields: a symbol or an array of symbols with the attributes to check
#   - value: a value to set the fields, default: nil
#   - opt: optional
#       - create_method: :factory or :new. If it is :factory it will use FactoryGirl
#            to create and build instances. If :new it will use Class.new and Class.create!
#       - create_params: other params to give to the creation method. The fields specified
#            above will overwrite this ones
#
def check_required_field(klass_name, fields, value = nil, opt = {})
  opt[:create_method] ||= 'factory'
  opt[:create_params] ||= {}

  opt[:create_method] = opt[:create_method].to_s

  Array(fields).each do |field|
    it "is invalid without '#{field}'" do
      params = opt[:create_params].merge({ "#{field}" => value })

      if opt[:create_method] == 'factory'
        x = build(klass_name, params)
      elsif opt[:create_method] == 'new'
        klass = klass_name.to_s.split("_").collect(&:capitalize).join.constantize
        x = klass.new(params)
      else
        raise "Unknown generation mode #{opt[:create_method].inspect}"
      end

      expect(x).not_to be_valid
    end
  end

end
