angular.module('loomioApp').directive 'subgroupsCard', ->
  scope: {group: '='}
  restrict: 'E'
  templateUrl: 'generated/components/group_page/subgroups_card/subgroups_card.html'
  replace: true
  controller: ($scope, Records, AbilityService, ModalService, StartGroupForm) ->
    Records.groups.fetchByParent $scope.group

    $scope.canCreateSubgroups = ->
      AbilityService.canCreateSubgroups($scope.group)

    $scope.startSubgroup = ->
       ModalService.open StartGroupForm, group: -> Records.groups.build(parentId: $scope.group.id)

    $scope.showSubgroupsCard = ->
      $scope.group.subgroups().length
