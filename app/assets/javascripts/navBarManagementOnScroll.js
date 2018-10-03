$(document).ready(function() {

  function changeNavContent() {
    if($(document).scrollTop() > 50) {
      $('.centered-logo').css({display: 'none'});
      $('.third-link').css({
        borderLeft: '1px solid black'
      });
      $('.navbar-laptop-lighttheme').addClass('navbar-on-scroll');
      if ($(window).innerWidth() > 767) {$('.content').css("padding-top", '110px');}
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '70px');}
    } else {
      $('.centered-logo').css({display: 'block'});
      $('.third-link').css({
        borderLeft: 'none'
      });
      $('.navbar-laptop-lighttheme').removeClass('navbar-on-scroll');
      if ($(window).innerWidth() > 767) {$('.content').css("padding-top", '203px');}
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '203px');}
    }
  }

  $(document).scroll(function() {
    changeNavContent();
  });

  $(document).ready(function() {
    changeNavContent();
  });
})
