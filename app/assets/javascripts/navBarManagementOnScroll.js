$(document).ready(function() {

  function changeNavContent() {
    if($(document).scrollTop() > 50) {
      $('.centered-logo').css({display: 'none'});
      $('.navbar-logo').css({
        padding: '10px',
      });
      $('.third-link').css({
        borderLeft: '1px solid black'
      });
      $('.navbar-laptop-lighttheme').addClass('navbar-on-scroll');
      if ($(window).innerWidth() > 767) {$('.content').css("padding-top", '110px');}
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '70px');}
    } else {
      $('.centered-logo').css({display: 'block'});
      $('.navbar-logo').css({
        padding: '20px',
      });
      $('.third-link').css({
        borderLeft: 'none'
      });
      $('.navbar-laptop-lighttheme').removeClass('navbar-on-scroll');
      if ($(window).innerWidth() > 767) {$('.content').css("padding-top", '183px');}
      if ($('.alert.alert-dismissible')) {$('.alert.alert-dismissible').css("top", '183px');}
    }
  }

  $(document).scroll(function() {
    changeNavContent();
  });
})
