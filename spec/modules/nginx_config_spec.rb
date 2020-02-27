require 'rails_helper'

describe NginxConfig do

  it { expect(described_class::check_port_ranges([])).to eq([]) }
  it { expect(described_class::check_port_ranges([]).count).to eq(0) }

  it { expect(described_class::check_port_ranges([[30001, 30002], [30003, 30004, 30005]])).to eq([[30003, 30004, 30005]]) }
  it { expect(described_class::check_port_ranges([[30001, 30002], [30003, 30004, 30005], []])).to eq([[30003, 30004, 30005], []]) }

  it { expect(described_class::check_port_ranges([[30002, 30001], [30004, 30003], [10, 20]])).to eq([[30002, 30001], [30004, 30003]]) }
  it { expect(described_class::check_port_ranges([[10, 20], ['a', 'b']])).to eq([['a', 'b']]) }

  it { expect(described_class::check_port_ranges([[30001, 30010],
                                                  [30010, 30013],
                                                  [10, 20]])).to eq([[30001, 30010],
                                                                     [30010, 30013]]) }
  it { expect(described_class::check_port_ranges([[30001, 30010],
                                                  [30011, 30013],
                                                  [10, 20]])).to eq([]) }

  it { expect(described_class::check_port_ranges([[30001, 30010],
                                                  [30011, 30023],
                                                  [30013, 30020]])).to eq([[30013, 30020]]) }

end
