require 'spec_helper'

describe PollingLocationsController do

  let(:polling_location) { FactoryGirl.create(:polling_location) }
  describe 'GET show' do
    before(:each) do
      get 'show', id: polling_location.to_param
    end
    it 'returns http success' do
      expect(response).to be_success
    end
    it 'renders the show template' do
      expect(response).to render_template 'polling_locations/show'
    end
    it 'passes the polling location to the view' do
      expect(assigns[:polling_location]).to eq polling_location
    end
  end
  describe 'GET new' do
    context 'with a logged in user' do
      login_user
      before(:each) do
        get 'new', state: 'CA'
      end
      it 'renders the new form' do
        expect(response).to render_template('polling_locations/new')
      end
      it 'passes a new polling location object' do
        expect(assigns[:polling_location]).to be_new_record
      end
      it 'prepopulates the state field with the passed option' do
        expect(assigns[:polling_location].state).to eq 'CA'
      end
    end
    context 'without a logged in user' do
      it 'is not successful' do
        get 'new'
        expect(response).to_not be_success
      end
    end
  end
  describe 'POST create' do
    context 'with a logged in user' do
      login_user
      context 'with valid params' do
        let(:params) do
          { polling_location:
            { state: 'CA',
              description: 'I voted in a shoebox at 3rd and 16th' }
          }
        end
        it 'creates a new polling location' do
          expect do
            post 'create', params
          end.to change { PollingLocation.count }.by(1)
        end
        it 'redirects to the create review page for the new location' do
          post 'create', params
          expect(response).to redirect_to new_polling_location_review_path(
                                            assigns[:polling_location])
        end
        context 'when the site is shut off' do
          before(:each) do
            Settings.stub(:[]) { true }
          end
          it 'is not successful' do
            expect { post 'create', params }.to raise_exception(Exception)
          end
          it 'does not create a new review' do
            # rubocop:disable HandleExceptions
            expect do
              begin
                post 'create', params
              rescue
                # no action
              end
            end.to change { Review.count }.by(0)
            # rubocop:enable HandleExceptions
          end
        end
      end
      context 'without a description' do
        let(:params) do
          { polling_location: { state: 'CA' } }
        end
        it 'does not create a new polling location' do
          expect do
            post 'create', params
          end.to change { PollingLocation.count }.by(0)
        end
        it 'renders the new page' do
          post 'create', params
          expect(response).to render_template('polling_locations/new')
        end
        it 'passes a review object with errors' do
          post 'create', params
          expect(assigns[:polling_location].errors.size).to_not eq 0
          expect(assigns[:polling_location]).to be_new_record
        end
      end
    end
    context 'without a logged in user' do
      it 'is not successful' do
        post 'create'
        response.should_not be_success
      end
    end
  end
end
