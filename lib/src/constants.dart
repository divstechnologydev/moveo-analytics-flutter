
const String libVersion = '0.0.11';

// Environment Enum
enum Environment {
  development('development'),
  production('production');

  final String value;
  const Environment(this.value);
}

// MoveoOneEventType Enum
enum MoveoOneEventType {
  startSession('start_session'),
  track('track'),
  updateMetadata('update_metadata'),
  updateAdditionalMetadata('update_additional_metadata');


  final String value;
  const MoveoOneEventType(this.value);
}

// MoveoOneType Enum
enum MoveoOneType {
  button('button'),
  text('text'),
  textEdit('textEdit'),
  image('image'),
  images('images'),
  imageScrollHorizontal('image_scroll_horizontal'),
  imageScrollVertical('image_scroll_vertical'),
  picker('picker'),
  slider('slider'),
  switchControl('switchControl'),
  progressBar('progressBar'),
  checkbox('checkbox'),
  radioButton('radioButton'),
  table('table'),
  collection('collection'),
  segmentedControl('segmentedControl'),
  stepper('stepper'),
  datePicker('datePicker'),
  timePicker('timePicker'),
  searchBar('searchBar'),
  webView('webView'),
  scrollView('scrollView'),
  activityIndicator('activityIndicator'),
  video('video'),
  videoPlayer('videoPlayer'),
  audioPlayer('audioPlayer'),
  map('map'),
  tabBar('tabBar'),
  tabBarPage('tabBarPage'),
  tabBarPageTitle('tabBarPageTitle'),
  tabBarPageSubtitle('tabBarPageSubtitle'),
  toolbar('toolbar'),
  alert('alert'),
  alertTitle('alertTitle'),
  alertSubtitle('alertSubtitle'),
  modal('modal'),
  toast('toast'),
  badge('badge'),
  dropdown('dropdown'),
  card('card'),
  chip('chip'),
  grid('grid'),
  custom('custom');

  final String value;
  const MoveoOneType(this.value);
}

// MoveoOneAction Enum
enum MoveoOneAction {
  appear('appear'),
  disappear('disappear'),
  swipe('swipe'),
  scroll('scroll'),
  drag('drag'),
  drop('drop'),
  tap('tap'),
  doubleTap('doubleTap'),
  longPress('longPress'),
  pinch('pinch'),
  zoom('zoom'),
  rotate('rotate'),
  submit('submit'),
  select('select'),
  deselect('deselect'),
  hover('hover'),
  focus('focus'),
  blur('blur'),
  input('input'),
  valueChange('valueChange'),
  dragStart('dragStart'),
  dragEnd('dragEnd'),
  refresh('refresh'),
  play('play'),
  pause('pause'),
  stop('stop'),
  seek('seek'),
  error('error'),
  success('success'),
  cancel('cancel'),
  retry('retry'),
  share('share'),
  expand('expand'),
  collapse('collapse'),
  edit('edit'),
  custom('custom');

  final String value;
  const MoveoOneAction(this.value);
}