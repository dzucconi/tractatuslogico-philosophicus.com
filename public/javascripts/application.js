(function(){
  "use-strict";

  var App = {
    Routers : {},
    Views   : {},

    initialize: function() {
      this.router = new App.Routers.Router();

      Backbone.history.start();
    }
  };

  App.Routers.Router = Backbone.Router.extend({
    routes: {
      "node/:node" : "node",
      "expanded"   : "expandAll",
      "collapsed"  : "collapseAll"
    },

    initialize: function() {
      this.documentView = new App.Views.DocumentView();
    },

    node: function(id) {
      var $target = $("#" + id);

      $target.addClass("is-open is-highlighted").children("ol").show();
      $target.parents().addClass("is-open").show();
    },

    expandAll: function() {
      $("body").removeClass("is-collapsed").addClass("is-expanded");

      $("ol").show();
      $("li").addClass("is-open");
    },

    collapseAll: function() {
      $("body").removeClass("is-expanded").addClass("is-collapsed");

      $(".child").hide();
      $("li").removeClass("is-open");
    }
  });

  App.Views.DocumentView = Backbone.View.extend({
    el: "#document",

    events: {
      "click .is-parent"    : "toggleNode",
      "click .is-childless" : "preventCollapse"
    },

    initialize: function() {
      this.once("node:toggle", this.removeHighlight);
    },

    removeHighlight: function() {
      $(".is-highlighted").removeClass("is-highlighted");
    },

    preventCollapse: function(e) {
      return false;
    },

    toggleNode: function(e) {
      this.trigger("node:toggle");

      var $target = $(e.currentTarget);

      $target.toggleClass("is-open").children("ol").toggle();

      App.router.navigate("node/" + $target.attr("id"), { trigger: false, replace: true });

      return false;
    }
  });

  $(function(){ App.initialize(); });
}());
