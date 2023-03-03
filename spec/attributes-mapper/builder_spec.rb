# frozen_string_literal: true

module AttributesMapper
  RSpec.describe Builder do
    let(:subject_class) do
      Class.new(described_class) do
        configure do |config|
          config.required_attributes = %i[name email]
          config.optional_attributes = %i[age key]
          config.scopes = { profile: 'user.profile', info: 'user.info' }
        end

        name { { from: :username, scope: :profile } }
        email { { from: :email, scope: :profile } }
        age { { from: :age, scope: :info } }
        key { { from: :key } }
      end
    end

    let(:name) { 'Joe Bloggs' }
    let(:email) { 'joe@email.com' }
    let(:age) { 23 }
    let(:value) { 'some-value' }
    let(:input) { { user: { profile: { username: name, email: email }, info: { age: age } }, key: value } }

    subject(:built_builder) { subject_class.new(input).build }

    describe '#build' do
      it 'handles simple mappings' do
        expect(built_builder.key).to eql(value)
      end

      it 'handle nested paths via declared scopes' do
        expect(built_builder.name).to eql(name)
        expect(built_builder.email).to eql(email)
        expect(built_builder.age).to eql(age)
      end
    end

    describe '#to_h' do
      it 'maps input to the specified paths' do
        expect(built_builder.to_h).to eq({ name: name, email: email, age: age, key: value })
      end
    end

    describe '#method_missing' do
      it 'returns the value of a mapped key' do
        expect(built_builder.key).to eq(value)
      end

      it 'raises an error when the key does not exist' do
        expect { built_builder.baz }.to raise_error(NoMethodError)
      end
    end

    describe '#respond_to_missing?' do
      it 'returns true when the key exists' do
        expect(built_builder.respond_to?(:name)).to be true
      end

      it 'returns false when the key does not exist' do
        expect(built_builder.respond_to?(:baz)).to be false
      end
    end
  end
end
