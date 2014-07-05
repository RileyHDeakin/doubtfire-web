angular.module("doubtfire.header", [ ])

.factory("headerService", ($rootScope) ->
  
  # use the menus here to inject non-global menus
  # dynamically to a page (i.e., page-specific menus such as "role")
  
  # menuLinks = [ { class: 'active/nil', url: '/someUrl', name: 'Link Title' } ... ]
  # menu      = { name: 'Menu Title', links: menuLinks, icon: 'icon' }
  
  $rootScope.header_menu_data = [ ]
  menus: () -> $rootScope.header_menu_data
  clearMenus: ->
    $rootScope.header_menu_data.length = 0
  setMenus: (new_menus) ->
    $rootScope.header_menu_data.length = 0
    $rootScope.header_menu_data.push menu for menu in new_menus
  push: (new_menu) ->
    # push only if adding unique name
    $rootScope.header_menu_data.push new_menu if (menu for menu in $rootScope.header_menu_data when menu.name is new_menu.name).length == 0
)

.factory("alertService", ($rootScope, $timeout) ->
  $rootScope.alerts = []

  alertSvc =
    add: (type, msg, timeout) ->
      $rootScope.alerts.push(
        type: type,
        msg: msg,
        close: ->
          alertSvc.closeAlert(this)
      )
      if (timeout)
        $timeout( ->
          alertSvc.closeAlert(this)
        , timeout)
    closeAlert: (alert) ->
      this.closeAlertIdx($rootScope.alerts.indexOf(alert))
    closeAlertIdx: (index) ->
      $rootScope.alerts.splice(index, 1)
    clear: ->
      $rootScope.alerts = []
) # end factory


.controller("BasicHeaderCtrl", ($scope, $state, currentUser, headerService, UnitRole, Project) ->
  $scope.name = currentUser.profile.name
  $scope.nickname = currentUser.profile.nickname
  $scope.menus = headerService.menus()

  # Global Units Menu
  $scope.unitRoles = UnitRole.query()
  $scope.projects = Project.query()
  
  $scope.isUniqueUnitRole = (unit) ->
    units = (item for item in $scope.unitRoles when item.unit_id is unit.unit_id)
    # teaching userRoles will default to tutor role if both convenor and tutor
    units.length == 1 || unit.role == "Tutor"
)

.controller("BasicSidebarCtrl", ($scope, $state, currentUser, headerService, UnitRole, Project) ->
  $scope.unitRoles = UnitRole.query()
  $scope.projects = Project.query()

  $scope.isTutor = (userRole) ->
    userRole.role == "Tutor"
  $scope.isConvenor = (userRole) ->
    userRole.role == "Convenor"
)