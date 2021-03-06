angular.module('loomioApp').directive 'navbar', ->
  scope: {}
  restrict: 'E'
  templateUrl: 'generated/components/navbar/navbar.html'
  replace: true
  controller: ($scope, $rootScope, Records, ThreadQueryService, AppConfig) ->
    console.log AppConfig.baseUrl
    parser = document.createElement('a')
    parser.href = AppConfig.baseUrl
    console.log parser.hostname

    $scope.officialLoomio = AppConfig.baseUrl == 'https://www.loomio.org/'

    $scope.hostName = parser.hostname


    $scope.$on 'currentComponent', (el, component) ->
      $scope.selected = component.page

    $scope.unreadThreadCount = ->
      ThreadQueryService.filterQuery('show_unread', queryType: 'inbox').length()

    $scope.homePageClicked = ->
      $rootScope.$broadcast 'homePageClicked'
