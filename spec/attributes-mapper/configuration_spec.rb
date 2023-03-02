# frozen_string_literal: true

# rubocop:disable RSpec/NamedSubject
module AttributesMapper
  RSpec.describe Configuration do
    describe '.scopes' do
      it 'returns a hash' do
        expect(described_class.scopes).to be_a(Hash)
      end
    end

    describe '.source_data_wrapper_class' do
      it 'returns nil by default' do
        expect(described_class.source_data_wrapper_class).to be_nil
      end
    end

    describe '#source_data_wrapper_class?' do
      context 'when source_data_wrapper_class is set' do
        before { subject.source_data_wrapper_class = 'WrapperClass' }

        it 'returns true' do
          expect(subject.source_data_wrapper_class?).to be_truthy
        end
      end

      context 'when source_data_wrapper_class is not set' do
        it 'returns false' do
          expect(subject.source_data_wrapper_class?).to be_falsey
        end
      end
    end

    describe '.apply_input_data_transform_proc' do
      it 'returns nil by default' do
        expect(described_class.apply_input_data_transform_proc).to be_nil
      end
    end

    describe '#apply_input_data_transform?' do
      context 'when apply_input_data_transform_proc is set' do
        before { subject.apply_input_data_transform_proc = proc {} }

        it 'returns true' do
          expect(subject.apply_input_data_transform?).to be_truthy
        end
      end

      context 'when apply_input_data_transform_proc is not set' do
        it 'returns false' do
          expect(subject.apply_input_data_transform?).to be_falsey
        end
      end
    end
  end
  # rubocop:enable RSpec/NamedSubject
end

