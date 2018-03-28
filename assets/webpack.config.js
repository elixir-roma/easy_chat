const path = require('path');
const webpack = require('webpack');
const ExtractTextPlugin = require("extract-text-webpack-plugin");

const elmSource = path.dirname(__dirname) + '/assets/elm';

module.exports = {
  entry: [
    './elm/Main.elm',
    './js/app.js',
    './scss/app.scss'
  ],

  output: {
    path: path.dirname(__dirname) + '/priv/static/js',
    filename: 'app.js'
  },
  module: {
      rules: [
      {
        test: /.(ttf|otf|eot|svg|woff(2)?)(\?[a-z0-9]+)?$/,
        use: [{
           loader: 'file-loader',
           options: {
             name: '[name].[ext]',
             outputPath: '../fonts/',
             publicPath: '../fonts/'
           }
         }]
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
      {
        test: /\.(scss)$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: [{
            loader: 'css-loader'
          }, {
            loader: 'postcss-loader',
            options: {
              plugins: function () {
                return [
                  require('precss'),
                  require('autoprefixer')
                ];
              }
            }
          }, {
            loader: 'sass-loader'
          }]
        })
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?cwd=' + elmSource
      }
    ],
    noParse: [/\.elm$/]
  },

  plugins: [
    new webpack.ProvidePlugin({
      Popper: ['popper.js', 'default']
    }),
    new ExtractTextPlugin('../css/app.css'),
  ]
};
