using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using NLog;
using NzbDrone.Common.EnsureThat;
using NzbDrone.Common.Extensions;
using NzbDrone.Core.DataAugmentation.Scene;
using NzbDrone.Core.Messaging.Events;
using NzbDrone.Core.Organizer;
using NzbDrone.Core.Parser;
using NzbDrone.Core.Tv.Events;
using NzbDrone.Core.Models;

namespace NzbDrone.Core.Tv
{
    public interface ISeriesService
    {
        Book GetSeries(int seriesId);
        List<Book> GetSeries(IEnumerable<int> seriesIds);
        Book AddSeries(Book newSeries);
        Book FindByTvdbId(int tvdbId);
        Book FindByTvRageId(int tvRageId);
        Book FindByTitle(string title);
        Book FindByTitle(string title, int year);
        Book FindByTitleInexact(string title);
        void DeleteSeries(int seriesId, bool deleteFiles);
        List<Book> GetAllBooks();
        Book UpdateSeries(Book series, bool updateEpisodesToMatchSeason = true);
        List<Book> UpdateSeries(List<Book> series);
        bool SeriesPathExists(string folder);
        void RemoveAddOptions(Book series);
    }

    public class SeriesService : ISeriesService
    {
        private readonly ISeriesRepository _seriesRepository;
        private readonly IEventAggregator _eventAggregator;
        private readonly IEpisodeService _episodeService;
        private readonly IBuildFileNames _fileNameBuilder;
        private readonly Logger _logger;

        public SeriesService(ISeriesRepository seriesRepository,
                             IEventAggregator eventAggregator,
                             IEpisodeService episodeService,
                             IBuildFileNames fileNameBuilder,
                             Logger logger)
        {
            _seriesRepository = seriesRepository;
            _eventAggregator = eventAggregator;
            _episodeService = episodeService;
            _fileNameBuilder = fileNameBuilder;
            _logger = logger;
        }

        public Book GetSeries(int seriesId)
        {
            return _seriesRepository.Get(seriesId);
        }

        public List<Book> GetSeries(IEnumerable<int> seriesIds)
        {
            return _seriesRepository.Get(seriesIds).ToList();
        }

        public Book AddSeries(Book newSeries)
        {
            _seriesRepository.Insert(newSeries);
            //_eventAggregator.PublishEvent(new SeriesAddedEvent(GetSeries(newSeries.Id)));

            return newSeries;
        }

        public Book FindByTvdbId(int tvRageId)
        {
            return null;
            //return _seriesRepository.FindByTvdbId(tvRageId);
        }

        public Book FindByTvRageId(int tvRageId)
        {
            return null;
            //return _seriesRepository.FindByTvRageId(tvRageId);
        }

        public Book FindByTitle(string title)
        {
            return _seriesRepository.FindByTitle(title);
        }

        public Book FindByTitleInexact(string title)
        {
            //// find any series clean title within the provided release title
            //string cleanTitle = title.CleanSeriesTitle();
            //var list = _seriesRepository.All().Where(s => cleanTitle.Contains(s.CleanTitle)).ToList();
            //if (!list.Any())
            //{
            //    // no series matched
            //    return null;
            //}
            //if (list.Count == 1)
            //{
            //    // return the first series if there is only one
            //    return list.Single();
            //}
            //// build ordered list of series by position in the search string
            //var query =
            //    list.Select(series => new
            //    {
            //        position = cleanTitle.IndexOf(series.CleanTitle),
            //        length = series.CleanTitle.Length,
            //        series = series
            //    })
            //        .Where(s => (s.position>=0))
            //        .ToList()
            //        .OrderBy(s => s.position)
            //        .ThenByDescending(s => s.length)
            //        .ToList();

            //// get the leftmost series that is the longest
            //// series are usually the first thing in release title, so we select the leftmost and longest match
            //var match = query.First().series;

            //_logger.Debug("Multiple series matched {0} from title {1}", match.Title, title);
            //foreach (var entry in list)
            //{
            //    _logger.Debug("Multiple series match candidate: {0} cleantitle: {1}", entry.Title, entry.CleanTitle);
            //}

            //return match;
            return null;
        }

        public Book FindByTitle(string title, int year)
        {
            return _seriesRepository.FindByTitle(title.CleanSeriesTitle(), year);
        }

        public void DeleteSeries(int seriesId, bool deleteFiles)
        {
            var series = _seriesRepository.Get(seriesId);
            _seriesRepository.Delete(seriesId);
            //_eventAggregator.PublishEvent(new SeriesDeletedEvent(series, deleteFiles));
        }

        public List<Book> GetAllBooks()
        {
            return _seriesRepository.All().ToList();
        }

        // updateEpisodesToMatchSeason is an override for EpisodeMonitoredService to use so a change via Season pass doesn't get nuked by the seasons loop.
        // TODO: Remove when seasons are split from series (or we come up with a better way to address this)
        public Book UpdateSeries(Book series, bool updateEpisodesToMatchSeason = true)
        {
            var storedSeries = GetSeries(series.Id);

            //foreach (var season in series.Seasons)
            //{
            //    var storedSeason = storedSeries.Seasons.SingleOrDefault(s => s.SeasonNumber == season.SeasonNumber);

            //    if (storedSeason != null && season.Monitored != storedSeason.Monitored && updateEpisodesToMatchSeason)
            //    {
            //        _episodeService.SetEpisodeMonitoredBySeason(series.Id, season.SeasonNumber, season.Monitored);
            //    }
            //}

            var updatedSeries = _seriesRepository.Update(series);
            //_eventAggregator.PublishEvent(new SeriesEditedEvent(updatedSeries, storedSeries));

            return updatedSeries;
        }

        public List<Book> UpdateSeries(List<Book> series)
        {
            //_logger.Debug("Updating {0} series", series.Count);
            //foreach (var s in series)
            //{
            //    _logger.Trace("Updating: {0}", s.Title);
            //    if (!s.RootFolderPath.IsNullOrWhiteSpace())
            //    {
            //        var folderName = new DirectoryInfo(s.Path).Name;
            //        s.Path = Path.Combine(s.RootFolderPath, folderName);
            //        _logger.Trace("Changing path for {0} to {1}", s.Title, s.Path);
            //    }

            //    else
            //    {
            //        _logger.Trace("Not changing path for: {0}", s.Title);
            //    }
            //}

            _seriesRepository.UpdateMany(series);
            _logger.Debug("{0} series updated", series.Count);

            return series;
        }

        public bool SeriesPathExists(string folder)
        {
            return _seriesRepository.SeriesPathExists(folder);
        }

        public void RemoveAddOptions(Book series)
        {
            //_seriesRepository.SetFields(series, s => s.AddOptions);
        }
    }
}
