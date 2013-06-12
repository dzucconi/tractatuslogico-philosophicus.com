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
    },

    attachMenu: function($el) {
      $el.find("#expand").on("click", function() {
        $("ol").show();
      });

      $el.find("#collapse").on("click", function() {
        $("li > ol").hide();
      });
    }
  };

  var App = {
    initialize: function() {
      Tractatus.foldAndAttach($("#root"));
      Tractatus.attachMenu($("#menu"));
    }
  };

  $(function(){ App.initialize(); });
}());
