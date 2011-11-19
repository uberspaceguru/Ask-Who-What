<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Pistilli Realty | NYC Residential &amp; Commerical Real Estate</title>
  <meta name="description" content="The Pistilli Realty group has built its group of New York rentals on quality customer service and family values.">
  <meta name="keywords" content="rentals, condos, apartments">
  <?php echo template::include_stylesheets(array('reset', 'login')) ?>
  <?php echo template::include_javascripts(array('login')) ?>
  <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
  <![endif]-->
  <script type="text/javascript">
    $.fn.selectRange = function(start, end) {
      return this.each(function() {
        if (this.setSelectionRange) {
          this.focus();
          this.setSelectionRange(start, end);
        } else if (this.createTextRange) {
          var range = this.createTextRange();
          range.collapse(true);
          range.moveEnd('character', end);
          range.moveStart('character', start);
          range.select();
        }
      });
    };
    
    function validateLogin() {
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      var ret = true;
      if($("#phone").val() == '' || isNaN($("#phone").val()) || $("#phone").val().length != 10) {
        $("#phone").addClass('bad');
        $("#phone").removeClass('entered');
        $("#phone").val('');
        ret = false;
      } else
        $("#phone").removeClass('bad');
        
      if($("#lpass").val() == '') {
        $("#lpass").addClass('bad');
        $("#lpass").removeClass('entered');
        $("#lpass").val('');
        ret = false;
      } else
        $("#lpass").removeClass('bad');
        
      if($("#email").val() == '' || !emailReg.test($("#email").val())) {
        $("#email").addClass('bad');
        $("#email").removeClass('entered');
        $("#email").val('');
        ret = false;
      } else
        $("#email").removeClass('bad');
        
      return ret;
    }
    
    function validateReg() {
      var ret = true;
      var emailReg = /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/;
      var eles = ['name', 'company'];
      for(var i = 0; i < eles.length; i++) {
        if($("#" + eles[i]).val() == '') {
          $("#" + eles[i]).addClass('bad');
          $("#" + eles[i]).removeClass('entered');
          $("#" + eles[i]).val('');
          ret = false;
        } else
          $("#" + eles[i]).removeClass('bad');
      }
        
      if($("#rphone").val() == '' || isNaN($("#rphone").val()) || $("#rphone").val().length != 10) {
        $("#rphone").addClass('bad');
        $("#rphone").removeClass('entered');
        $("#rphone").val('');
        ret = false;
      } else
        $("#rphone").removeClass('bad');
        
      if($("#rpassword").val() == '') {
        $("#rpassword").addClass('bad');
        $("#rpassword").removeClass('entered');
        $("#rpassword").val('');
        ret = false;
      } else
        $("#rpassword").removeClass('bad');
        
      if($("#password_confirmation").val() == '') {
        $("#password_confirmation").addClass('bad');
        $("#password_confirmation").removeClass('entered');
        $("#password_confirmation").val('');
        ret = false;
      } else
        $("#password_confirmation").removeClass('bad');
        
      if($("#remail").val() == '' || !emailReg.test($("#remail").val())) {
        $("#remail").addClass('bad');
        $("#remail").removeClass('entered');
        $("#remail").val('');
        ret = false;
      } else
        $("#remail").removeClass('bad');
        
      return ret;
    }
    
    var RecaptchaOptions = {
      theme : 'clean'
    };
    
    function click(eleId) {
      $('#'+eleId).click();
    }


    $(function() {
      $("#new_user").submit(function() {
        return validateReg();
      });
      $("#signin").submit(function() {
        return validateLogin();
      });
      
      $("table tr:first td:last").css('display', 'none');
      $("table tr:last td:last").css('display', 'none');
      $("table td:empty").css('display', 'none');
      $("table tr:first td:nth-child(2)").css('padding', '0 0 0 3px');
      $("table tr:first td:nth-child(2)").css('width', '32px');
      $("table tr:last td:first").attr('colspan', 2);
      $(".switch").click(function() {
        var switchTo = this.href.split('#')[1];
        if(!$(this).hasClass('sel')) {
          $("form.sel").fadeOut('fast', function() {
            $(this).removeClass('sel');
            $('#'+switchTo).addClass('sel');
            $('#'+switchTo).fadeIn('fast');
          });
          $("a").removeClass('sel');
          $(this).addClass('sel');
        }
        return false;
      });      
      $("dd input").focus(function() {
      });
      $("dd input").blur(function() {
        if($(this).val() == $(this).attr('placeholder') || $(this).val() == '')
          $(this).removeClass("entered");
        else
          $(this).addClass("entered");
      });
            
      $(' [placeholder] ').defaultValue();
      
      
      <? if(@$_GET['status'] == 'taken' || @$_GET['status'] == 'captcha' || @$_GET['status'] == 'nomatch') { ?>
        $("#new_user").addClass('sel');
      <? } else if(@$_GET['status'] == 'retrieve_password') { ?>
        $("#retrieve").addClass('sel');
      <? } else { ?>
        $("#signin").addClass('sel');
      <? } ?>
    });
  </script>
</head>
<body>
  <div id="top">
    <header class="container">
      <h1><a href="/">Pistill</a></h1>
    </header>
    <div class="container">
      <section id="forms">
        <p id="intro">We make it easy for <strong>our brokers</strong>. Sign Up Now.</p>
        <ul id="tabs">
          <li><a href="#signin" class="switch<? if(@$_GET['status'] != 'retrieve_password' && @$_GET['status'] != 'taken' && @$_GET['status'] != 'captcha') echo ' sel'; ?>">Sign In</a></li>
          <li><a href="#new_user" class="switch<? if(@$_GET['status'] == 'taken' || @$_GET['status'] == 'captcha') echo ' sel'; ?>">Register</a></li>
          <li class="hidden"><a href="#retrieve" id="ret_but" class="switch<? if(@$_GET['status'] == 'retrieve_password') echo ' sel'; ?>">Retrieve Password</a></li>
        </ul>
        <p class="right">* Already have an account? Sign In.</p>
        <div id="bar"></div>
        <form method="post" action="/user/login" id="signin">
          <?= @$error_messages ?>
          <dl>
            <dt><label for="email">Email</label></dt>
            <dd><input type="email" name="email" id="email" placeholder="Email"></dd>
            
            <dt><label for="phone">Phone</label></dt>
            <dd><input type="tel" name="phone" id="phone" placeholder="Phone" maxlength="10"></dd>
            
            <dt><label for="lpass">Password</label></dt>
            <dd><input type="password" name="password" id="lpass" class="pass" placeholder="Password"></dd>
          </dl>
          <div>
            <div class="left">
            <p id="rem"><input type="checkbox" name="remember" id="remember" /> <label for="remember">Remember Me?</label></p>
            <a href="javascript:click('ret_but');" id="nopass">Forget Password?</a>
            </div>
            <input type="hidden" name="login" value="1">
            <input type="submit" name="signin" class="submit" value="Sign In.">
          </div>
          <div class="clear"></div>
        </form>
        <form method="post" action="/user/register" id="new_user">
          <?= @$error_messages ?>
          <dl>
            <dt><label for="name">Full Name</label></dt>
            <dd><input type="text" name="name" id="name" placeholder="Full Name"></dd>
            
            <dt><label for="company">Company</label></dt>
            <dd><input type="text" name="company" id="company" placeholder="Company"></dd>
            
            <dt><label for="rphone">Phone</label></dt>
            <dd><input type="text" name="phone" id="rphone" placeholder="Phone" maxlength="10"></dd>
            
            <dt><label for="remail">Email</label></dt>
            <dd><input type="text" name="email" id="remail" placeholder="Email"></dd>
            
            <dt><label for="password">Password</label></dt>
            <dd><input type="password" name="password" id="rpassword" placeholder="Password"></dd>
            
            <dt><label for="password_confirmation">Password</label></dt>
            <dd><input type="password" name="password_confirmation" id="password_confirmation" placeholder="Confirm Password"></dd>
          </dl>
          <?= recaptcha_get_html(PUBLIC_KEY) ?>
          <div>
            <input type="hidden" name="reg" value="1">
            <input type="submit" name="new_user" class="submit" value="Create Account.">
          </div>
          <div class="clear"></div>
        </form>
        <form method="post" action="/user/retrieve_password" id="retrieve">
          <?= @$error_messages ?>
          <dl>
            <dt><label for="femail">Email</label></dt>
            <dd><input type="email" name="email" id="femail" placeholder="Email"></dd>
            
            <dt><label for="fphone">Phone</label></dt>
            <dd><input type="tel" name="phone" id="fphone" placeholder="Phone"></dd>
          </dl>
          <div>
            <input type="hidden" name="retrieve" value="1">
            <input type="submit" name="retrieve_password" class="submit" value="Retrieve.">
          </div>
          <div class="clear"></div>
        </form>
      </section>
      <footer>
        <a href="/" id="logo">Pistilli</a>
          <a href="/user/legal" id="legal">Legal Privacy</a>
          <a href="#top" id="to_top">Back To Top</a>
          <a href="http://www.pistillicorner.com" id="go_blog" target="_blank"><strong>Blog</strong></a>
          <a href="/listings" id="go_listings"><strong>View Listings</strong></a>
          <a href="/#contact" id="go_contact"><strong>Contact Us</strong></a>
        <a href="http://www.empirestudios.net/" id="empire">Powered By: Empire Studios</a>
      </footer>
    </div>
  </div>
  <script type="text/javascript">

    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-15789186-6']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();

  </script>
</body>
</html>