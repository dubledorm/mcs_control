require 'rails_helper'
require 'support/feature_helper'
require 'support/shared/object_base_decorator'

RSpec.describe Program do
  include FeatureHelper

  it_behaves_like 'base_decorator'
end
