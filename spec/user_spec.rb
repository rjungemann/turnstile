require File.join(File.dirname(__FILE__), %w[spec_helper])

describe User do
  it "Should allow for a new user to be created." do
    name = "minnie"
    
    User.find(name).destroy if User.exists? name
    
    user = User.create name 
    user.name.should == name
  end
  
  it "Should allow a created user to be found by name." do
    user = User.find "minnie"
    user.name.should == "minnie"
  end
  
  it "Should allow a user to add a realm, with a password." do
    realm_name = "magical_kingdom"
    
    Realm.find(realm_name).destroy if Realm.exists? realm_name
    Realm.create realm_name
    
    user = User.find "minnie"
    user.add_realm realm_name, "mouse"
    user.realms.should == [realm_name]
  end
  
  it "Should allow a user to signin." do
    user = User.signin "magical_kingdom", "minnie", "mouse"
    user.name.should == "minnie"
  end
  
  it "Should allow a user to see if they're signedin." do
    user = User.signin "magical_kingdom", "minnie", "mouse"
    user.signedin?("magical_kingdom").should == user
  end
  
  it "Should allow for a new user to be signed out." do
    user = User.signin "magical_kingdom", "minnie", "mouse"
    user.signout("magical_kingdom").should == nil
  end
end