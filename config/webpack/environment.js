const { environment } = require('@rails/webpacker')

const webpack = require("webpack");

// Add an additional plugin of your choosing : ProvidePlugin
environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    Popper: ['popper.js', 'default'] // for Bootstrap 4
  })
);

module.exports = environment
