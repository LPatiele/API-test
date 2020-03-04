require 'spec_helper'
require 'httparty'


describe 'POST validation' do
    it 'Mandatory message field' do
        response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Name", :num_destinatario => 22222222222}.to_json)
        print (response)
        expect(response.code).to eq(200)
    end
end