require 'rails_helper'

describe Instance do

  describe 'standard call' do
    let!(:instance) {FactoryGirl.create :instance, name: 'chicken' }

    it 'should not generate exception' do
      # noinspection SpellCheckingInspection
      expect{Instance::CreateDbUserInteractor.call(instance: instance)}.not_to raise_error
    end

    it 'should return true' do
      # noinspection SpellCheckingInspection
      expect(Instance::CreateDbUserInteractor.call(instance: instance).success?).to be(true)
    end

    it 'should return error code' do
      instance.name = nil
      # noinspection SpellCheckingInspection
      result = Instance::CreateDbUserInteractor.call(instance: instance)
      puts 'Отладочная печать: '
      puts result.message
      expect(result.message).to_not eq('')
    end

    it 'test print for password' do
      # noinspection SpellCheckingInspection
      result = Instance::CreateDbUserInteractor.call(instance: instance)
      puts 'Пароль: '
      puts result.instance.db_user_password
    end
  end
end
