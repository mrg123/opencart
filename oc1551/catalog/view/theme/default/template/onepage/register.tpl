  <div class="left">
  <span class="required">*</span> <?php echo $entry_password; ?><br />
  <input type="password" name="password" value="" class="large-field" />
  </div>
  <div class="right">
  <span class="required">*</span> <?php echo $entry_confirm; ?> <br />
  <input type="password" name="confirm" value="" class="large-field" />
  </div>
  <br />
<div class="clear" style="padding:10px 0;">
  <input type="checkbox" name="newsletter" value="1" id="newsletter" />
  <label for="newsletter"><?php echo $entry_newsletter; ?></label>
</div>
<?php if ($text_agree) { ?>
<div class="buttons">
  <div class="right"><span><?php echo $text_agree; ?></span>
  </div>
</div>
<?php } ?>
