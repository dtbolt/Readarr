var Handlebars = require('handlebars');
var StatusModel = require('../../System/StatusModel');
var _ = require('underscore');

Handlebars.registerHelper('route', function() {
    return StatusModel.get('urlBase') + '/series/' + this.titleSlug;
});

Handlebars.registerHelper('percentOfEpisodes', function() {
    var episodeCount = this.episodeCount;
    var episodeFileCount = this.episodeFileCount;

    var percent = 100;

    if (episodeCount > 0) {
        percent = episodeFileCount / episodeCount * 100;
    }

    return percent;
});