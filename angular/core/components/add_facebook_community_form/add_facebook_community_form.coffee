angular.module('loomioApp').directive 'addFacebookCommunityForm', (Records, LoadingService, Session) ->
  templateUrl: 'generated/components/add_facebook_community_form/add_facebook_community_form.html'
  controller: ($scope) ->
    $scope.facebook = {}

    $scope.$watch 'community.customFields.facebook_group_id', ->
      return unless $scope.community.customFields.facebook_group_id
      $scope.community.customFields.facebook_group_name = _.find($scope.allFacebookGroups, (group) ->
        $scope.community.customFields.facebook_group_id == group.id
      ).name

    $scope.fetchFacebookGroups = ->
      Records.identities.perform(Session.user().facebookIdentity().id, 'admin_groups').then (response) ->
        $scope.allFacebookGroups = response.admin_groups
    LoadingService.applyLoadingFunction $scope, 'fetchFacebookGroups'
    $scope.fetchFacebookGroups()

    alreadyOnPoll = (group) ->
      _.find $scope.poll.communities(), (community) ->
        community.customFields.facebook_group_id == group.id

    $scope.facebookGroups = ->
      _.filter $scope.allFacebookGroups, (group) ->
        !alreadyOnPoll(group) and
        (_.isEmpty($scope.facebook.fragment) or group.name.match(///#{$scope.facebook.fragment}///i))
