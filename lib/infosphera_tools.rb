module InfospheraTools

  def program_type_to_s(program_type_sym)
    { mc: 'mc',
      op: 'op',
      dcs_dev: 'dcs-dev',
      pp_router: 'pp-router',
      pp_admin: 'pp-admin',
      pp_web: 'pp-web'
    }[program_type_sym]
  end
end
