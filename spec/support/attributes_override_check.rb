def attributes_override_check(opt = {})
  raise Exception unless opt[:base_class]
  raise Exception unless opt[:base_attribute]
  raise Exception unless opt[:super_attribute]
  raise Exception unless opt[:base_value]
  opt[:super_class] ||= opt[:super_attribute]
  opt[:base_params] ||= []
  opt[:super_params] ||= []

  it "returns the superclass '#{opt[:base_attribute]}' if missing" do
    base_class = create(opt[:base_class], *opt[:base_params])
    super_class = create(opt[:super_class], *opt[:super_params])

    base_class.send("#{opt[:super_attribute]}=", super_class)
    base_class.send("#{opt[:base_attribute]}=", nil)

    expect(base_class.send("#{opt[:base_attribute]}")).to eq(super_class.send(opt[:base_attribute]))
  end

  it "returns the subclass '#{opt[:base_attribute]}' if present" do
    base_class = create(opt[:base_class], *opt[:base_params])
    super_class = create(opt[:super_class], *opt[:super_params])

    opt[:base_value].save! if opt[:save_base_value]

    base_class.send("#{opt[:super_attribute]}=", super_class)
    base_class.send("#{opt[:base_attribute]}=", opt[:base_value])

    # expect(base_class.send("#{opt[:base_attribute]}")).to eq(opt[:base_value])
    expect(base_class.send("#{opt[:base_attribute]}")).not_to eq(super_class.send(opt[:base_attribute]))
  end

  it "returns #{opt[:default_value].inspect} if '#{opt[:base_attribute]}' is missing" do
    base_class = create(opt[:base_class], *opt[:base_params])
    base_class.send("#{opt[:base_attribute]}=", nil)
    base_class.send("#{opt[:super_attribute]}=", nil)
    expect(base_class.send("#{opt[:base_attribute]}")).to eq(opt[:default_value])
  end
end
