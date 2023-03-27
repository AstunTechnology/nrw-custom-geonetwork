/*
 * Copyright (C) 2001-2016 Food and Agriculture Organization of the
 * United Nations (FAO-UN), United Nations World Food Programme (WFP)
 * and United Nations Environment Programme (UNEP)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 *
 * Contact: Jeroen Ticheler - FAO - Viale delle Terme di Caracalla 2,
 * Rome - Italy. email: geonetwork@osgeo.org
 */
 
(function () {
  goog.provide("gn_dashboard_controller");
  
  goog.require("gn_dashboard_render_controller");
  goog.require("gn_dashboard_status_controller");
  goog.require("gn_dashboard_record_link_controller");
  goog.require("gn_dashboard_wfs_indexing_controller");
  goog.require("gn_vcs_controller");
  
  var module = angular.module("gn_dashboard_controller", [
    "gn_dashboard_status_controller",
    "gn_dashboard_render_controller",
    "gn_dashboard_record_link_controller",
    "gn_vcs_controller"
  ]);
  
  /**
   *
   */
  module.controller("GnDashboardController", [
    "$scope",
    "$http",
    "gnGlobalSettings",
    function ($scope, $http, gnGlobalSettings) {
      $scope.info = {};
      $scope.gnUrl = gnGlobalSettings.gnUrl;
      
      var userAdminTabs = [
        {
          type: "record-links",
          label: "record-links",
          icon: "fa-link",
          href: "#/dashboard/record-links"
        }
      ];
      
      $scope.pageMenu = {
        folder: "dashboard/",
        defaultTab: "status",
        tabs: [
          {
            type: "status",
            label: "status",
            icon: "fa-dashboard",
            href: "#/dashboard/status"
          },
          {
            type: "record-links",
            label: "record-links",
            icon: "fa-link",
            href: "#/dashboard/record-links"
          },
          {
            type: "information",
            label: "information",
            icon: "fa-list-ul",
            href: "#/dashboard/information"
          },
          {
            type: "versioning",
            label: "versioning",
            icon: "fa-rss",
            href: "#/dashboard/versioning"
          },
          {
            type: "feedbacks",
            label: "userFeedbackList",
            icon: "fa-comments",
            href: "#/dashboard/feedbacks"
          }
        ]
      };
      
      var dashboards = [{
        type: 'statistics',
        label: 'contentStatistics',
        icon: 'fa-bar-chart',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/app/kibana#/dashboard/' +
             '853fef90-8dce-11e9-9bb7-5db216293bad?embed=true&_g=(refreshInterval:(pause:!t,value:0),time:(from:now-30d,to:now))')
      //TODO: The following dashboards need a rework
      }, {
        type: 'statistics',
        label: 'validationStatistics',
        icon: 'fa-bar-chart',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/app/kibana#/dashboard/' +
            '915983d0-2c2e-11e7-a889-7bfa00c573d3?embed=true&_g=()')
      }, {
        type: 'statistics',
        label: 'searchStatistics',
        icon: 'fa-search',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/app/kibana#/dashboard/' +
            '4b5edcf0-8be2-11eb-8255-7ba8c90e1ee6?embed=true&_g=()')
      },  {
        type: 'statistics',
        label: 'filebeatNginxStatistics',
        icon: 'fa-server',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/s/catalogue-monitor/app/kibana#/dashboard/' +
            '55a9e6e0-a29e-11e7-928f-5dbe6f6f5519-ecs?embed=true&_g=()')
      }, {
        type: 'statistics',
        label: 'metricbeatNginxStatistics',
        icon: 'fa-server',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/s/catalogue-monitor/app/kibana#/dashboard/' +
            '023d2930-f1a5-11e7-a9ef-93c69af7b129-ecs?embed=true&_g=()')
      }, {
        type: 'statistics',
        label: 'filebeatDatabaseStatistics',
        icon: 'fa-database',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/s/catalogue-monitor/app/kibana#/dashboard/' +
            '158be870-87f4-11e7-ad9c-db80de0bf8d3-ecs?embed=true&_g=()')
      }, {
        type: 'statistics',
        label: 'metricbeatDatabaseStatistics',
        icon: 'fa-database',
        href: '#/dashboard/statistics?dashboard=' +
            encodeURIComponent('../../dashboards/s/catalogue-monitor/app/kibana#/dashboard/' +
            '4288b790-b79f-11e9-a579-f5c0a5d81340?embed=true&_g=()')
      }];
      
      function loadConditionalTabs() {
        if ($scope.user.profile === "UserAdmin") {
          $scope.pageMenu.tabs = userAdminTabs;
          $scope.pageMenu.defaultTab = "record-links";
        }
        
        if ($scope.healthCheck.DashboardAppHealthCheck === true) {
          $scope.pageMenu.tabs = $scope.pageMenu.tabs.concat(dashboards);
        }
      }
      
      loadConditionalTabs();
      
      $scope.$watch("healthCheck.DashboardAppHealthCheck", function (n, o) {
        if (n !== o) {
          loadConditionalTabs();
        }
      });
      
      $scope.$watchCollection("user", function (n, o) {
        if (n !== o) {
          loadConditionalTabs();
        }
      });
      
      $http.get("../api/site/info").then(function (response) {
        $scope.info = response.data;
      });
    }
  ]);
})();