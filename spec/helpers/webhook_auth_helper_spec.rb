require 'rails_helper'

RSpec.describe WebhookAuthHelper, type: :helper do
  describe 'valid_signature?' do
    it 'returns true when internal and external signatures match' do
      external_signature = helper.generate_internal_signature('foo')

      expect(helper.valid_signature?('foo', external_signature)).to eq(true)
    end

    it 'returns false when internal and external signatures does not match' do
      external_signature = 'sha256=foo'

      expect(helper.valid_signature?('foo', external_signature)).to eq(false)
    end
  end
end
