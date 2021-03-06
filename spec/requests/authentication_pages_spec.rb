# enconding: UTF-8

require 'spec_helper'

describe "Authentication" do

	subject { page }

  describe "signin page" do
  	before { visit signin_path}

  	it { should have_selector('h1', text: 'Entrar')}
  	it { should have_selector('title', text: 'Entrar')}
  end

  describe "signin" do
  	before { visit signin_path}
  	
  	describe "with invalid information" do
  		before { click_button "Entrar" }

  		it { should have_selector('title', text: 'Entrar')}
  		it { should have_selector('div.alert.alert-error', text: 'incorrecto')}

  		describe "after visiting another page" do
  			before { click_link "Inicio"}
  			it { should_not have_selector('div.alert.alert-error') }
  		end
  	end

  	describe "with valid information" do
  		let(:user) { FactoryGirl.create(:user) }
  		before { sign_in user }

  		it { should have_selector('title', text: user.name) }

      it { should have_link('Usuarios', href: users_path) }
  		it { should have_link('Perfil', href: user_path(user)) }
      it { should have_link('Ajustes', href: edit_user_path(user)) }
      it { should have_link('Salir', href: signout_path) }
      it { should_not have_link('Entrar', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Salir" }
        it { should have_link('Entrar') }
      end
    end
  end

  describe "authorization" do 

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "using a 'new' action" do
        before { get new_user_path }
        specify { response.should redirect_to(root_path) }
      end

      describe "using a 'create' action" do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "for non-signed in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Entrar"
        end
        

        describe "after signin in" do
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Editar usuario')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Entrar') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Entrar') }
        end

        describe "visiting the following page" do
          before { visit following_user_path(user) }
          it { should have_selector('title', text: 'Entrar') }
        end

        describe "visiting the followers page" do
          before { visit followers_user_path(user) }
          it { should have_selector('title', text: 'Entrar') }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Entrar"
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Editar usuario')
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Entrar"
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
      end

      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non admin user" do 
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:non_admin) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { response.should redirect_to(root_path) }
      end
    end
  end
end
