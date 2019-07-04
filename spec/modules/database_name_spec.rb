require 'rails_helper'
require 'database_name'

describe DatabaseName do
  include DatabaseName

  describe 'get_program_type' do
    it { expect(get_program_type('chicken_mc')).to eq(:mc) }
    it { expect(get_program_type('chicken_op')).to eq(:op) }
    it { expect(get_program_type('chicken_dcs4')).to eq(:dcs_cli) }

    it { expect(get_program_type('chicken_mc_23')).to eq(:mc) }
    it { expect(get_program_type('chicken_op_234')).to eq(:op) }
    it { expect(get_program_type('chicken_dcs4_5435')).to eq(:dcs_cli) }

    it { expect(get_program_type('chicken_mc_a_d_d')).to eq(:mc) }
    it { expect(get_program_type('chicken_op_a_d_d')).to eq(:op) }
    it { expect(get_program_type('chicken_dcs4_a_d_d')).to eq(:dcs_cli) }

    it { expect(get_program_type('chi_cken_mc_a_d_d_35')).to eq(:mc) }
    it { expect(get_program_type('chi_cken_op_a_d_d_35')).to eq(:op) }
    it { expect(get_program_type('chi_cken_dcs4_a_d_d_35')).to eq(:dcs_cli) }
  end

  describe 'get_database_prefix' do
    it { expect(get_database_prefix('chicken_mc')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_op')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_dcs4')).to eq('chicken') }

    it { expect(get_database_prefix('chicken_mc_23')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_op_234')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_dcs4_5435')).to eq('chicken') }

    it { expect(get_database_prefix('chicken_mc_a_d_d')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_op_a_d_d')).to eq('chicken') }
    it { expect(get_database_prefix('chicken_dcs4_a_d_d')).to eq('chicken') }

    it { expect(get_database_prefix('chi_cken_mc_a_d_d_35')).to eq('chi_cken') }
    it { expect(get_database_prefix('chi_cken_op_a_d_d_35')).to eq('chi_cken') }
    it { expect(get_database_prefix('chi_cken_dcs4_a_d_d_35')).to eq('chi_cken') }
  end

  describe 'get_additional_name' do
    it { expect(get_additional_name('chicken_mc')).to eq('') }
    it { expect(get_additional_name('chicken_op')).to eq('') }
    it { expect(get_additional_name('chicken_dcs4')).to eq('') }

    it { expect(get_additional_name('chicken_mc_23')).to eq('') }
    it { expect(get_additional_name('chicken_op_234')).to eq('') }
    it { expect(get_additional_name('chicken_dcs4_5435')).to eq('') }

    it { expect(get_additional_name('chicken_mc_a_d_d')).to eq('a_d_d') }
    it { expect(get_additional_name('chicken_op_a_d_d')).to eq('a_d_d') }
    it { expect(get_additional_name('chicken_dcs4_a_d_d')).to eq('a_d_d') }

    it { expect(get_additional_name('chi_cken_mc_a_d_d_35')).to eq('a_d_d') }
    it { expect(get_additional_name('chi_cken_op_a_d_d_35')).to eq('a_d_d') }
    it { expect(get_additional_name('chi_cken_dcs4_a_d_d_35')).to eq('a_d_d') }
  end

  describe 'get_program_type_to_s' do
    it { expect(get_program_type_to_s('chicken_mc')).to eq('mc') }
    it { expect(get_program_type_to_s('chicken_op')).to eq('op') }
    it { expect(get_program_type_to_s('chicken_dcs4')).to eq('dcs-cli') }
  end

  describe 'make_identification_name' do
    it { expect(make_identification_name('arch-energo', :mc, '')).to eq('arch-energo-mc') }
    it { expect(make_identification_name('arch-energo', :op, '')).to eq('arch-energo-op') }
    it { expect(make_identification_name('arch-energo', :dcs_cli, '')).to eq('arch-energo-dcs-cli') }
    it { expect(make_identification_name('arch-energo', :dcs_dev, '')).to eq('arch-energo-dcs-dev') }
  end
end
