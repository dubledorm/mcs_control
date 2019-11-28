RSpec.shared_examples 'any authorised user for instance' do
  context 'index' do
    it 'should read only yours records' do
      visit admin_instances_path
      sleep 2
      expect(page).to have_css('.resource_id_link', count: 2)
    end
  end

  context 'show' do
    it 'should read yours records' do
      visit admin_instance_path(id: instances[2])
      sleep 2
      expect(current_path).to eq(admin_instance_path(id: instances[2]))
    end

    it 'should not read another records' do
      visit admin_instance_path(id: instances[0])
      expect(page).to have_content(I18n.t('active_admin.access_denied.message'))
    end
  end

  context 'edit' do

    it 'should not edit another records' do
      visit edit_admin_instance_path(id: instances[0])
      expect(page).to have_content(I18n.t('active_admin.access_denied.message'))
    end
  end

  context 'new' do
    it 'should not available action new' do
      visit new_admin_instance_path
      expect(page).to have_content(I18n.t('active_admin.access_denied.message'))
    end
  end
end


RSpec.shared_examples 'any authorised user for program' do
  # context 'index' do
  #   it 'should read only yours records' do
  #     visit admin_instances_path
  #     sleep 2
  #     expect(page).to have_css('.resource_id_link', count: 2)
  #   end
  # end

  # context 'show' do
  #   it 'should read yours records' do
  #     visit admin_instance_program_path(instance_id: instances[2], id: instances[2].programs.first)
  #     sleep 2
  #     expect(page.find('h2#page_title')).to have_text(instances[2].programs.first.identification_name)
  #   end
  #
  #   it 'should not read another records' do
  #     visit admin_instance_program_path(instance_id: instances[0], id: instances[2].programs.first)
  #     sleep 2
  #     expect(page).to have_content('The page you were looking for doesn\'t exist. You may have mistyped the address or the page may have moved. If you are the application owner check the logs for more information.')
  #   end
  # end


  context 'new' do
    it 'should not available action new for available instance' do
      visit new_admin_instance_program_path(instance_id: instances[2].id)
      expect(page).to have_content(I18n.t('active_admin.access_denied.message'))
    end

    it 'should not available action new for not available instance' do
      visit new_admin_instance_program_path(instance_id: instances[0].id)
      expect(page).to have_content('The page you were looking for doesn\'t exist. You may have mistyped the address or the page may have moved. If you are the application owner check the logs for more information.')
    end
  end
  #
  # context 'check' do
  #   it 'should not check yourself records' do
  #     visit admin_instance_path(id: instances[2])
  #     click_link 'Сверить с БД'
  #     sleep(2)
  #     expect(page).to have_content('Вы не авторизованы для выполнения данного действия')
  #   end
  # end
end