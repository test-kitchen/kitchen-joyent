# Kitchen::Joyent

A Joyent API driver for Test Kitchen 1.0!

## Installation

Add this line to your application's Gemfile:

    gem 'kitchen-joyent'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kitchen-joyent

## Usage

Provide, at a minimum, the required driver options in your `.kitchen.yml` file:

    driver_plugin: joyent
    driver_config:
      joyent_username: <%= ENV['SDC_CLI_ACCOUNT'] %>
      joyent_keyfile: <%= ENV['SDC_CLI_IDENTITY'] %>
      joyent_keyname: <%= ENV['SDC_CLI_KEY_ID'] %>
      joyent_url: <%= ENV['SDC_CLI_URL'] %>
      require_chef_omnibus: latest (if you'll be using Chef)      
      
Until we get SmartOS, OmniOS, and FreeBSD into Omnitruck, you'll need
to override the Chef bootstrap script.
      chef_omnibus_url: http://path.to.an.script.sh

## Optional Attributes
Under the general `driver_config`:
````yaml
# Specify Joyent API version
joyent_version: '~7.0'

# Allow self-signed certs.
joyent_ssl_verify_peer: false
````
Usually under `platforms` section:
````yaml
driver_config:

  # For additional nics
  # NOTE: Requires Joyent API version >= 7.0
  joyent_networks:
    - d2ba0f30-bbe8-11e2-a9a2-6bc116856d85
    - a3a84a44-766c-407e-9233-9a45ebcd579f
    
  # Where to pull IP's from by default (internal/external)
  joyent_default_networks:
    - internal
```
Usually under `suites` section:
```yaml
driver_config:

  # Friendly machine name (defaults to: "<joyent_username>-<suite>-<platform>")
  # Valid Chracters =~ /0-9A-Za-z\.-/
  joyent_image_name: default01
  
  # Metadata for the machine
  joyent_image_metadata:
    user1_pw: password

  # Insert Tags for the machine
  joyent_image_tags:
    role: testing
```
# Example .kitchen.yml

```yaml
---
driver_plugin: joyent
driver_config:
  joyent_username: <%= ENV['SDC_CLI_ACCOUNT'] %>
  joyent_keyfile: <%= ENV['SDC_CLI_IDENTITY'] %>
  joyent_keyname: <%= ENV['SDC_CLI_KEY_ID'] %>
  joyent_url: <%= ENV['SDC_CLI_URL'] %>
  require_chef_omnibus: true
  chef_omnibus_url:
  http://raw.github.com/someara/kitchen-joyent/master/scripts/install-smartos.sh
  sudo: false

platforms:
- name: smartos-1330
  driver_config:
    joyent_image_id: 87b9f4ac-5385-11e3-a304-fb868b82fe10
    joyent_flavor_id: g3-standard-4-smartos

- name: freebsd-9
  driver_config:
    joyent_image_id: df8d2ee6-d87f-11e2-b257-2f02c6f6ce80
    joyent_flavor_id: g3-standard-4-kvm

- name: centos-6
  driver_config:
    joyent_image_id: 325dbc5e-2b90-11e3-8a3e-bfdcb1582a8d
    joyent_flavor_id: g3-standard-4-kvm

suites:
- name: default
  run_list: ["recipe[unix-tester]"]
  attributes: {}
```

### List of Images
```
$ knife joyent image list
ID                                    Name               Version  OS
Type
f669428c-a939-11e2-a485-b790efc0f0c1  base               13.1.0 smartos  smartmachine
e3364212-05c0-11e3-9576-3f3ee9e951a7  base               13.2.0 smartos  smartmachine
60ed3a3e-92c7-11e2-ba4a-9b6d5feaa0c4  base               1.9.1 smartos  smartmachine
b83f8276-1fdd-11e3-989b-4bddb088a8a0  base               13.2.1 smartos  smartmachine
84cb7edc-3f22-11e2-8a2a-3f2a7b148699  base               1.8.4 smartos  smartmachine
753ceee6-5372-11e3-8f4e-f79c1154e596  base               13.3.0 smartos  smartmachine
55330ab4-066f-11e2-bd0f-434f2462fada  base               1.8.1 smartos  smartmachine
60a3b1fa-0674-11e2-abf5-cb82934a8e24  base64             1.8.1 smartos  smartmachine
87b9f4ac-5385-11e3-a304-fb868b82fe10  base64             13.3.0 smartos  smartmachine
0084dad6-05c1-11e3-9476-8f8320925eea  base64             13.2.0 smartos  smartmachine
fdea06b0-3f24-11e2-ac50-0b645575ce9d  base64             1.8.4 smartos  smartmachine
17c98640-1fdb-11e3-bf51-3708ce78e75a  base64             13.2.1 smartos  smartmachine
cf7e2f40-9276-11e2-af9a-0bad2233fb0b  base64             1.9.1 smartos  smartmachine
9eac5c0c-a941-11e2-a7dc-57a6b041988f  base64             13.1.0 smartos  smartmachine
bae3f528-e01f-11e2-b2cb-1360087a7d5f  cassandra          13.1.0 smartos  smartmachine
2539f6de-0b5a-11e2-b647-fb08c3503fb2  centos-5.7         1.3.0 linux    virtualmachine
e4cd7b9e-4330-11e1-81cf-3bb50a972bda  centos-6           1.0.1 linux    virtualmachine
30e9e4c8-bbf2-11e2-ac3b-3b598ee13393  centos-6           2.4.2 linux    virtualmachine
8700b668-0da4-11e2-bde4-17221283a2f4  centos-6           1.3.0 linux    virtualmachine
325dbc5e-2b90-11e3-8a3e-bfdcb1582a8d  centos-6           2.5.0 linux    virtualmachine
87c556ac-ab9d-11e2-914d-07682fcab47d  centos-6           2.4.1 linux    virtualmachine
46ecf60e-52c8-11e2-b212-9b51fc749547  debian-6.0.6       2.3.1 linux    virtualmachine
94384a12-bbeb-11e2-aec2-2bfa9742484b  debian-6.0.7       2.4.2 linux    virtualmachine
014e2254-a853-11e2-81c9-b318c31fa17a  debian-6.0.7       2.4.1 linux    virtualmachine
e6ac6784-44b3-11e1-8555-87c3dd87aafe  debian-6.03        1.0.0 linux    virtualmachine
e42f8c84-bbea-11e2-b920-078fab2aab1f  fedora             2.4.2 linux    virtualmachine
df8d2ee6-d87f-11e2-b257-2f02c6f6ce80  freebsd            1.0.0    bsd virtualmachine
274bc2bc-d919-11e2-b797-83245409fbeb  hadoop             13.1.0 smartos  smartmachine
48489174-e351-11e2-88c0-a31eb2b342ee  java               13.1.0 smartos  smartmachine
2c6b0348-d8f6-11e2-91f4-ef498b553611  manta-build        13.1.0 smartos  smartmachine
d2409672-29f3-11e3-ba86-6f782523cb41  mongodb            13.2.1 smartos  smartmachine
ec5defa8-16fe-11e3-948e-8f59b3488902  mongodb            13.2.0 smartos  smartmachine
f953e97e-4991-11e1-9ea4-27c6e7e8afda  nodejs             1.3.3 smartos  smartmachine
133263be-3c2c-11e3-8d3a-a30c43ae58fd  nodejs             13.2.2 smartos  smartmachine
1fc068b0-13b0-11e2-9f4e-2f3f6a96d9bc  nodejs             1.4.0 smartos  smartmachine
beb2dbd4-b26f-11e2-8ad4-935c80092aa6  nodejs             13.1.0 smartos  smartmachine
ffed3d9e-2c2f-11e3-9a12-bf5267821b0b  nodejs             13.2.1 smartos  smartmachine
dc1a8b5e-043c-11e2-9d94-0f3fcb2b0c6d  percona            1.6.0 smartos  smartmachine
3882b5da-b0e8-11e2-b3a9-dbcf26c3e051  percona            13.1.0 smartos  smartmachine
fb6e7820-60ee-11e3-93b6-7f34ea3f2616  percona            13.3.0 smartos  smartmachine
1567edb0-b33e-11e2-a0d2-bf73e2825ffe  riak               13.1.0 smartos  smartmachine
01b2c898-945f-11e1-a523-af1afbe22822  smartos            1.6.3 smartos  smartmachine
489754f2-5e01-11e1-8ff8-f770c2116b0d  smartos            1.5.4 smartos  smartmachine
f9e4be48-9466-11e1-bc41-9f993f5dff36  smartos64          1.6.3 smartos  smartmachine
31bc4dbe-5e06-11e1-907c-5bed6b255fd1  smartos64          1.5.4 smartos  smartmachine
56a0655c-3cc6-11e3-9c79-5701599fdf05  standard           13.2.3 smartos  smartmachine
dac2ad6e-2aa5-11e3-885f-8fd408fc6a82  standard           13.2.1 smartos  smartmachine
34509f68-1ae7-11e3-b816-d3edf71c7840  standard           13.2.0 smartos  smartmachine
3390ca7c-f2e7-11e1-8818-c36e0b12e58b  standard           1.0.7 smartos  smartmachine
399775e4-163e-11e3-8d42-7b14b732ae17  standard64         13.2.0 smartos  smartmachine
a0f8cf30-f2ea-11e1-8a51-5793736be67c  standard64         1.0.7 smartos  smartmachine
b779b49a-29e4-11e3-9b1d-0b0b41ccdcad  standard64         13.2.1 smartos  smartmachine
610e04c4-3cc4-11e3-9867-df64b21b66fe  standard64         13.2.3 smartos  smartmachine
3cd9ef64-1fa5-11e3-be45-1fa28ec74f4a  stm-1000H          13.2.0 smartos  smartmachine
efe2c3e8-1fb8-11e3-b4c4-eb64d18f0b71  stm-1000M          13.2.0 smartos  smartmachine
6e99eff4-1fb9-11e3-9d00-3b6b25be1e62  stm-1000M-SAF      13.2.0 smartos  smartmachine
ef905526-1fb9-11e3-a095-576400e02b54  stm-2000L          13.2.0 smartos  smartmachine
6bf3c40e-1fba-11e3-9847-4f44ccd9abe9  stm-2000L-SAF      13.2.0 smartos  smartmachine
0bcda78c-2066-11e3-8f62-d7edf9742dbd  stm-2000L-SAF-STX  13.2.0 smartos  smartmachine
36f3b80c-2066-11e3-9215-5ffe647b58f0  stm-2000L-STX      13.2.0 smartos  smartmachine
08c63ac6-2067-11e3-abea-a7c7c71e8f15  stm-2000M-SAF-STX  13.2.0 smartos  smartmachine
8b503466-2066-11e3-b5c8-c7e50b85619c  stm-2000M-STX      13.2.0 smartos  smartmachine
e96103b6-1fba-11e3-8dba-3b2f9d336fa1  stm-4000L          13.2.0 smartos  smartmachine
67e5fc46-1fbb-11e3-b1c7-274da29ae2f6  stm-500L-10        13.2.0 smartos  smartmachine
e4093946-1fbb-11e3-8b61-bb9e496e0da4  stm-500M-200       13.2.0 smartos  smartmachine
4b4c141e-1fb4-11e3-a10e-6f99cfdf8806  stm-developer      13.2.0 smartos  smartmachine
71101322-43a5-11e1-8f01-cf2a3031a7f4  ubuntu-10.04       1.0.1 linux    virtualmachine
3162a91e-8b5d-11e2-a78f-9780813f9142  ubuntu-12.04       2.4.0 linux    virtualmachine
da144ada-a558-11e2-8762-538b60994628  ubuntu-12.04       2.4.1 linux    virtualmachine
64e1b2ee-52c8-11e2-bedd-7f919cc63ab9  ubuntu-12.04       2.3.1 linux    virtualmachine
d2ba0f30-bbe8-11e2-a9a2-6bc116856d85  ubuntu-12.04       2.4.2a linux    virtualmachine
13328c9a-9173-11e2-a9a5-2ff43d306c21  ws2008ent-r2-sp1   2.0.2 windows  virtualmachine
5f101d16-90ac-11e2-b9c2-877979ff6041  ws2008std-r2-sp1   2.0.2 windows  virtualmachine
95f6c9a6-a2bd-11e2-b753-dbf2651bf890  ws2012std          1.0.1 windows  virtualmachine
```

### List of Flavors (Sizes)
```
$ knife joyent flavor list
Name                                RAM       Disk      Swap  Price $/Hr
g3-standard-0.25-kvm            0.25 GB      16 GB      0 GB
g3-standard-0.25-smartos        0.25 GB      16 GB      0 GB
g3-standard-0.5-smartos         0.50 GB      16 GB      1 GB
Extra Small 512 MB              0.50 GB      15 GB      1 GB
g3-standard-0.5-kvm             0.50 GB      16 GB      1 GB
g3-standard-0.625-kvm           0.62 GB      20 GB      1 GB  $0.020
g3-standard-0.625-smartos       0.62 GB      20 GB      1 GB  $0.020
g3-standard-1-kvm               1.00 GB      33 GB      2 GB
g3-standard-1-smartos           1.00 GB      33 GB      2 GB
Small 1GB                       1.00 GB      30 GB      2 GB
g3-standard-1.75-kvm            1.75 GB      56 GB      4 GB  $0.056
g3-standard-1.75-smartos        1.75 GB      56 GB      4 GB  $0.056
g3-highcpu-1.75-smartos         1.75 GB      75 GB      4 GB  $0.127
g3-highcpu-1.75-kvm             1.75 GB      75 GB      4 GB  $0.127
g3-standard-2-kvm               2.00 GB      66 GB      4 GB
g3-standard-2-smartos           2.00 GB      66 GB      4 GB
Medium 2GB                      2.00 GB      60 GB      4 GB
g3-standard-3.75-kvm            3.75 GB     123 GB      8 GB  $0.120
g3-standard-3.75-smartos        3.75 GB     123 GB      8 GB  $0.120
g3-standard-4-kvm               4.00 GB     131 GB      8 GB
g3-highcpu-4-kvm                4.00 GB     150 GB      8 GB
g3-standard-4-smartos           4.00 GB     131 GB      8 GB
Medium 4GB                      4.00 GB     120 GB      8 GB
g3-highcpu-4-smartos            4.00 GB     150 GB      8 GB
g3-highcpu-7-kvm                7.00 GB     263 GB     14 GB  $0.508
g3-highcpu-7-smartos            7.00 GB     263 GB     14 GB  $0.508
g3-standard-7.5-smartos         7.50 GB     738 GB     15 GB  $0.240
g3-standard-7.5-kvm             7.50 GB     738 GB     15 GB  $0.240
g3-highcpu-8-smartos            8.00 GB     300 GB     14 GB
g3-standard-8-kvm               8.00 GB     789 GB     16 GB
Large 8GB                       8.00 GB     240 GB     16 GB
g3-standard-8-smartos           8.00 GB     789 GB     16 GB
g3-highcpu-8-kvm                8.00 GB     300 GB     14 GB
g3-standard-15-smartos         15.00 GB    1467 GB     30 GB  $0.480
g3-standard-15-kvm             15.00 GB    1467 GB     30 GB  $0.480
Large 16GB                     16.00 GB     480 GB     32 GB
g3-highcpu-16-smartos          16.00 GB     600 GB     32 GB  $1.160
g3-highmemory-17.125-smartos   17.12 GB     420 GB     34 GB  $0.409
g3-highmemory-17.125-kvm       17.12 GB     420 GB     34 GB  $0.409
g3-highcpu-24-smartos          24.00 GB     900 GB     48 GB  $1.739
g3-standard-30-smartos         30.00 GB    1683 GB     60 GB  $0.960
g3-standard-30-kvm             30.00 GB    1683 GB     60 GB  $0.960
XL 32GB                        32.00 GB     760 GB     64 GB
g3-standard-32-smartos         32.00 GB    1683 GB     64 GB
g3-highmemory-34.25-kvm        34.25 GB     843 GB     68 GB  $0.817
g3-highmemory-34.25-smartos    34.25 GB     843 GB     68 GB  $0.817
g3-standard-48-smartos         48.00 GB    1683 GB     96 GB  $1.536
XXL 48GB                       48.00 GB    1024 GB     96 GB
g3-standard-64-smartos         64.00 GB    2100 GB    128 GB  $2.048
XXXL 64GB                      64.00 GB    1536 GB    128 GB
g3-highmemory-68.375-smartos   68.38 GB    1122 GB    137 GB  $1.630
g3-highmemory-68.375-kvm       68.38 GB    1122 GB    137 GB  $1.630
g3-standard-80-smartos         80.00 GB    2625 GB    160 GB  $2.560
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
