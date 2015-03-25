require 'spec_helper'

describe SessionsController do
  describe "GET new" do

    it "renders :new template for unauthenticated user" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home page for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end

  end

  describe "POST create" do
    context "when user is valid" do

      before do
        @royal = Fabricate(:user)
        post :create, email: @royal.email, password: @royal.password
      end

      it "sets the session" do
        expect(session[:user_id]).to eq(@royal.id)
      end

      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end

    end
    context "when user is not authenticated" do

      before do
        @royal = Fabricate(:user)
        post :create, email: @royal.email, password: @royal.password + 'kdfsjlkds'
      end

      it "does not set the session" do
        expect(session[:user_id]).to be_blank
      end

      it "sets the errors" do
        expect(flash[:errors]).not_to be_blank
      end

      it "redirects to sign in path" do
        expect(response).to redirect_to sign_in_path
      end

    end
  end

  describe "GET destroy" do

    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "sets session to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path
    end

    it "sets the notice" do
      expect(flash[:notice]).not_to be_blank
    end
    
  end
end