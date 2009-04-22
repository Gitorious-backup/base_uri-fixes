#--
#   Copyright (C) 2009 Johan Sørensen <johan@johansorensen.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU Affero General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU Affero General Public License for more details.
#
#   You should have received a copy of the GNU Affero General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#++

require File.dirname(__FILE__) + '/../spec_helper'

describe Group do
  
  describe "in general" do
    it "uses the name as to_param" do
      groups(:team_thunderbird).to_param.should == groups(:team_thunderbird).name
    end
  end
  
  describe "members" do
    before(:each) do
      @group = groups(:team_thunderbird)
    end
    
    it "knows if a user is a member" do
      @group.member?(users(:johan)).should == false
      @group.member?(users(:mike)).should == true
    end
    
    it "know the role of a member" do
      @group.role_of_user(users(:johan)).should == nil
      @group.role_of_user(users(:mike)).should == roles(:admin)
      @group.admin?(users(:johan)).should == false
      @group.admin?(users(:mike)).should == true
      
      @group.committer?(users(:johan)).should == false
      @group.committer?(users(:mike)).should == true
    end
    
    it "can add a user with a role using add_member" do
      @group.member?(users(:johan)).should == false
      @group.add_member(users(:johan), Role.committer)
      @group.reload.member?(users(:johan)).should == true
    end
  end
  
  describe "repositories" do
    it "has many repositories" do
      groups(:team_thunderbird).repositories.should include(repositories(:johans2))
    end
  end
  
  it "has to_param_with_prefix" do
    grp = groups(:team_thunderbird)
    grp.to_param_with_prefix.should == "+#{grp.to_param}"
  end
  
  it "has no breadcrumb parent" do
    groups(:team_thunderbird).breadcrumb_parent.should == nil
  end
  
  describe "validations" do
    it "should have a unique name" do
      group = Group.new({
        :project => projects(:johans), 
        :name => groups(:team_thunderbird).name
      })
      group.should_not be_valid
      group.errors_on(:name).should_not == nil
    end
    
    it "should have a alphanumeric name" do
      group = Group.new({
        :project => projects(:johans), 
        :name => "fu bar"
      })
      group.valid?.should == false
      group.errors_on(:name).should_not == nil
      group.name = "Foo"
      group.valid?.should == false
      group.errors_on(:name).should_not == nil
    end
  end
end