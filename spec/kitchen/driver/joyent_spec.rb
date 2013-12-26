#
# Author:: Sean OMeara (<someara@gmail.com>)
#
# Copyright (C) 2013, Sean OMeara
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'logger'
require 'stringio'
require 'rspec'
require 'kitchen'
require_relative '../../spec_helper'

describe Kitchen::Driver::Joyent do
  let(:logged_output) { StringIO.new }
  let(:logger) { Logger.new(logged_output) }
  let(:config) { Hash.new }
  let(:state) { Hash.new }

  let(:instance) do
    double(name: 'honeybadger', logger: logger, to_str: 'instance')
  end

  let(:driver) do
    d = Kitchen::Driver::Joyent.new(config)
    d.instance = instance
    d
  end

  describe '#initialize'do
    context 'default options' do

      it 'defaults to us-sw-1' do
        expect(driver[:joyent_url]).to eq('https://us-sw-1.api.joyentcloud.com')
      end
      
      it 'defaults to a base64 13.3.0' do
        expect(driver[:joyent_image_id]).to eq('87b9f4ac-5385-11e3-a304-fb868b82fe10')
      end

      it 'defaults to joyent_flavor_id g3-standard-4-smartos' do
        expect(driver[:joyent_flavor_id]).to eq('g3-standard-4-smartos')
      end

      it 'defaults to SSH with root user on port 22' do
        expect(driver[:username]).to eq('root')
        expect(driver[:port]).to eq('22')
      end

      it 'does not use sudo' do
        expect(driver[:sudo]).to eq(false)
      end
      
    end

    context 'overridden options' do
      let(:config) do
        {
          joyent_url: 'https://internal.sdc.installation.biz',
          joyent_image_id: 'df8d2ee6-d87f-11e2-b257-2f02c6f6ce80',
          joyent_flavor_id: 'g3-standard-4-kvm',
          username: 'r00t',
          port: '2222'
        }
      end

      it 'uses all the overridden options' do
        drv = driver
        config.each do |k, v|
          expect(drv[k]).to eq(v)
        end
      end
    end
  end

  describe '#create' do
    let(:server) do
      double('id' => 'test123', 'wait_for' => true,
           'public_ip_address' => '1.2.3.4')
    end
    let(:driver) do
      d = Kitchen::Driver::Joyent.new(config)
      d.instance = instance
      d.stub(:create_server).and_return(server)
      d.stub(:wait_for_sshd).with('1.2.3.4').and_return(true)
      d
    end

    context 'when only supplying username, keyname, and keyfile' do
      let(:config) do
        {
          joyent_username: 'robocop',
          joyent_keyname: 'pewpewpew',
          joyent_keyfile: '/path/to/key'
        }
      end

      it 'gets a proper server ID' do
        driver.create(state)
        expect(state[:server_id]).to eq('test123')
      end

      it 'gets a proper hostname (IP)' do
        driver.create(state)
        expect(state[:hostname]).to eq('1.2.3.4')
      end
    end
  end

  describe '#destroy' do
    let(:server_id) { '12345' }
    let(:hostname) { 'example.com' }
    let(:state) { { server_id: server_id, hostname: hostname } }
    let(:server) { double(nil?: false, destroy: true) }
    let(:servers) { double(get: server) }
    let(:compute) { double(servers: servers) }

    let(:driver) do
      d = Kitchen::Driver::Joyent.new(config)
      d.instance = instance
      d.stub(:compute).and_return(compute)
      d
    end

    context 'a live server that needs to be destroyed' do
      it 'destroys the server' do
        state.should_receive(:delete).with(:server_id)
        state.should_receive(:delete).with(:hostname)
        driver.destroy(state)
      end
    end

    context 'no server ID present' do
      let(:state) { Hash.new }

      it 'does nothing' do
        driver.stub(:compute)
        driver.should_not_receive(:compute)
        state.should_not_receive(:delete)
        driver.destroy(state)
      end
    end

    context 'a server that was already destroyed' do
      let(:servers) do
        s = double('servers')
        s.stub(:get).with('12345').and_return(nil)
        s
      end
      let(:compute) { double(servers: servers) }
      let(:driver) do
        d = Kitchen::Driver::Joyent.new(config)
        d.instance = instance
        d.stub(:compute).and_return(compute)
        d
      end

      it 'does not try to destroy the server again' do
        allow_message_expectations_on_nil
        driver.destroy(state)
      end
    end
  end

  describe '#compute' do
    let(:config) do
      {
        joyent_username: 'honeybadger',
        joyent_keyname: 'dontcare',        
        joyent_keyfile: 'dat.pem'
      }
    end

    context 'all requirements provided' do
      it 'creates a new compute connection' do
        Fog::Compute.stub(:new) { |arg| arg }
        res = config.merge(provider: :joyent)
        expect(driver.send(:compute)).to eq(res)
      end
    end

    context 'no joyent_username provided' do
      let(:config) { { joyent_username: 'honeybadger' } }

      it 'raises an error' do
        expect { driver.send(:compute) }.to raise_error(ArgumentError)
      end
    end

    context 'no joyent_keyname provided' do
      let(:config) { { joyent_keyname: 'dontcare' } }

      it 'raises an error' do
        expect { driver.send(:compute) }.to raise_error(ArgumentError)
      end
    end

    context 'no joyent_keyfile provided' do
      let(:config) { { joyent_keyfile: '/path/to/dat.pem' } }

      it 'raises an error' do
        expect { driver.send(:compute) }.to raise_error(ArgumentError)
      end
    end

  end

  describe '#create_server' do
    let(:config) do
      {
        joyent_url: 'https://us-sw-1.api.joyentcloud.com',
        dataset: '87b9f4ac-5385-11e3-a304-fb868b82fe10',
        package: 'g3-standard-4-smartos',
      }
    end
    before(:each) { @config = config.dup }
    let(:servers) do
      s = double('servers')
      s.stub(:create) { |arg| arg }
      s
    end
    let(:compute) { double(servers: servers) }
    let(:driver) do
      d = Kitchen::Driver::Joyent.new(config)
      d.instance = instance
      d.stub(:compute).and_return(compute)
      d
    end

    it 'creates the server using a compute connection' do
      expect(driver.send(:create_server)).to eq(@config)
    end
  end  
end
