<?php echo $header; ?>
<div id="content"><?php echo $content_top; ?>
  <div class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <?php echo $breadcrumb['separator']; ?><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a>
    <?php } ?>
  </div>
  <h1><?php echo $heading_title; ?></h1>
  <div id="onepage-checkout">
    <?php if (!$logged) { ?>
		<div style="padding-bottom:5px;">
			<input type="checkbox" id="return-client">
			<label for="return-client" style="color:red">Already registered? Click here to login</label>
		</div>
	    <div id="checkout" style="display:none;">
	      <div class="checkout-content"></div>
	    </div>
	<div id="op-left">
	    <div id="payment-address">
	      <div class="checkout-heading"><span><?php echo $text_checkout_payment_address; ?></span></div>
	      <div class="checkout-content"></div>
	    </div>
    <?php } else { ?>
    <div id="op-left">
	    <div id="payment-address">
	      <div class="checkout-heading"><span><?php echo $text_checkout_payment_address; ?></span></div>
	      <div class="checkout-content"></div>
	    </div>
    <?php } ?>
    <?php if ($shipping_required) { ?>
	    <div id="shipping-address" style="display: none;">
	    	<div class="checkout-heading"><span><?php echo $text_checkout_shipping_address; ?></span></div>
	      	<div class="checkout-content"></div>
	    </div>
    </div>
    <div id="op-middle">
	    <div id="shipping-method">
	      <div class="checkout-heading"><?php echo $text_checkout_shipping_method; ?></div>
	      <div class="checkout-content"></div>
	    </div>
    <?php }else{ ?>
    </div>
    <div id="op-middle">
    <?php } ?>
	    <div id="payment-method">
	      <div class="checkout-heading"><?php echo $text_checkout_payment_method; ?></div>
	      <div class="checkout-content"></div>
	    </div>
    </div>
    <div id="op-right">
	    <div id="confirm">
	      <div class="checkout-heading"><?php echo $text_checkout_confirm; ?></div>
	      <div class="checkout-content"></div>
	    </div>
    </div>
  </div>
  <?php echo $content_bottom; ?></div>
<script type="text/javascript"><!--

function shipping_address_display_status(){
	if ($('#shipping').attr('checked')) {
		$('#shipping-address').hide();
		<?php if ($logged) { ?>
			$("#shipping-existing select[name='address_id']").val($("#payment-existing select[name='address_id']").val());
			$("#shipping-existing select[name='address_id']").trigger('change');
		<?php }; ?>
	}else{
		$('#shipping-address').slideDown();
	};
}

function load_payment_address(){
    $.ajax({
      url: '<?php if ($logged) {echo "index.php?route=onepage/payment_address";}else{ echo "index.php?route=onepage/guest";}; ?>',
      dataType: 'html',
      beforeSend: function() {
      	if ($('#payment-address .wait').length == 0 ) {
			$('#payment-address .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
      	};
      },  
      complete: function() {
        $('#payment-address .wait').remove();
      },
      success: function(html) {
        $('#payment-address .checkout-content').html(html);                   
      }
    });
}

function load_shipping_address(){
    $.ajax({
      url: '<?php if ($logged) {echo "index.php?route=onepage/shipping_address"; }else{echo "index.php?route=onepage/guest_shipping";}; ?>',
      dataType: 'html',
      success: function(html) {
        $('#shipping-address .checkout-content').html(html);
      }
    });
}

function load_shipping_method(){
    $.ajax({
      url: 'index.php?route=onepage/shipping_method',
      dataType: 'html',
      beforeSend: function() {
      	if ($('#shipping-method .wait').length == 0) {
        	$('#shipping-method .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
      	};
      },  
      complete: function() {
        $('#shipping-method .wait').remove();
      },
      success: function(html) {
        $('#shipping-method .checkout-content').html(html);
      }
    });
}

function load_payment_method(){
    $.ajax({
      url: 'index.php?route=onepage/payment_method',
      dataType: 'html',
      beforeSend: function() {
      	if ($('#payment-method .wait').length == 0) {
        	$('#payment-method .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
      	};
      },  
      complete: function() {
        $('#payment-method .wait').remove();
      },
      success: function(html) {
        $('#payment-method .checkout-content').html(html);                   
      }
    });
}

function load_confirm(){
	$.ajax({
		url: 'index.php?route=onepage/confirm',
		dataType: 'html',
		beforeSend: function() {
			if ($('#confirm .wait').length == 0) {
				$('#confirm .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
			};
		},  
		complete: function() {
		$('#confirm .wait').remove();
		},
		success: function(html){
			$('#confirm .checkout-content').html(html);
		}
	});
}

function load_confirm_validate(){

	if ($('#shipping-method .warning').length > 0 || $('#payment-method .warning').length >0 ) {
		$('#shipping-method .warning').fadeOut();
		$('#shipping-method .warning').fadeIn();
		$('#payment-method .warning').fadeOut();
		$('#payment-method .warning').fadeIn();
	}else{
		$.ajax({
			url: 'index.php?route=onepage/confirm/comment',
			type: 'post',
			data: $('#payment-method textarea'),
			beforeSend: function() {
				if ($('#confirm .wait').length == 0) {
					$('#button-confirm').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');	
				};
			},
			success: function() {
				$('#confirm .checkout-content').load('index.php?route=onepage/confirm/validate');
			}
		});
	};
}

function change_payment_address(reload_flag){
	$.ajax({
		url: '<?php if ($logged) {echo "index.php?route=onepage/payment_address/validate";}else{ echo "index.php?route=onepage/guest/validate";};?>',
		type: 'post',
		data: $('#payment-address input[type=\'text\'], #payment-address input[type=\'password\'], #payment-address input[type=\'checkbox\']:checked, #payment-address input[type=\'radio\']:checked, #payment-address input[type=\'hidden\'], #payment-address select, #shipping'),
		dataType: 'json',
		beforeSend: function() {
			if ($('#payment-address .wait').length == 0) {
				$('#payment-address .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');	
			};
		},	
		complete: function() {
			$('#payment-address .wait').remove();
		},			
		success: function(json) {
			$('#payment-address .warning, #payment-address .error').remove();
			
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				if (json['error']['warning']) {
					$('#payment-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
					$('#payment-address .warning').fadeIn('slow');
				}
								
				if (json['error']['firstname']) {
					$('#payment-address input[name=\'firstname\']').after('<span class="error">' + json['error']['firstname'] + '</span>');
				}
				
				if (json['error']['lastname']) {
					$('#payment-address input[name=\'lastname\']').after('<span class="error">' + json['error']['lastname'] + '</span>');
				}	
				
				if (json['error']['email']) {
					$('#payment-address input[name=\'email\'] + br').after('<span class="error">' + json['error']['email'] + '</span>');
				}

				if (json['error']['telephone']) {
					$('#payment-address input[name=\'telephone\']').after('<span class="error">' + json['error']['telephone'] + '</span>');
				}		
				
				if (json['error']['company_id']) {
					$('#payment-address input[name=\'company_id\']').after('<span class="error">' + json['error']['company_id'] + '</span>');
				}	
				
				if (json['error']['tax_id']) {
					$('#payment-address input[name=\'tax_id\']').after('<span class="error">' + json['error']['tax_id'] + '</span>');
				}	
														
				if (json['error']['address_1']) {
					$('#payment-address input[name=\'address_1\']').after('<span class="error">' + json['error']['address_1'] + '</span>');
				}	
				
				if (json['error']['city']) {
					$('#payment-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
				}	
				
				if (json['error']['postcode']) {
					$('#payment-address input[name=\'postcode\']').after('<span class="error">' + json['error']['postcode'] + '</span>');
				}	
				
				if (json['error']['country']) {
					$('#payment-address select[name=\'country_id\']').after('<span class="error">' + json['error']['country'] + '</span>');
				}	
				
				if (json['error']['zone']) {
					$('#payment-address select[name=\'zone_id\']').after('<span class="error">' + json['error']['zone'] + '</span>');
				}
			} else {
				<?php if ($logged) { ?>
					if (reload_flag == 1) {
						load_payment_address();
						<?php if ($shipping_required) { ?>
							load_shipping_address();
						<?php }; ?>
					}else{
						load_payment_method();
					};
				<?php }else{ ?>
					<?php if ($shipping_required) { ?>
						if ($('#shipping').attr('checked')) {
							load_shipping_address();
						};
						console.log($('#shipping').val());
						console.log($('#shipping').attr('checked'));
					<?php }; ?>
				<?php }; ?>
				load_payment_method();
			}	  
		}
	});
}

function change_shipping_address(reload_flag){
	$.ajax({
		url: '<?php if ($logged) {echo "index.php?route=onepage/shipping_address/validate";}else{echo "index.php?route=onepage/guest_shipping/validate";}; ?>',
		type: 'post',
		data: $('#shipping-address input[type=\'text\'], #shipping-address input[type=\'password\'], #shipping-address input[type=\'checkbox\']:checked, #shipping-address input[type=\'radio\']:checked, #shipping-address select'),
		dataType: 'json',
		beforeSend: function() {
			if ($('#shipping-address .wait').length == 0) {
				$('#shipping-address .checkout-heading').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
			};
		},	
		complete: function() {
			$('#shipping-address .wait').remove();
		},			
		success: function(json) {
			$('#shipping-address .warning, #shipping-address .error').remove();
			
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				if (json['error']['warning']) {
					$('#shipping-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
					$('#shipping-address .warning').fadeIn('slow');
				}
								
				if (json['error']['firstname']) {
					$('#shipping-address input[name=\'firstname\']').after('<span class="error">' + json['error']['firstname'] + '</span>');
				}
				
				if (json['error']['lastname']) {
					$('#shipping-address input[name=\'lastname\']').after('<span class="error">' + json['error']['lastname'] + '</span>');
				}	
				
				if (json['error']['email']) {
					$('#shipping-address input[name=\'email\']').after('<span class="error">' + json['error']['email'] + '</span>');
				}
				
				if (json['error']['telephone']) {
					$('#shipping-address input[name=\'telephone\']').after('<span class="error">' + json['error']['telephone'] + '</span>');
				}		
										
				if (json['error']['address_1']) {
					$('#shipping-address input[name=\'address_1\']').after('<span class="error">' + json['error']['address_1'] + '</span>');
				}	
				
				if (json['error']['city']) {
					$('#shipping-address input[name=\'city\']').after('<span class="error">' + json['error']['city'] + '</span>');
				}	
				
				if (json['error']['postcode']) {
					$('#shipping-address input[name=\'postcode\']').after('<span class="error">' + json['error']['postcode'] + '</span>');
				}	
				
				if (json['error']['country']) {
					$('#shipping-address select[name=\'country_id\']').after('<span class="error">' + json['error']['country'] + '</span>');
				}	
				
				if (json['error']['zone']) {
					$('#shipping-address select[name=\'zone_id\']').after('<span class="error">' + json['error']['zone'] + '</span>');
				}
			} else {
				<?php if ($logged) { ?>
					if (reload_flag == 1) {
						load_shipping_address();
						load_payment_address();	
					}else{
						load_shipping_method();
					};
				<?php }else{ ?>
					load_shipping_method();
				<?php }; ?>
			}
		}
	});
}

function send_shipping_method(){
	$.ajax({
		url: 'index.php?route=onepage/shipping_method/validate',
		type: 'post',
		data: $('#shipping-method input[type=\'radio\']:checked, #shipping-method textarea'),
		dataType: 'json',
		success: function(json) {
			$('#shipping-method .warning, #shipping-method .error').remove();
			
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				if (json['error']['warning']) {
					$('#shipping-method .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
					$('#shipping-method .warning').fadeIn('slow');
				}			
			} else {
				load_payment_method();
			}
		}
	});
}

function send_payment_method(){
	$.ajax({
		url: 'index.php?route=onepage/payment_method/validate', 
		type: 'post',
		data: $('#payment-method input[type=\'radio\']:checked, #payment-method input[type=\'checkbox\']:checked, #payment-method textarea'),
		dataType: 'json',
		success: function(json) {
			$('#payment-method .warning, #payment-method .error').remove();
			
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				if (json['error']['warning']) {
					$('#payment-method .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
					$('#payment-method .warning').fadeIn('slow');
				}			
			} else {
					load_confirm();
			}
		}
	});
}

$('#return-client').live('change', function(){
  if ($('#return-client').attr('checked')) {
    $('#checkout').show();
  }else{
    $('#checkout').hide();
  };
});

function login () {
	$.ajax({
		url: 'index.php?route=onepage/login/validate',
		type: 'post',
		data: $('#checkout #login :input'),
		dataType: 'json',
		beforeSend: function() {
			$('#button-login').attr('disabled', true);
			$('#button-login').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
		},	
		complete: function() {
			$('#button-login').attr('disabled', false);
			$('#login .wait').remove();
		},				
		success: function(json) {
			$('#login').siblings('.warning').remove();
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				$('#checkout .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '</div>');
				
				$('#checkout .warning').fadeIn('slow');
			}
		}
	});
}
// Login
$('#login input').live('keydown', function(e) {
	if (e.keyCode == 13) {
		login();
	}
});
$('#button-login').live('click', function() {
	login();
});

// Register
function register(){
	$.ajax({
		url: 'index.php?route=onepage/register/validate',
		type: 'post',
		data: $('#payment-address input[type=\'text\'], #payment-address input[type=\'password\'], #payment-address input[type=\'checkbox\']:checked, #payment-address input[type=\'radio\']:checked, #payment-address input[type=\'hidden\'], #payment-address select'),
		dataType: 'json',
		beforeSend: function() {
			$('#button-payment-address-save').attr('disabled', true);
			$('#button-payment-address-save').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
		},	
		complete: function(json) {
			$('#button-payment-address-save').attr('disabled', false); 
			$('#payment-address .wait').remove();
			window.location.reload();
		},			
		success: function(json) {
			$('#payment-address .warning, #payment-address .error').remove();
						
			if (json['redirect']) {
				location = json['redirect'];
			} else if (json['error']) {
				if (json['error']['warning']) {
					$('#payment-address .checkout-content').prepend('<div class="warning" style="display: none;">' + json['error']['warning'] + '<img src="catalog/view/theme/default/image/close.png" alt="" class="close" /></div>');
					
					$('#payment-address .warning').fadeIn('slow');
				}
				
				if (json['error']['firstname']) {
					$('#payment-address input[name=\'firstname\'] + br').after('<span class="error">' + json['error']['firstname'] + '</span>');
				}
				
				if (json['error']['lastname']) {
					$('#payment-address input[name=\'lastname\'] + br').after('<span class="error">' + json['error']['lastname'] + '</span>');
				}	
				
				if (json['error']['email']) {
					$('#payment-address input[name=\'email\'] + br').after('<span class="error">' + json['error']['email'] + '</span>');
				}
				
				if (json['error']['telephone']) {
					$('#payment-address input[name=\'telephone\'] + br').after('<span class="error">' + json['error']['telephone'] + '</span>');
				}	
					
				if (json['error']['company_id']) {
					$('#payment-address input[name=\'company_id\'] + br').after('<span class="error">' + json['error']['company_id'] + '</span>');
				}	
				
				if (json['error']['tax_id']) {
					$('#payment-address input[name=\'tax_id\'] + br').after('<span class="error">' + json['error']['tax_id'] + '</span>');
				}	
																		
				if (json['error']['address_1']) {
					$('#payment-address input[name=\'address_1\'] + br').after('<span class="error">' + json['error']['address_1'] + '</span>');
				}	
				
				if (json['error']['city']) {
					$('#payment-address input[name=\'city\'] + br').after('<span class="error">' + json['error']['city'] + '</span>');
				}	
				
				if (json['error']['postcode']) {
					$('#payment-address input[name=\'postcode\'] + br').after('<span class="error">' + json['error']['postcode'] + '</span>');
				}	
				
				if (json['error']['country']) {
					$('#payment-address select[name=\'country_id\'] + br').after('<span class="error">' + json['error']['country'] + '</span>');
				}	
				
				if (json['error']['zone']) {
					$('#payment-address select[name=\'zone_id\'] + br').after('<span class="error">' + json['error']['zone'] + '</span>');
				}
				
				if (json['error']['password']) {
					$('#payment-address input[name=\'password\']').after('<span class="error">' + json['error']['password'] + '</span>');
				}	
				
				if (json['error']['confirm']) {
					$('#payment-address input[name=\'confirm\']').after('<span class="error">' + json['error']['confirm'] + '</span>');
				}																																	
			}
		}
	});
}

// Change Payment Address
$("#payment-existing select[name='address_id']").live('change', function(){
	change_payment_address();
	<?php if ($logged) { ?>
	if ($('#shipping').attr('checked')) {
		$("#shipping-existing select[name='address_id']").val($("#payment-existing select[name='address_id']").val());
		$("#shipping-existing select[name='address_id']").trigger('change');
	};
	<?php }; ?>
});

// Change Shipping Address
$("#shipping-existing select[name='address_id']").live('change', function(){
	change_shipping_address();
});

// Save Payment Details
$('#button-payment-address-save').live('click', function(){
	if ($('#register').attr('checked')) {
		register();
	}else{
		var	reload_flag = 1;
		change_payment_address(reload_flag);
	};
});

// Save Shipping Details
$('#button-shipping-address-save').live('click', function(){
	var reload_flag = 1;
	change_shipping_address(reload_flag);
});

// Reset Payment Details
$('#button-payment-address-reset').live('click', function(){
	/*$('#payment-new .tiny-field').val('');*/
	$('#payment-new .large-field').val('');
	$("#payment-new select[name='country_id']").val('<?php echo $country_id; ?>');
	$("#payment-new select[name='zone_id']").val('');
});

// Reset Shipping Details
$('#button-shipping-address-reset').live('click', function(){
	/*$('#shipping-new .tiny-field').val('');*/
	$('#shipping-new .large-field').val('');
	$("#shipping-new select[name='country_id']").val('<?php echo $country_id; ?>');
	$("#shipping-new select[name='zone_id']").val('');
});

$("input[name='shipping_method']").live('change', function(){
	send_shipping_method();
})

$("input[name='payment_method']").live('change', function(){
	send_payment_method();
})

// The Same Address Checkbox
$('#shipping').live('change', function(){
	shipping_address_display_status();
});

<?php if (!$logged) { ?> 
$(document).ready(function() {
	$.ajax({
		url: 'index.php?route=onepage/login',
		dataType: 'html',
		success: function(html) {
			$('#checkout .checkout-content').html(html);
				
			$('#checkout .checkout-content').slideDown('slow');
		}
	});
	load_payment_address();
	load_shipping_address();
});		
<?php } else { ?>
$(document).ready(function() {
	load_payment_address();
	load_shipping_address();
});
<?php } ?>
//--></script> 
<?php echo $footer; ?>