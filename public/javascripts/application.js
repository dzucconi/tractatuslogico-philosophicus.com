(function(){
  "use-strict";

  var Tractatus = {
    foldAndAttach: function($el) {
      $el.find("li > ol").hide().each(function(i) {
        var $parentLi, $childOl;

        $parentLi = $(this).parent("li");
        $childOl = $(this).remove();

        $parentLi.find(".content").on("click", function() {
          $childOl.toggle();
          $parentLi.toggleClass("is-open");
        });

        $parentLi.append($childOl);
      });
    }
  }

  var App = {
    initialize: function() {
      Tractatus.foldAndAttach($("#root"));
    }
  };

  $(function(){ App.initialize(); });
}());
