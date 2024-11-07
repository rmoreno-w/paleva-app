require 'rails_helper'

describe 'User' do
  it 'creates a restaurant operating hour but is not authenticated' do
    restaurant = create_restaurant_and_user

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_restaurant_operating_hour: { 
          start_time: '09:00',
          end_time: '10:00',
          status: 1,
          weekday: 1,
        }
      }
    )

    expect(response).to redirect_to new_user_session_path
  end

  it 'creates a restaurant operating hour with success' do
    restaurant = create_restaurant_and_user

    login_as restaurant.user

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_operating_hour: { 
          start_time: '09:00',
          end_time: '10:00',
          status: "1",
          weekday: "1",
        }
      }
    )

    expect(response).to redirect_to restaurant_restaurant_operating_hours_path(restaurant)
  end

  it 'fails to creates a restaurant operating hour with invalid data' do
    restaurant = create_restaurant_and_user

    login_as restaurant.user

    post(
      restaurant_restaurant_operating_hours_path(restaurant), 
      params: { 
        restaurant_operating_hour: { 
          start_time: '',
          end_time: '10:00',
          status: "1",
          weekday: "1",
        }
      }
    )

    expect(response.status).to eq 422
  end
end