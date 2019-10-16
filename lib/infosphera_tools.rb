module InfospheraTools

  def program_type_to_s(program_type_sym)
    { mc: 'mc',
      op: 'op',
      dcs_dev: 'dcs-dev',
      dcs_cli: 'dcs-cli' }[program_type_sym]
  end
end
