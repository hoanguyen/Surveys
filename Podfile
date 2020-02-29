# Define a global platform for your project
platform :ios, '10.0'

def network
  pod 'Moya', '~> 14.0'
end

def dev
  pod 'SwiftLint', '~> 0.39'
end

def util
  pod 'Kingfisher', '~> 5.13'
  pod 'KeychainAccess', '~> 4.1'
end

def test
  pod 'Quick', '~> 2.2'
  pod 'Nimble', '~> 8.0'
end

target 'Surveys' do
  # Using for dynamic frameworks
  use_frameworks!

  # Pods for Surveys
  network
  util
  dev

  target 'SurveysTests' do
    inherit! :search_paths
    # Pods for testing
    dev
    test
  end
end
