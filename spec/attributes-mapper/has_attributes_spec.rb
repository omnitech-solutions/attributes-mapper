# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module AttributesMapper
  # rubocop:disable Layout/LineLength,RSpec/StubbedMock,RSpec/MessageSpies
  RSpec.describe HasAttributes do
    describe 'ClassMethods' do
      let(:subject_class) do
        Class.new do
          include HasAttributes

          configure do |config|
            config.required_attributes = %i[name age]
            config.optional_attributes = [:email]
            config.scopes = { profile: 'user.profile' }
          end

          name { { from: :username } }
          age { { from: :age } }
          email { { from: :email } }
        end
      end

      describe ".required_attributes" do
        it "returns an empty hash when @required_attributes is not set" do
          expect(subject_class.required_attributes).to eq(%i[name age])
        end

        it "returns the value of @required_attributes when it is set" do
          subject_class.instance_variable_set(:@required_attributes, %i[name age])
          expect(subject_class.configuration.required_attributes).to eq(%i[name age])
        end
      end

      describe ".optional_attributes" do
        it "returns an empty hash when @optional_attributes is not set" do
          expect(subject_class.optional_attributes).to eq([:email])
        end

        it "returns the value of @optional_attributes when it is set" do
          subject_class.instance_variable_set(:@optional_attributes, [:email])
          expect(subject_class.optional_attributes).to eq([:email])
        end
      end

      describe ".required_attributes=" do
        it "sets the value of @required_attributes" do
          subject_class.configure do |config|
            config.required_attributes = %i[username other]
          end

          expect(subject_class.required_attributes).to eq(%i[username other])
        end
      end

      describe ".optional_attributes=" do
        it "sets the value of @optional_attributes" do
          expect(subject_class.optional_attributes).to eq([:email])
        end
      end

      describe ".ordered_path_context_names" do
        it "returns the concatenation of required_attributes and optional_attributes" do
          subject_class.configure do |config|
            config.required_attributes = %i[username other]
            config.optional_attributes = [:key]
          end

          expect(subject_class.ordered_path_context_names).to eq(%i[username other key])
        end
      end

      describe ".path_context_attr_list_map" do
        it "returns an empty hash when @path_context_attr_list_map is not set" do
          expect(subject_class.path_context_attr_list_map).to eq({ age: { from: :age }, email: { from: :email },
                                                                   name: { from: :username } })
        end

        it "returns the value of @path_context_attr_list_map when it is set" do
          subject_class.instance_variable_set(:@path_context_attr_list_map, { user: { name: String, age: Integer } })
          expect(subject_class.path_context_attr_list_map).to eq({ user: { name: String, age: Integer } })
        end
      end

      describe ".path_context_params_for" do
        it "returns the value for the specified key in path_context_attr_list_map" do
          subject_class.path_context_attr_list_map = { user: { from: :user } }
          expect(subject_class.path_context_params_for(:user)).to eq({ from: :user })
        end

        it "returns nil if the specified key is not in path_context_attr_list_map" do
          expect(subject_class.path_context_params_for(:unknown)).to be_nil
        end
      end

      describe ".each_path_context_key_value_pair" do
        it "yields each key-value pair in path_context_attr_list_map that is included in ordered_path_context_names" do
          subject_class.path_context_attr_list_map = { name: { from: :name }, age: { from: :age },
                                                       email: { from: :email }, other: { from: :other } }
          expect do |b|
            subject_class.each_path_context_key_value_pair(&b)
          end.to yield_successive_args([:name, { from: :name }], [:age, { from: :age }], [:email, { from: :email }])
        end
      end

      describe ".add_path_context_attrs" do
        it "adds a new key-value pair to path_context_attr_list_map" do
          subject_class.add_path_context_attrs(:user, { from: :username })
          expect(subject_class.path_context_attr_list_map).to include(user: { from: :username })
        end

        it "returns self" do
          expect(subject_class.add_path_context_attrs(:user, name: String, age: Integer)).to eq(subject_class)
        end
      end

      describe ".find_path_by_scope_name" do
        it "returns the path scope for the specified name" do
          expect(subject_class.find_path_by_scope_name(:profile)).to eq("user.profile")
        end
      end

      describe ".define_attribute_methods" do
        it "defines attribute methods for each name in ordered_path_context_names" do
          subject_class.configure do |config|
            config.required_attributes = %i[username other]
            config.optional_attributes = [:key]
          end

          expect(subject_class).to receive(:define_attribute_method).with(:username)
          expect(subject_class).to receive(:define_attribute_method).with(:other)
          expect(subject_class).to receive(:define_attribute_method).with(:key)
          subject_class.define_attribute_methods
        end
      end

      describe ".define_attribute_method" do
        it "defines an attribute method with the specified name" do
          expect(subject_class.singleton_class).to receive(:define_method).with(:name).and_return(nil)
          subject_class.define_attribute_method(:name)
        end
      end

      describe ".apply_attribute" do
        it "adds the specified params to path_context_attr_list_map for the specified name" do
          expect(subject_class).to receive(:add_path_context_attrs).with(:name, :from => :name, :transform => :capitalize,
                                                                                HasAttributes::SCOPE => :users).and_return(nil)
          subject_class.apply_attribute(:name, :from => :name, :transform => :capitalize,
                                               HasAttributes::SCOPE => :users)
        end

        it "returns nil" do
          expect(subject_class.apply_attribute(:name, :from => :name, :transform => :capitalize,
                                                      HasAttributes::SCOPE => :users)).to be_nil
        end
      end
    end
  end
  # rubocop:enable Layout/LineLength,RSpec/StubbedMock,RSpec/MessageSpies
end
# rubocop:enable Metrics/ModuleLength

