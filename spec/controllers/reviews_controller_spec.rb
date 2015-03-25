require 'spec_helper'

describe ReviewsController do
  context "when review is created with valid input" do

    let(:review) { Fabricate.attributes_for(:review) }
    let(:video) { Fabricate(:video) }

    before { post :create, video_id: video.id, review: review }

    describe "POST /videos/:video_id/reviews" do

      it "creates a new @review" do
        expect(Review.count).to eq(1)
      end

      it "redirects to the @video video_path" do
        expect(response).to redirect_to video_path(video)
      end

      it "sets the notice" do
        expect(flash[:notice]).not_to be_blank
      end

    end
  end

  context "when review is being updated" do
    describe "GET /videos/:video_id/reviews/:id/edit" do

      let(:ryan) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:review) { Fabricate(:review, video_id: video.id, user_id: ryan.id) }
      before do 
        session[:user_id] = ryan.id
        get :edit, video_id: video.id, id: review.id
      end

      it "sets the @review object" do
        expect(assigns(:review)).to eq(review)
      end

    end

    describe "PUT /videos/:video_id/reviews/:id" do

      let(:ryan) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:review) do
        Fabricate(:review, video_id: video.id, user_id: ryan.id, rating: 1, review: "Old review")
      end
      
      before do
        session[:user_id] = ryan.id
        put :update, video_id: video.id, id: review.id, review: { rating: 2, review: "New review." }
      end

      it "should redirect to video path" do
        expect(response).to redirect_to video_path(video)
      end

      it "updates the review" do
        expect(review.reload.rating).to eq 2
        expect(review.review).to eq "New review."
      end

      it "sets the flash notice" do
        expect(flash[:notice]).not_to be_blank
      end

    end
  end

  context "when invalid input" do

    let(:video) { Fabricate(:video) }
    before do
      post :create, video_id: video.id, review: { review: "This is a post witout a rating.", video_id: video.id , user_id: Fabricate(:user).id }
    end

    describe "POST /videos/:video_id/reviews" do

      it "does not save the review to the database" do
        expect(Review.count).to eq(0)
      end

      it "redirects to @video video_path" do
        expect(response).to redirect_to video_path(video)
      end

      it "sets flash error" do
        expect(flash[:errors]).not_to be_blank
      end
      
    end
  end
end