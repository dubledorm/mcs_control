require 'database_tools'

module Pf2
  class PrepareService
    include DatabaseTools

    def initialize(program)
      @program = program
    end

    def call
      Rails.logger.debug "Pf2::PrepareService clear_table retranslators"
      clear_table( ActiveRecord::Base.connection, 'retranslators' )
      Retranslator.create!( port_from: program.ports[0].number,
                            port_to: program.ports[1].number,
                            active: false
                          )
    end

    private
      attr_accessor :program
  end
end