require "test_helper"

class PokedexesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pokedex = pokedexes(:one)
  end

  test "should get index" do
    get pokedexes_url
    assert_response :success
  end

  test "should get new" do
    get new_pokedex_url
    assert_response :success
  end

  test "should create pokedex" do
    assert_difference("Pokedex.count") do
      post pokedexes_url, params: { pokedex: { flavor_text: @pokedex.flavor_text, pokemon_id: @pokedex.pokemon_id } }
    end

    assert_redirected_to pokedex_url(Pokedex.last)
  end

  test "should show pokedex" do
    get pokedex_url(@pokedex)
    assert_response :success
  end

  test "should get edit" do
    get edit_pokedex_url(@pokedex)
    assert_response :success
  end

  test "should update pokedex" do
    patch pokedex_url(@pokedex), params: { pokedex: { flavor_text: @pokedex.flavor_text, pokemon_id: @pokedex.pokemon_id } }
    assert_redirected_to pokedex_url(@pokedex)
  end

  test "should destroy pokedex" do
    assert_difference("Pokedex.count", -1) do
      delete pokedex_url(@pokedex)
    end

    assert_redirected_to pokedexes_url
  end
end
