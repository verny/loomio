angular.module('loomioApp').factory 'DiscussionForm', ->
  templateUrl: 'generated/components/discussion_form/discussion_form.html'
  controller: ($scope, $controller, $location, discussion, CurrentUser, Records, AbilityService, FormService, KeyEventService) ->
    $scope.discussion = discussion.clone()

    if $scope.discussion.isNew() and !$scope.discussion.groupId?
      $scope.showGroupSelect = true

    $scope.$on 'modal.closing', (event) ->
      FormService.confirmDiscardChanges(event, $scope.discussion)

    actionName = if $scope.discussion.isNew() then 'created' else 'updated'

    $scope.submit = FormService.submit $scope, $scope.discussion,
      flashSuccess: "discussion_form.messages.#{actionName}"
      successCallback: (response) =>
        $location.path "/d/#{response.discussions[0].key}" if actionName == 'created'

    $scope.availableGroups = ->
      _.filter CurrentUser.groups(), (group) ->
        AbilityService.canStartThread(group)

    $scope.showPrivacyForm = ->
      return unless $scope.discussion.group()
      $scope.discussion.group().discussionPrivacyOptions == 'public_or_private'

    KeyEventService.submitOnEnter $scope
