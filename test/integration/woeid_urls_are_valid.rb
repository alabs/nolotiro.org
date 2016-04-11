require "test_helper"

class WoeidUrlParamValid < ActionDispatch::IntegrationTest

  it "should redirect if woeid is not type town" do
    get '/es/woeid/23424801/give' #woeid of Ecuador Country
    assert_redirected_to '/es/location/change'
  end

  it "should redirect if woeid is not an integer" do
    get '/es/woeid/234LOOOOOOOOOOOOL24801/give'
    assert_redirected_to '/es/location/change'
  end

  it "should redirect if woeid is not a valid woeid" do
    get '/es/woeid/222222/give' #woeid does not exists
    assert_redirected_to '/es/location/change'
  end

end

