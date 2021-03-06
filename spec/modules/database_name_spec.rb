require 'rails_helper'
require 'database_name'

describe DatabaseName do
  include DatabaseName

  describe 'get_program_type' do
    it { expect(get_program_type('mc_chicken')).to eq(:mc) }
    it { expect(get_program_type('op_chicken')).to eq(:op) }
    it { expect(get_program_type('dcs4_chicken')).to eq(:dcs_cli) }

    it { expect(get_program_type('mc_chicken_23')).to eq(:mc) }
    it { expect(get_program_type('op_chicken_234')).to eq(:op) }
    it { expect(get_program_type('dcs4_chicken_5435')).to eq(:dcs_cli) }

    it { expect(get_program_type('mc_chicken_a_d_d')).to eq(:mc) }
    it { expect(get_program_type('op_chicken_a_d_d')).to eq(:op) }
    it { expect(get_program_type('dcs4_chicken_a_d_d')).to eq(:dcs_cli) }

    it { expect(get_program_type('mc_chi_cken_a_d_d_35')).to eq(:mc) }
    it { expect(get_program_type('op_chi_cken_a_d_d_35')).to eq(:op) }
    it { expect(get_program_type('dcs4_chi_cken_a_d_d_35')).to eq(:dcs_cli) }
  end

  describe 'get_database_prefix' do
    it { expect(get_database_prefix('mc_chicken')).to eq('chicken') }
    it { expect(get_database_prefix('op_chicken')).to eq('chicken') }
    it { expect(get_database_prefix('dcs4_chicken')).to eq('chicken') }

    it { expect(get_database_prefix('mc_chicken_23')).to eq('chicken') }
    it { expect(get_database_prefix('op_chicken_234')).to eq('chicken') }
    it { expect(get_database_prefix('dcs4_chicken_5435')).to eq('chicken') }

    it { expect(get_database_prefix('mc_chicken_a_d_d')).to eq('chicken') }
    it { expect(get_database_prefix('op_chicken_a_d_d')).to eq('chicken') }
    it { expect(get_database_prefix('dcs4_chicken_a_d_d')).to eq('chicken') }
  end

  describe 'get_additional_name' do
    it { expect(get_additional_name('mc_chicken')).to eq('') }
    it { expect(get_additional_name('op_chicken')).to eq('') }
    it { expect(get_additional_name('dcs4_chicken')).to eq('') }

    it { expect(get_additional_name('mc_chicken_23')).to eq('') }
    it { expect(get_additional_name('op_chicken_234')).to eq('') }
    it { expect(get_additional_name('dcs4_chicken_5435')).to eq('') }
    it { expect(get_additional_name('dcs4_chicken_2_3')).to eq('2') }

    it { expect(get_additional_name('mc_chicken_a_d_d')).to eq('a_d_d') }
    it { expect(get_additional_name('op_chicken_a_d_d')).to eq('a_d_d') }
    it { expect(get_additional_name('dcs4_chicken_a_d_d')).to eq('a_d_d') }
  end

  describe 'get_program_type_to_s' do
    it { expect(get_program_type_to_s('mc_chicken')).to eq('mc') }
    it { expect(get_program_type_to_s('op_chicken')).to eq('op') }
    it { expect(get_program_type_to_s('dcs4_chicken')).to eq('dcs-cli') }
  end

  describe 'make_identification_name' do
    it { expect(make_identification_name('arch-energo', :mc, '')).to eq('arch-energo-mc') }
    it { expect(make_identification_name('arch-energo', :op, '')).to eq('arch-energo-op') }
    it { expect(make_identification_name('arch-energo', :dcs_cli, '')).to eq('arch-energo-dcs-cli') }
    it { expect(make_identification_name('arch-energo', :dcs_dev, '')).to eq('arch-energo-dcs-dev') }
    it { expect(make_identification_name('Arch-Energo', :dcs_dev, 'Fnc')).to eq('Arch-Energo-dcs-dev-Fnc') }
  end


  describe 'regexp_for_prefix' do
    it { expect(regexp_for_prefix('archenergo')).to eq(/^(?<program_type>pp_router|pp_web|pp_admin|mc|op|dcs4)_(?<prefix>archenergo)(?:_(?<add_name>[a-zA-Z_\d]+?))??(?:_(?<digit>\d*))??$/) }
  end

  describe '#parse_database_url' do
    context 'when parse right sentence' do
      before :all do
        @parse_result = parse_database_url('postgres://mcs_prod_username:iselPodij@192.168.100.10/mcs_control_production')
      end

      it { expect(@parse_result[:adapter]).to eq('postgres') }
      it { expect(@parse_result[:user_name]).to eq('mcs_prod_username') }
      it { expect(@parse_result[:host]).to eq('192.168.100.10') }
      it { expect(@parse_result[:database_name]).to eq('mcs_control_production') }
      it { expect(@parse_result[:password]).to eq('iselPodij') }
    end
  end
end
