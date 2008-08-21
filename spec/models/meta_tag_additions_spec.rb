require File.dirname(__FILE__) + '/../spec_helper'

describe "Meta Tag Additions" do
  scenario :users_and_pages

  describe "<r:if_meta>" do
    before(:each) do
      page(:home).update_attribute(:description, nil)
      page(:home).update_attribute(:keywords, nil)
    end
    
    it "should display it's contents if the data exists where the page meta name='description'" do
      page.description = "description"
      page.should render('<r:if_meta name="description">true</r:if_meta>').as('true')
    end
    it "should display it's contents if the data exists where the page meta name='keywords'" do
      page.keywords = "keywords"
      page.should render('<r:if_meta name="keywords">true</r:if_meta>').as('true')
    end
    it "should not display it's contents if the data does not exist where the page meta name='description'" do
      page(:first).description = nil
      page(:first).should render('<r:if_meta name="description">true</r:if_meta>').as('')
    end
    it "should not display it's contents if the data does not exist where the page meta name='keywords'" do
      page.keywords = nil
      page.should render('<r:if_meta name="keywords">true</r:if_meta>').as('')
    end
    
    it "should search the page ancestors for the presence of the keywords" do
      page(:home).update_attribute(:keywords, 'this, that')
      page(:first).should render('<r:if_meta>true</r:if_meta>').as('true')
    end
    
    it "should search the page ancestors for the presence of the description" do
      page(:home).update_attribute(:description, 'about it')
      page(:first).should render('<r:if_meta name="description">true</r:if_meta>').as('true')
    end
    
  end
    
  describe '<r:if_meta> with inherit="false"' do
    it "should only check for the keywords on the current page" do
      page(:first).update_attribute(:keywords, nil)
      page(:first).should render('<r:if_meta inherit="false">true</r:if_meta>').as('')
    end
    it "should only check for the description on the current page" do
      page(:first).update_attribute(:description, nil)
      page(:first).should render('<r:if_meta inherit="false" name="description">true</r:if_meta>').as('')
    end
  end
  
  describe "<r:unless_meta>" do
    before(:each) do
      page(:home).update_attribute(:description, nil)
      page(:home).update_attribute(:keywords, nil)
    end
    
    it "should display it's contents if the data does not exist where the page meta name='description'" do
      page.description = nil
      page.should render('<r:unless_meta name="description">true</r:unless_meta>').as('true')
    end
    it "should display it's contents if the data does not exist where the page meta name='keywords'" do
      page.keywords = nil
      page.should render('<r:unless_meta name="keywords">true</r:unless_meta>').as('true')
    end
    it "should not display it's contents if the data does exist where the page meta name='description'" do
      page.description = "description"
      page.should render('<r:unless_meta name="description">true</r:unless_meta>').as('')
    end
    it "should not display it's contents if the data does exist where the page meta name='keywords'" do
      page.keywords = "keywords"
      page.should render('<r:unless_meta name="keywords">true</r:unless_meta>').as('')
    end
    
    it "should search the page ancestors for the presence of the keywords" do
      page(:home).update_attribute(:keywords, 'this, that')
      page(:first).should render('<r:unless_meta>true</r:unless_meta>').as('')
    end
    
    it "should search the page ancestors for the presence of the description" do
      page(:home).update_attribute(:description, 'this, that')
      page(:first).should render('<r:unless_meta name="description">true</r:unless_meta>').as('')
    end
    
  end
  
  describe '<r:unless_meta> with inherit="false"' do
    it "should only check for the keywords on the current page" do
      page(:first).update_attribute(:keywords, 'key, words')
      page(:first).should render('<r:unless_meta inherit="false">true</r:unless_meta>').as('')
    end
    it "should only check for the description on the current page" do
      page(:first).update_attribute(:description, 'description')
      page(:first).should render('<r:unless_meta inherit="false" name="description">true</r:unless_meta>').as('')
    end
  end
  
  private

    def page(symbol = nil)
      if symbol.nil?
        @page ||= pages(:assorted)
      else
        @page = pages(symbol)
      end
    end
  
end
