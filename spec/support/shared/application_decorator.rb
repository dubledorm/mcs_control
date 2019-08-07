RSpec.shared_examples 'application_decorator' do
  include ActionView::Helpers::SanitizeHelper

  describe '#collate_base_status' do
    context 'when db_status is blank' do
      it 'should return :undefined' do
        subject.db_status = nil
        expect(strip_tags(subject.decorate.collate_base_status)).to eq(ApplicationDecorator::DB_STATUS_TRANSLATE[:undefined])
      end
    end

    context 'when db_status is not empty' do
      it 'should return value' do
        subject.db_status = ApplicationDecorator::DB_STATUS_TRANSLATE.keys[0]
        expect(strip_tags(subject.decorate.collate_base_status)).to eq(ApplicationDecorator::DB_STATUS_TRANSLATE.values[0])
      end
    end
  end
end