// ==========================================================================================================================================================

// Abstract class representing the base state for the application.
abstract class AppStates {}

//==========================================================================================================================================================

// State class representing the initial state of the application.
class AppInitialState extends AppStates {}

//==========================================================================================================================================================

// State class indicating a change in the bottom navigation bar index.
class AppChangeBottomNavBarState extends AppStates {}

//==========================================================================================================================================================

// State class indicating the successful creation of the database.
class AppCreateDatabaseState extends AppStates {}

//==========================================================================================================================================================

// State class indicating the successful retrieval of data from the database.
class AppGetDatabaseState extends AppStates {}

//==========================================================================================================================================================

// State class indicating the successful insertion of data into the database.
class AppInsertDatabaseState extends AppStates {}

//==========================================================================================================================================================

// State class indicating a change in the state of the bottom sheet and floating action button.
class AppChangeBottomSheetState extends AppStates {}

//==========================================================================================================================================================

// State class indicating that data retrieval from the database is in progress.
class AppGetDatabaseLoadingState extends AppStates {}

//==========================================================================================================================================================

// State class indicating the successful update of data in the database.
class AppUpdateDatabaseState extends AppStates {}

//==========================================================================================================================================================

// State class indicating the successful deletion of data from the database.
class AppDeleteDatabaseState extends AppStates {}

// ==========================================================================================================================================================
