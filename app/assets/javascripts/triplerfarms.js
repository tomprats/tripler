function recalc() {
  var total = 0;
  var drop1 = $('#drop1 > option:selected').val()*15*2;	// Filet steak
  var drop2 = $('#drop2 > option:selected').val()*13*7;	// Ribeye steak
  var drop3 = $('#drop3 > option:selected').val()*12*5;	// Sirloin steak
  var drop4 = $('#drop4 > option:selected').val()*8;		// Sloppy joe
  var drop5 = $('#drop5 > option:selected').val()*10;		// Pulled beef
  var drop6 = $('#drop6 > option:selected').val()*15;		// Roast
  var drop7 = $('#drop7 > option:selected').val()*6;		// Chesapeake Beef Jerky
  var drop8 = $('#drop8 > option:selected').val()*6;		// Sweet and Spicy Beef Jerky
  var drop9 = $('#drop9 > option:selected').val()*6;		// Maple Pepper Beef Jerky
  var drop10 = $('#drop10 > option:selected').val()*6;	// Original Beef Jerky
  var drop11 = $('#drop11 > option:selected').val()*10;	// Sausage
  var drop12 = $('#drop12 > option:selected').val()*6.75;	// Ground Beef
  var drop13 = $('#drop13 > option:selected').val()*6.75;	// Patties
  var drop14 = $('#drop14 > option:selected').val()*6;	// Frozen Dog Food
  var drop15 = $('#drop15 > option:selected').val()*1.50;	// Liver Treats
  var drop16 = $('#drop16 > option:selected').val()*7;	// Ribs
  var drop17 = $('#drop17 > option:selected').val()*6.75;	// Patties
  var promo = $('#promo').val();  // Promo
  var isPromo = false;
  var isPromo2 = false;

  total = drop1+drop2+drop3+drop4+drop5+drop6+drop7+drop8+drop9+drop10+drop11+drop12+drop13+drop14+drop15+drop16+drop17;
  if((total<50)&&(total>0)) {
      total = total + 10;
  }
  if((typeof promo == 'string' )&&(total>0)) {
    if(promo.toLowerCase() == "facebook") {
      total = total - 10;
      isPromo = true;
    } else if(promo.toLowerCase() == "revs") {
      total = total - 2;
      isPromo2 = true;
    }
  }
  $('#total').html("$" + total.toFixed(2));
  if((drop1>0)||(drop2>0)||(drop3>0)||(drop16>0)) {
    $('.steakprice').css('display', 'inline-block');
  } else {
    $('.steakprice').css('display', 'none');
  }
}

function ordering() {
  var isPromo = false;
  var isPromo2 = false;
  var promo = $('#promo').val();  // Promo
  if(typeof promo == 'string') {
    if(promo.toLowerCase() == "facebook") {
      isPromo = true;
    } else if(promo.toLowerCase() == "revs") {
      isPromo2 = true;
    }
  }

  if($('#total').html() == "$0.00") {
    alert("You have not ordered anything. Please use our contact page if you wish to contact us.");
    return false;
  } else {
    if(isPromo) {
      return window.confirm("Congrats, you got $10 off for using our facebook promotion!  Your total is " + $('#total').html() + ". Click OK to confirm your order.  You will be contacted about delivery shortly.");
    } else if(isPromo2) {
      return window.confirm("Congrats, you got $2 off for using our baseball promotion!  Your total is " + $('#total').html() + ". Click OK to confirm your order.  You will be contacted about delivery shortly.");
    } else {
      return window.confirm("Your total is " + $('#total').html() + ". Click OK to confirm your order.  You will be contacted about delivery shortly.");
    }
  }
}
