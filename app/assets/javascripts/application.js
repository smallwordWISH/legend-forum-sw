// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require turbolinks
//= require jquery
//= require bootstrap-sprockets
//= require_tree .


$(document).on('turbolinks:load', function() {

  $('.container').on('click', '.reply-panel .edit-delete-group .reply-edit-btn', function() {
    $(this).parent('.edit-delete-group').siblings('.reply-content-item').hide();
    $(this).parent('.edit-delete-group').siblings('.reply-edit-form').show();
    $(this).parent('.edit-delete-group').hide();
  });

  $('.container').on('click', '.reply-panel .reply-edit-form .reply-cancel-btn', function() {
    $(this).parents('.reply-edit-form ').siblings('.reply-content-item').show();
    $(this).parents('.reply-edit-form').siblings('.edit-delete-group').show();
    $(this).parents('.reply-edit-form').hide();
  });

  $('.container').on('keyup', '.reply-edit-form textarea', function(){
    var textarea = $(this).val();
    if (textarea.length == 0) {
      $(this).parents('.reply-edit-form').find('.btn-primary').attr('disabled', true);
    } else {
      $(this).parents('.reply-edit-form').find('.btn-primary').attr('disabled', false);
    } 
  });

  $(document).on('mouseenter', '.collected-btn', function(){
    $(this).css({
      'background': 'var(--danger)',
      'border-color': 'var(--danger)'
    });
    $(this).text('Uncollect');
  });

   $(document).on('mouseleave', '.collected-btn', function(){
    $(this).css({
      'background': 'var(--info)',
      'border-color': 'var(--info)'
    });
    $(this).html('Collected');
  });
});