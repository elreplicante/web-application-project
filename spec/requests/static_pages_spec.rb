# encoding: UTF-8

require 'spec_helper'

describe "Static pages" do
  subject { page }
  
  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Servicio de Microposts de la Facultad de Informática' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Inicio' }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem")
        FactoryGirl.create(:micropost, user: user, content: "Ipsum")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 siguiendo", href: following_user_path(user)) }
        it { should have_link("1 seguidores", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Ayuda' }
    let(:page_title) { 'Ayuda' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: 'Ayuda' }
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'Acerca de' }
    let(:page_title) { 'Acerca de' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: 'Acerca de' }
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contacto' }
    let(:page_title) { 'Contacto' }

    it_should_behave_like "all static pages"
    it { should have_selector 'title', text: 'Contact' }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Acerca de"
    page.should have_selector 'title', text: full_title('Acerca de')
    click_link "Ayuda"
    page.should have_selector 'title', text: full_title('Ayuda')
    click_link "Contacto"
    page.should have_selector 'title', text: full_title('Contacto')
    click_link "Inicio"
    click_link "¡Regístrate ahora!"
    page.should have_selector 'title', text: full_title('Registro')
    click_link "FDI Microposts"
    page.should have_selector 'title', text: full_title('')
  end
end