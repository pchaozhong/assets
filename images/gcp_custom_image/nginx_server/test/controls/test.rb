title "nginx custom image"

describe package('nginx') do
  it { should be_installed }
end
