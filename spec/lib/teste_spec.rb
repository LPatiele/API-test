require 'spec_helper'
require 'httparty'


describe 'POST validation' do
    it 'Perfect case' do
        response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => 12345678901}.to_json)
        expect(response.code).to eq(200)
    end

    it 'Two menssages for same number' do
        response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste 1", :num_destinatario => 12345678903}.to_json)
        expect(response.code).to eq(200)
        response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste 2", :num_destinatario => 12345678903}.to_json)
        expect(response.code).to eq(400)
    end

    context 'Fields required' do
        it 'Default message field' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:num_destinatario => 12345688901}.to_json)
            expect(response.code).to eq(400)
        end

        it 'Default destinatary number field' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste"}.to_json)
            expect(response.code).to eq(400)
        end

        it 'Default destinatary number and message field' do
            response= HttParty.post('/dev/lambdastresstest', :body => {}.to_json)
            expect(response.code).to eq(400)
        end
    end

    context 'Message field limit' do 
        it 'Maximum limit' do
            # 100 caracteres
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "asdfgh jkhgfdfs rtyhnbvc sdfgdfg fdfg fds s dhgfds ytdsadfg jhgfdghjk ? ! jhgfvmbnbmh, mn â á À oõ.", :num_destinatario => 12345678801}.to_json)
            expect(response.code).to eq(200)
        end

        it 'Over maximum limit' do
            # 101 caracteres
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "asdfgh jkhgfdfs rtyhnbvc sdfgdfg fdfg afds s dhgfds ytdsadfg jhgfdghjk ? ! jhgfvmbnbmh, mn â á À oõ.", :num_destinatario => 12345678981}.to_json)
            expect(response.code).to eq(400)
        end

        it 'Empty message' do
            # 0 caracteres
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "", :num_destinatario => 12345678908}.to_json)
            expect(response.code).to eq(200)
        end
    end

    context 'Destinatary number field limit' do 
        it 'Over limit' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => 123458789012}.to_json)
            expect(response.code).to eq(400)
        end

        it 'Under limit' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => 1234577890}.to_json)
            expect(response.code).to eq(400)
        end
    end

    context 'Number field incorrect entries' do 
        it 'Lyrics' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => "123477789a2"}.to_json)
            expect(response.code).to eq(400)
        end

        it 'Special ceracter' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => "123456789%7"}.to_json)
            expect(response.code).to eq(400)
        end

        it 'String format' do
            response= HttParty.post('/dev/lambdastresstest', :body => {:mensagem => "Mensagem de teste", :num_destinatario => "12375678901"}.to_json)
            expect(response.code).to eq(400)
        end
    end

end