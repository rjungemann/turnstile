require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Realm do
  it "Should allow for a new realm to be created." do
    realm_name = "under_the_sea"
    realm = Realm.create "under_the_sea", "narwhals", "mermaids", "fish"
    realm.roles.should == ["narwhals", "mermaids", "fish"]
  end
  
  it "Should allow for a realm to be found by name." do
    realm = Realm.find "under_the_sea"
    realm.name.should == "under_the_sea"
  end
  
  it "Should allow for a new role to be added to a realm." do
    Role.create "artisan" unless Role.exists? "artisan"
    
    realm = Realm.find("under_the_sea")
    realm.add_role "artisan"
    realm.roles.should == ["narwhals", "mermaids", "fish", "artisan"]
  end
  
  it "Should allow for a role to be removed from the realm." do
    realm = Realm.find("under_the_sea")
    realm.remove_role "artisan"
    realm.roles.should == ["narwhals", "mermaids", "fish"]
  end
end