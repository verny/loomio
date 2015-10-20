describe 'Activity Card Component', ->

  beforeEach module 'loomioApp'
  beforeEach useFactory

  beforeEach inject ($httpBackend) ->
    $httpBackend.whenGET(/api\/v1\/translations/).respond(200, {})
    $httpBackend.whenGET(/api\/v1\/events/).respond(200, {})
    $httpBackend.whenGET(/api\/v1\/discussions\/inbox/).respond(200, {})
    $httpBackend.whenGET(/api\/v1\/memberships\/my_memberships/).respond(200, {})

  it 'passes the discussion', ->
    prepareDirective @, 'activity_card', { discussion: 'discussion' }, (parent) =>
      parent.discussion = @factory.create 'discussions', title: 'hi mom'
    expect(@$scope.discussion.title).toBe('hi mom')
