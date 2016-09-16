$(function() {

    // Enables linking to specific tabs:
    if (window.location.hash){
      var hash = $.trim(window.location.hash);
      var tab = decodeURI(hash.substring(1, 100));
      $('a[data-value=\"'+tab+'\"]').click();
    }
    
    // Reveals the KPI dropdown menu at launch:
    $('ul.sidebar-menu li.treeview').first().addClass('active');
    
    // Update the URL in the browser when a tab is clicked on:
    $('a[href^="#shiny-tab"]').click(function(){
      window.location.hash = encodeURI($(this).attr('data-value'));
    })

});
