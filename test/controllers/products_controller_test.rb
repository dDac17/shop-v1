require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
    test 'render a list of products' do
      get products_path

      assert_response :success
      assert_select '.product', 3
      assert_select '.category', 3
    end
    test 'render a list of products filtered by category' do
      get products_path(category_id: categories(:computers).id)

      assert_response :success
      assert_select '.product', 1
    end

    test 'render a detailed product page' do
        get product_path(products(:nintendo))
        assert_response :success
        assert_select '.title', 'nintendo wii'
        assert_select '.description', 'está pirateada'
        assert_select '.price', '100€'
    end
      test 'render a new product form' do
        get new_product_path
        assert_response :success
        assert_select 'form'
      end
      test 'allow to create a new product'do
      post products_path, params: { 
        product: {
          title: 'iPad air 64GB',
          description: 'Pantalla rajada',
          price: 200,
          category_id: categories(:videogames).id
        }
       }
       assert_redirected_to products_path
       assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
    end
    test 'does not allow to create a new product with empty fields'do
    post products_path, params: { 
      product: {
        title: '',
        description: 'Pantalla rajada',
        price: 200
      }
     }
     assert_response :unprocessable_entity
  end
  test 'render an edit product form' do
    get edit_product_path(products(:nintendo))
    assert_response :success
    assert_select 'form'
  end
  test 'allows to update a new product'do
      patch product_path(products(:nintendo)), params: { 
        product: {
          price: 195
        }
       }
       assert_redirected_to products_path
       assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end
  test 'does not allow to update a product with an invalid field' do
      patch product_path(products(:nintendo)), params: { 
        product: {
          price: nil
        }
       }
       assert_response :unprocessable_entity
  end
  test 'can delete products' do
  assert_difference('Product.count', -1) do
  delete product_path(products(:nintendo))
    end
 assert_redirected_to products_path
 assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
 end
end 
