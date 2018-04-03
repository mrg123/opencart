<?php if (!isset($redirect)) { ?>
<div class="checkout-product">
  <table>
    <thead>
      <tr>
        <td class="name"><?php echo $column_name; ?></td>
        <td class="model"><?php echo $column_model; ?></td>
        <td class="image"><?php echo $column_image; ?></td>
        <td class="quantity"><?php echo $column_quantity; ?></td>
        <td class="price"><?php echo $column_price; ?></td>
        <td class="total"><?php echo $column_total; ?></td>
      </tr>
    </thead>
    <tbody>
      <?php foreach ($products as $product) { ?>
      <tr>
        <td class="name"><a target="blank" href="<?php echo $product['href']; ?>"><?php echo $product['name']; ?></a>
          <?php foreach ($product['option'] as $option) { ?>
          <br />
          &nbsp;<small> - <?php echo $option['name']; ?>: <?php echo $option['value']; ?></small>
          <?php } ?></td>
        <td class="model"><?php echo $product['model']; ?></td>
        <td class="image"><a href="<?php echo $product['href']; ?>"><img src="<?php echo $product['thumb']; ?>" alt="<?php echo $product['name']; ?>"></a></td>
        <td class="quantity"><?php echo $product['quantity']; ?></td>
        <td class="price"><?php echo $product['price']; ?></td>
        <td class="total"><?php echo $product['total']; ?></td>
      </tr>
      <?php } ?>
      <?php foreach ($vouchers as $voucher) { ?>
      <tr>
        <td class="name"><?php echo $voucher['description']; ?></td>
        <td class="model"></td>
        <td class="image"></td>
        <td class="quantity">1</td>
        <td class="price"><?php echo $voucher['amount']; ?></td>
        <td class="total"><?php echo $voucher['amount']; ?></td>
      </tr>
      <?php } ?>
    </tbody>
    <tfoot>
      <?php foreach ($totals as $total) { ?>
      <tr>
        <td colspan="4" class="price"><b><?php echo $total['title']; ?>:</b></td>
        <td class="total"><?php echo $total['text']; ?></td>
      </tr>
      <?php } ?>
    </tfoot>
  </table>
</div>
<?php if (isset($before_validate)) { ?>
  <?php if ($text_agree) { ?>
  <div class="buttons">
    <div class="right"><span><?php echo $text_agree; ?></span></div>
  </div>
  <?php } ?>
  <div class="buttons">
    <div class="right">
      <input type="button" value="<?php echo $button_confirm; ?>" id="button-confirm" class="button">
    </div>
  </div>
  <script type="text/javascript">
    $('.colorbox').colorbox({
      width: 640,
      height: 480
    });
    $('#button-confirm').live('click', function(){
      if ($('#payment-address .wait').length == 0 && $('#shipping-address .wait').length ==0 && $('#shipping-method .wait').length == 0 && $('#payment-method .wait').length == 0 && $('#confirm .wait').length == 0) {
        load_confirm_validate();
      };
    })
  </script>
<?php }else{ ?>
  <div class="payment"><?php echo $payment; ?></div>
  <script type="text/javascript">
  if ($('#button-confirm').length > 0) {
    $('#button-confirm').after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
    $('#button-confirm').trigger('click');
  }else{
    $("#confirm input[type='submit']").after('<span class="wait">&nbsp;<img src="catalog/view/theme/default/image/loading.gif" alt="" /></span>');
    $("#confirm form").submit();
  };
  </script>
<?php } ?>
<?php } else { ?>
<script type="text/javascript"><!--
location = '<?php echo $redirect; ?>';
//--></script> 
<?php } ?>