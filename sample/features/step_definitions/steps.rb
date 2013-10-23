# File: steps.rb
# Step definitions for a sample Cucumber application

Given(/^the catalogue is empty$/) do
  $store.zap_catalogue!()
end

Given(/^I add the video "(.*?)" to the catalogue$/) do |a_title|
  $store.add_video(a_title)
end

Then(/^I should see the video "(.*?)" as unknown$/) do |a_title|
  $store.search_video(a_title).should be_nil
end

Then(/^I should see the video "(.*?)" as (available)$/) do |a_title, a_state|
  found_video = $store.search_video(a_title)
  found_video.state.should == a_state.to_sym
end

When(/^I remove the video "(.*?)"$/) do |a_title|
  found_video = $store.search_video(a_title)
  found_video.should_not be_nil
  found_video.state.should == :available
  $store.remove_video(found_video)
end

Given(/^there is no member yet$/) do
  $store.send(:zap_members!)  # Why is this method seen as private?
end

Then(/^I should see member "(.*?)" as unknown$/) do |member_name|
  $store.search_member(member_name).should be_nil
end

Then(/^I should see member "(.*?)" as registered$/) do |member_name|
  $store.search_member(member_name).should_not be_nil
  puts "Member #{member_name} is registered."
end

Given(/^I subscribe "(.*?)"$/) do |member_name|
  $store.add_member(member_name)
end


Given(/^there is no registered user$/) do
  $store.zap_users!
end

When(/^I enter the credentials "(.*?)"$/) do |credential|
  @entered_credential = credential
end

Then(/^I should not be authorized$/) do
  $store.search_user(@entered_credential).should be_nil
  puts "Invalid user credential" 
end

When(/^I register my credentials "(.*?)"$/) do |credential|
  $store.add_user(credential)
end

Then(/^I should see a welcome message$/) do
  $store.search_user(@entered_credential).should_not be_nil  
  puts "Welcome to the rental application."
end


When(/^I register the rental of "(.*?)" for "(.*?)"$/) do |a_title, member_name|
  found_video = $store.search_video(a_title)
  found_video.should_not be_nil
  found_video.state.should == :available

  member = $store.search_member(member_name)
  member.should_not be_nil
  $store.add_rental(found_video, member)
  @confirm_rental = true
end

Then(/^I should see the rental confirmed$/) do
  puts "Rental registered." if @confirm_rental
  @confirm_rental = nil
end

Then(/^I should see the rental refused$/) do
  puts "Rental refused." unless @confirm_rental
end


When(/^I register the return of "(.*?)" from "(.*?)"$/) do |a_title, member_name|
  rental = $store.search_rental(a_title)
  rental.should_not be_nil
  rental.member.should == member_name
  $store.close_rental(rental)
  @confirm_return = true
end

Then(/^I should see the return confirmed$/) do
  puts "Return registered." if @confirm_return
  @confirm_return = nil
end



# End of file