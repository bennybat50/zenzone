import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';

import '../models/data_models.dart';

class AppBloc extends ChangeNotifier {
  String? _errorMsg,
      _successMsg,
      _selectedHomeInterestId = "",
      _selectedHostInterestId = "",
      _selectedInterestId = "";

  AssetsAudioPlayer? _assetsAudioPlayer;
  int _pageIndex = 0;
  List _interests = [],
      _bookmarks = [],
      _resources = [],
      _selectedHomeInterest = [],
      _selectedHostInterest = [],
      _popularResources = [],
      _bonus = DataModels.bonus,
      _partners = DataModels.partners,
      _durations = DataModels.durations,
      _currencies = DataModels.currencies,
      _withdrawalMethods = DataModels.withdrawalMethods,
      _messages = DataModels.messages;
  bool _hasResources = false,
      _hasInterests = false,
      _hasPopular = false,
      _hasBookmarks = false,
      _hasHostData = false,
      _hasDashboard = false,
      _hasSearchResult = false,
      _hasAHostData = false;
  var _mapSuccess,
      _regIndividual = {},
      _regBusiness = {},
      _userDashboard = {},
      _hostDashboard = {},
      _searchResult = {},
      _selectedInterestResource = {},
      _selectedUploadInterest = {},
      _selectedResourceData = {},
      _selectedHomeInterestIndex = 0,
      _selectedHostInterestIndex = 0,
      _selectedInterestResourceIndex = 0,
      _userDetails = {},
      _appVersion = {};

  get appVersion => _appVersion;
  get pageIndex => _pageIndex;
  get hasPopular => _hasPopular;
  get popularResources => _popularResources;
  get selectedResourceData => _selectedResourceData;
  get searchResult => _searchResult;
  get hasAHostData => _hasAHostData;
  get assetsAudioPlayer => _assetsAudioPlayer;
  get hasHostData => _hasHostData;
  get selectedUploadInterest => _selectedUploadInterest;
  get hostDashboard => _hostDashboard;
  get hasSearchResult => _hasSearchResult;
  get selectedHomeInterestIndex => _selectedHomeInterestIndex;
  get selectedHomeInterest => _selectedHomeInterest;
  get selectedHomeInterestId => _selectedHomeInterestId;

  get selectedHostInterestIndex => _selectedHostInterestIndex;
  get selectedHostInterest => _selectedHostInterest;
  get selectedHostInterestId => _selectedHostInterestId;

  get messages => _messages;
  get hasDashboard => _hasDashboard;
  get userDashboard => _userDashboard;
  get durations => _durations;
  get currencies => _currencies;
  get hasBookmarks => _hasBookmarks;
  get hasResources => _hasResources;
  get hasInterests => _hasInterests;

  get regBusiness => _regBusiness;
  get regIndividual => _regIndividual;
  get errorMsg => _errorMsg;
  get successMsg => _successMsg;
  get mapSuccess => _mapSuccess;
  get userDetails => _userDetails;
  get interests => _interests;
  get bookmarks => _bookmarks;
  get resources => _resources;
  get bonus => _bonus;
  get partners => _partners;
  get withdrawalMethods => _withdrawalMethods;

  get selectedInterestResourceIndex => _selectedInterestResourceIndex;
  get selectedInterestResource => _selectedInterestResource;
  get selectedInterestId => _selectedInterestId;

  set selectedResourceData(value) {
    _selectedResourceData = value;
    notifyListeners();
  }

  set popularResources(value) {
    _popularResources = value;
    notifyListeners();
  }

  set hasPopular(value) {
    _hasPopular = value;
    notifyListeners();
  }

  set appVersion(value) {
    _appVersion = value;
    notifyListeners();
  }

  set pageIndex(value) {
    _pageIndex = value;
    notifyListeners();
  }

  set hasAHostData(value) {
    _hasAHostData = value;
    notifyListeners();
  }

  set assetsAudioPlayer(value) {
    _assetsAudioPlayer = value;
    notifyListeners();
  }

  set searchResult(value) {
    _searchResult = value;
    notifyListeners();
  }

  set selectedUploadInterest(value) {
    _selectedUploadInterest = value;
    notifyListeners();
  }

  set hasHostData(value) {
    _hasHostData = value;
    notifyListeners();
  }

  set hostDashboard(value) {
    _hostDashboard = value;
    notifyListeners();
  }

  set hasSearchResult(value) {
    _hasSearchResult = value;
    notifyListeners();
  }

  set selectedInterestResourceIndex(value) {
    _selectedInterestResourceIndex = value;
    notifyListeners();
  }

  set selectedInterestResource(value) {
    _selectedInterestResource = value;
    notifyListeners();
  }

  set selectedInterestId(value) {
    _selectedInterestId = value;
    notifyListeners();
  }

  set selectedHostInterestIndex(value) {
    _selectedHostInterestIndex = value;
    notifyListeners();
  }

  set selectedHostInterestId(value) {
    _selectedHostInterestId = value;
    notifyListeners();
  }

  set selectedHostInterest(value) {
    _selectedHostInterest = value;
    notifyListeners();
  }

  set selectedHomeInterestIndex(value) {
    _selectedHomeInterestIndex = value;
    notifyListeners();
  }

  set selectedHomeInterestId(value) {
    _selectedHomeInterestId = value;
    notifyListeners();
  }

  set selectedHomeInterest(value) {
    _selectedHomeInterest = value;
    notifyListeners();
  }

  set hasDashboard(value) {
    _hasDashboard = value;
    notifyListeners();
  }

  set userDashboard(value) {
    _userDashboard = value;
    notifyListeners();
  }

  set messages(value) {
    _messages = value;
    notifyListeners();
  }

  set durations(value) {
    _durations = value;
    notifyListeners();
  }

  set currencies(value) {
    _currencies = value;
    notifyListeners();
  }

  set hasInterests(value) {
    _hasInterests = value;
    notifyListeners();
  }

  set hasBookmarks(value) {
    _hasBookmarks = value;
    notifyListeners();
  }

  set hasResources(value) {
    _hasResources = value;
    notifyListeners();
  }

  set regBusiness(value) {
    _regBusiness = value;
    notifyListeners();
  }

  set regIndividual(value) {
    _regIndividual = value;
    notifyListeners();
  }

  set bonus(value) {
    _bonus = value;
    notifyListeners();
  }

  set partners(value) {
    _partners = value;
    notifyListeners();
  }

  set withdrawalMethods(value) {
    _withdrawalMethods = value;
    notifyListeners();
  }

  set interests(value) {
    _interests = value;
    notifyListeners();
  }

  set resources(value) {
    _resources = value;
    notifyListeners();
  }

  set bookmarks(value) {
    _bookmarks = value;
    notifyListeners();
  }

  set errorMsg(value) {
    _errorMsg = value;
    notifyListeners();
  }

  set successMsg(value) {
    _successMsg = value;
    notifyListeners();
  }

  set mapSuccess(value) {
    _mapSuccess = value;
    notifyListeners();
  }

  set userDetails(value) {
    _userDetails = value;
    notifyListeners();
  }
}
