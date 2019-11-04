require "spec_helper"

describe Mavenlink::SamlIdentity, stub_requests: true, type: :model do
  it_should_behave_like "model", "saml_identities"
end
