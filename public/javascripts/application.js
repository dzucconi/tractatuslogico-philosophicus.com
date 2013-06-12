(function(){
  "use-strict";

  var App = {
    views: {
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
    },

    initialize: function() {
      App.views.foldAndAttach($("#root"));
      App.views.attachMenu($("#menu"));
    }
  };

  $(function(){ App.initialize(); });
}());
