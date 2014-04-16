require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "pagination" do
      before do
        31.times { FactoryGirl.create(:micropost, user: user, content: "Hello World!") }
        visit root_path
      end

      after  { user.microposts.delete_all }

      it { should have_selector('div.pagination') }

      it "should list each micropost" do
        user.microposts.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
        end
      end
    end

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

   describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "should not have delete links for other users posts" do
    let(:otherUser) { FactoryGirl.create(:user) }

    before do
      FactoryGirl.create(:micropost, user: otherUser, content: "Other Post")
      visit user_path(otherUser)
    end

    it { should have_content("Other Post") }
    it { should_not have_link("delete") }

  end
end
