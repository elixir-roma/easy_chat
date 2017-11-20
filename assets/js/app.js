import $ from 'jquery';
import 'bootstrap-material-design';

const Elm = require('../elm/Main.elm');

var app = Elm.Main.fullscreen();

$(document).ready(function() { $('body').bootstrapMaterialDesign(); });
