(function(){
  "use-strict";

  var App = {
    Models      : {},
    Collections : {},
    Routers     : {},
    Views       : {},

    initialize: function() {
      this.router = new App.Routers.Router();

      Backbone.history.start();
    }
  };

  App.Routers.Router = Backbone.Router.extend({
    routes: {
      "" : "index"
    },

    initialize: function() {
      this.menuView = new App.Views.MenuView();
      this.documentView = new App.Views.DocumentView();
    }
  });

  App.Views.MenuView = Backbone.View.extend({
    el: "#menu",

    events: {
      "click #expand"   : "expandAll",
      "click #collapse" : "collapseAll"
    },

    expandAll: function() {
      $("ol").show();
      $("li").addClass("is-open");
      $("#expand").hide();
      $("#collapse").show();
    },

    collapseAll: function() {
      $(".child").hide();
      $("li").removeClass("is-open");
      $("#collapse").hide();
      $("#expand").show();
    }
  });

  App.Views.DocumentView = Backbone.View.extend({
    el: "#document",

    events: {
      "click .is-parent"    : "openNode",
      "click .is-childless" : "preventCollapse"
    },

    preventCollapse: function(e) {
      return false;
    },

    openNode: function(e) {
      e.stopPropagation();

      $(e.currentTarget).toggleClass("is-open").children("ol").toggle();
    }
  });

  $(function(){ App.initialize(); });
}());
