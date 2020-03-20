# copyright: 2018, The Authors

title "demo"

# you can also use plain tests
describe package('nginx') do
  it { should be_installed }
end
