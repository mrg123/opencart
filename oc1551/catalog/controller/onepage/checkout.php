<?php  
class ControllerOnePageCheckout extends Controller { 
	public function index() {
		// Validate cart has products and has stock.
		if ((!$this->cart->hasProducts() && empty($this->session->data['vouchers'])) || (!$this->cart->hasStock() && !$this->config->get('config_stock_checkout'))) {
	  		$this->redirect($this->url->link('checkout/cart'));
    	}	
		
		// Validate minimum quantity requirments.			
		$products = $this->cart->getProducts();
				
		foreach ($products as $product) {
			$product_total = 0;
				
			foreach ($products as $product_2) {
				if ($product_2['product_id'] == $product['product_id']) {
					$product_total += $product_2['quantity'];
				}
			}		
			
			if ($product['minimum'] > $product_total) {
				$this->redirect($this->url->link('checkout/cart'));
			}				
		}
				
		$this->language->load('onepage/checkout');
		
		$this->document->setTitle($this->language->get('heading_title')); 
		$this->document->addScript('catalog/view/javascript/jquery/colorbox/jquery.colorbox-min.js');
		$this->document->addStyle('catalog/view/javascript/jquery/colorbox/colorbox.css');
					
		$this->data['breadcrumbs'] = array();

      	$this->data['breadcrumbs'][] = array(
        	'text'      => $this->language->get('text_home'),
			'href'      => $this->url->link('common/home'),
        	'separator' => false
      	); 

      	$this->data['breadcrumbs'][] = array(
        	'text'      => $this->language->get('text_cart'),
			'href'      => $this->url->link('checkout/cart'),
        	'separator' => $this->language->get('text_separator')
      	);
		
      	$this->data['breadcrumbs'][] = array(
        	'text'      => $this->language->get('heading_title'),
			'href'      => $this->url->link('onepage/checkout', '', 'SSL'),
        	'separator' => $this->language->get('text_separator')
      	);
					
	    $this->data['heading_title'] = $this->language->get('heading_title');

		$this->data['logged'] = $this->customer->isLogged(); //Moved FROM LINE 62
		$this->data['shipping_required'] = $this->cart->hasShipping(); //Moved FROM LINE 63;

		$this->data['text_checkout_payment_address'] = $this->data['shipping_required'] ? $this->language->get('text_checkout_payment_shipping_address') : $this->language->get('text_checkout_payment_address');
		$this->data['text_checkout_shipping_address'] = $this->language->get('text_checkout_shipping_address');
		$this->data['text_checkout_shipping_method'] = $this->language->get('text_checkout_shipping_method');
		$this->data['text_checkout_payment_method'] = $this->data['shipping_required'] ? $this->language->get('text_checkout_payment_method_step3') : $this->language->get('text_checkout_payment_method_step2');
		$this->data['text_checkout_confirm'] = $this->data['shipping_required'] ? $this->language->get('text_checkout_confirm_step4') : $this->language->get('text_checkout_confirm_step3');
		$this->data['text_modify'] = $this->language->get('text_modify');
		
		
		//BOF
		$this->data['country_id'] = $this->config->get('config_country_id');
		
		$this->session->data['account'] = 'guest';
		if ($this->config->get('config_checkout_id')) {
				$this->load->model('catalog/information');
				
				$information_info = $this->model_catalog_information->getInformation($this->config->get('config_checkout_id'));
				
				if ($information_info) {
					$this->data['warning_agree'] = sprintf($this->language->get('error_agree'), $information_info['title']);
				}
		}
		//EOF
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/onepage/checkout.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/onepage/checkout.tpl';
		} else {
			$this->template = 'default/template/onepage/checkout.tpl';
		}
		$this->document->addStyle('catalog/view/theme/default/stylesheet/onepage.css');
		$this->children = array(
			'common/content_top',
			'common/content_bottom',
			'common/footer',
			'common/header'	
		);
				
		$this->response->setOutput($this->render());
  	}
	
	public function country() {
		$json = array();
		
		$this->load->model('localisation/country');

    	$country_info = $this->model_localisation_country->getCountry($this->request->get['country_id']);
		
		if ($country_info) {
			$this->load->model('localisation/zone');

			$json = array(
				'country_id'        => $country_info['country_id'],
				'name'              => $country_info['name'],
				'iso_code_2'        => $country_info['iso_code_2'],
				'iso_code_3'        => $country_info['iso_code_3'],
				'address_format'    => $country_info['address_format'],
				'postcode_required' => $country_info['postcode_required'],
				'zone'              => $this->model_localisation_zone->getZonesByCountryId($this->request->get['country_id']),
				'status'            => $country_info['status']		
			);
		}
		
		$this->response->setOutput(json_encode($json));
	}
}
?>