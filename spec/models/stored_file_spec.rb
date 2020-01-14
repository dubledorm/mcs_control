require 'rails_helper'
require 'file_tools'

describe StoredFile do
  describe 'factory' do
    let!(:stored_file) {FactoryGirl.create :stored_file}

    # Factories
    it { expect(stored_file).to be_valid }

    # Validations
    it { should validate_presence_of(:filename) }
    it { should validate_presence_of(:content_type) }
    it { should validate_presence_of(:state) }

    # Relationships
    it {should belong_to(:program)}
    it {should belong_to(:admin_user)}
  end

  describe 'attach_file' do
    let!(:stored_file) {FactoryGirl.create :stored_file}
    before :each do
      @file = FileTools::create_and_fill_tmp_file('Hello world!')
      stored_file.file.attach(io: File.open(@file.path), filename: File.basename(@file.path))
    end

    after :each do
      FileTools::remove_file(@file)
    end

    it { expect(stored_file.file.attached?).to eq(true) }
  end
end
