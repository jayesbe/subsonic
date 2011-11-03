/**
 * Music Brainz Similar Artist\Song Fetcher
 */

 function getMusicBrainz() {
    /**
     * Add css
     */
    $('<link />', {
        'type' : 'text/css',
        'rel' : 'stylesheet',
        'href' : '/script/music_brainz/music_brainz.css'
    }).appendTo('head');
    
    
    /**
     * Escape HTML function
     */
    var escapeHTML = function(str) {
        var div = $('<div style="display:none" />');
        div.text(str);
        var html = div.html();
        div.remove();
        return html;
    };
    
    // Dont do anything if nowPlaying doesnt exist
    //if($('#nowPlaying').length >= 0) {
    var body = $('body');
    if(body.hasClass('rightframe')) {
        rightFrame();
    }
    else if(body.hasClass('playlistframe')) {
        playlistFrame();
    }
    else if(body.hasClass('mainframe')) {
        mainFrame();
    }
    
    
    /**
     * The main frame.
     */
    function mainFrame() {
        
    }
    
    
    /**
     * Playlist (bottom frame)
     */
    function playlistFrame() {
//        //debug.log('Its playlist');
//        var table = $('#playlistBody').parent();
//        var add = $('<button>Add suggested song</button>');
//        //add.insertAfter(table);
//        
//        add.click(function(e) {
//            e.preventDefault();
//            //$.cookie('right', 'hello!');
//        });
    }
    
    
    /**
     * Right sidebar stuff (similar artists widget)
     */
    function rightFrame() {

        /**
         * Get similar artists config
         */
        // Similar artists server
        var url = 'http://moquanc.at.ifi.uio.no/ArtistInfo/jsonp.php';
        
        // How many seconds between each retry
        var retry = 5;
        
        // Limit number of suggested artists
        var limit = 10;

        // If >= 2 different artists or songs, collapse the suggested artists boxes
        // To disable feature, set to a very high value
        var collapseThreshold = 2;

        var playingArtistsCount = 0;
        var playingSongsCount = 0;
        var lastArtists = null;
        var lastSongs = null;
        var attempts = [];

        /**
         * Monitor for artist changes
         */
        setInterval(function() {
            var nowPlayingCount = $('.nowPlayingChip');
            var curArtists = $('.nowPlayingChip #albumArtist');
            var curSongs = $('.nowPlayingChip #songTitle');
            var playingArtists = []; var k = 0;
            var playingSongs = []; var l = 0;
            for(var i = 0; i < nowPlayingCount.length; i++) {
                playingArtists[k++] = $(curArtists[i]).text();
                playingSongs[l++] = $(curSongs[i]).text();
            }
            playingArtists = jQuery.unique(playingArtists);
            playingArtistsCount = playingArtists.length;
            playingSongs = jQuery.unique(playingSongs);
            playingSongsCount = playingSongs.length;
            if(playingArtists.length == 0 && playingSongs.length == 0) return;
            if(lastArtists !== playingArtists.join(',') || lastSongs !== playingSongs.join(',')) {
                //debug.log(playingArtists, playingSongs)
                lastArtists = playingArtists.join(',');
                lastSongs = playingSongs.join(',');
                resetSimilarInfo();
                for(var i = 0; i < nowPlayingCount.length; i++) {
                    var curArtist = playingArtists[i];
                    if(curArtist === '') { continue; }
                    fetchSimilarArtists(curArtist);
                    var curSong = playingSongs[i];
                    if(curSong === '') { continue; }
                    //fetchSimilarSongs(curSong, i);
                    //debug.log('Fetching Music Brainz info for: ' + curArtist + " - " + curSong);
                }
                if(playingArtistsCount >= collapseThreshold) debug.log('Similar artists collapsed: threshold reached.');
                if(playingSongsCount >= collapseThreshold) debug.log('Similar songs collapsed: threshold reached.');
            }
        }, 1000);
        
        /**
         * Get similar artists from server
         */
        var fetchSimilarArtists = function(artist) {
            $.ajax({
                'url' : url,
                'data' : {
                    'name' : artist,
                    'limit' : limit
                },
                'dataType' : 'jsonp',
    //            'jsonp' : 'callback',
                'error' : function(jqXHR, msg) {
                    var tmpArtist = lastArtists;
                    debug.log('Failed to fetch similar artists for: '+artist+' ('+msg+')');
                    debug.log('Retrying in ' + retry + ' sec');
                    setTimeout(function(s) {
                        if(s === lastArtists) {
                            lastArtists = null;
                        }
                        debug.log('Aborting retry, artist changed.');
                    }, retry * 1000, tmpArtist);
                },
                'success' : function(data, status, jqXHR) {
                    if(data.error) {
                        this.error(jqXHR, data.error);
                    }
                    else {
                        //debug.log(data.data);
                        injectSimilarArtists(data.data, data.data.similar);
                    }
                }
            });
        };
        
        /**
         * Get similar songs from server
         */
        var fetchSimilarSongs = function(song) {
            $.ajax({
                'url' : url,
                'data' : {
                    'name' : song,
                    'limit' : limit
                },
                'dataType' : 'jsonp',
    //            'jsonp' : 'callback',
                'error' : function(jqXHR, msg) {
                    var tmpSong = lastSongs;
                    if(debug) { 
                        debug.log('[' + attempts + '] Failed to fetch similar songs for: '+song+' ('+msg+')');
                        debug.log('Retrying in ' + retry + ' sec');
                        attempts++;
                    }
                    setTimeout(function(s) {
                        if(s === lastSongs) {
                            if(attempts >= 5) {
                                attempts = 0;
                                debug.log('Aborting retry after five failed attempts.');
                            } else {
                                lastSongs = null;
                                if(debug) { debug.log('Retrying...'); }
                            }
                        }
                        else if(debug) {
                            debug.log('Aborting retry, song changed.');
                        }
                    }, retry * 1000, tmpSong);
                },
                'success' : function(data, status, jqXHR) {
                    if(data.error) {
                        this.error(jqXHR, data.error);
                    }
                    else {
                        if(debug) { debug.log(data.data); }
                        injectSimilarSongs(data.data, data.data.similar);
                    }
                }
            });
        };
        
        /**
         * Clear the already injected info.
         */
        var resetSimilarInfo = function() {
            if($('#similarArtists').length > 0) {
                $('#similarArtists').remove();
            }

            $('#nowPlaying').after('<div id="similarArtists"><div class="rightframespacebar"></div></div>');

            if($('#similarSongs').length > 0) {
                $('#similarSongs').remove();
            }

            $('#similarArtists').after('<div id="similarSongs"><div class="rightframespacebar"></div></div>');

            if($('#similarArtistsSearch').length == 0) {
                $('#similarArtists').append(
                    '<div style="display:none">'+
                        '<form target="main" action="search.view" method="post">'+
                            '<input type="text" name="query" />'+
                        '</form>'+
                    '</div>'+
                    '<h2 class="head">Artists similar to</h2>');
            }

            /*if($('#similarSongsSearch').length == 0) {
                $('#similarSongs').append(
                    '<div style="display:none">'+
                        '<form target="main" action="search.view" method="post">'+
                            '<input type="text" name="query" />'+
                        '</form>'+
                    '</div>'+
                    '<h2 class="head">Songs similar to</h2>');
            }*/
        };
        
        /**
         * Inject a list with similar artists
         */
        var injectSimilarArtists = function(artist, artists) {
            
            // inject
            var desc = ((artist.type !== 'Unknown') ? '('+artist.type+') ' : '') + artist.disambiguation;
            var section = $(
                '<div class="section">'+
                    '<a class="name" href="http://musicbrainz.org/search/textsearch.html?query='+encodeURIComponent(artist.name)+
                    '&type=artist" target="_blank" title="'+escapeHTML(desc)+'">'+
                    escapeHTML(artist.name)+'</a>'+
                '</div>'
            );
            $('#similarArtists').append(section);
            
            // Open/Close
            var openCloseTrigger = $(
                    '<a href="#" class="openCloseTrigger">'+
                        '<span class="isOpenLabel">&uarr;</span>'+
                        '<span class="isClosedLabel">&darr;</span>'+
                    '</a>');
            openCloseTrigger.data('isOpen', true);
            openCloseTrigger.bind('openList', function(e, animate) {
                var list = $(this).data('list');
                if(animate || animate == undefined) {
                    list.slideDown();
                }
                else {
                    list.show();
                }
                $(this).data('isOpen', true);
                $(this).removeClass('isClosed');
            });
            openCloseTrigger.bind('closeList', function(e, animate) {
                var list = $(this).data('list');
                if(animate || animate == undefined) {
                    list.slideUp();
                }
                else {
                    list.hide();
                }
                $(this).data('isOpen', false);
                $(this).addClass('isClosed');
            });
            openCloseTrigger.click(function(e) {
                e.preventDefault();
                if($(this).data('isOpen')) { $(this).trigger('closeList'); }
                else { $(this).trigger('openList'); }
            });
            section.append(openCloseTrigger);
            
            // Addding similar artists
            var ul = $('<ul class="similar"></ul>');
            section.append(ul);
            openCloseTrigger.data('list', ul);
            
            var similarCount = 0;
            for(var i = 0; i < artists.length; i++) {
                if(jQuery.trim(artists[i]) === '') continue;
                similarCount++;
                var item = $('<li><a href="#">'+artists[i]+'</a></li>');
                item.click(function(e) {
                    e.preventDefault();
                    $('#similarArtists input[type=text]').val($(this).text());
                    $('#similarArtists form').submit();
                });
                ul.append(item);
            }
            
            if(similarCount === 0) {
                ul.after('None');
                ul.remove();
                openCloseTrigger.remove();
            }
            else {
                if(playingArtistsCount >= collapseThreshold) {
                    openCloseTrigger.trigger('closeList', [ false ]);
                }
            }
        };

        /**
         * Inject a list with similar songs
         */
        var injectSimilarSongs = function(song, songs) {

            // inject
            var desc = ((song.type !== 'Unknown') ? '('+song.type+') ' : '') + song.disambiguation;
            var section = $(
                '<div class="section">'+
                    '<a class="name" href="http://musicbrainz.org/search/textsearch.html?query='+encodeURIComponent(song.name)+
                    '&type=recording" target="_blank" title="'+escapeHTML(desc)+'">'+
                    escapeHTML(song.name)+'</a>'+
                '</div>'
            );
            $('#similarSongs').append(section);

            // Open/Close
            var openCloseTrigger = $(
                    '<a href="#" class="openCloseTrigger">'+
                        '<span class="isOpenLabel">&uarr;</span>'+
                        '<span class="isClosedLabel">&darr;</span>'+
                    '</a>');
            openCloseTrigger.data('isOpen', true);
            openCloseTrigger.bind('openList', function(e, animate) {
                var list = $(this).data('list');
                if(animate || animate == undefined) {
                    list.slideDown();
                }
                else {
                    list.show();
                }
                $(this).data('isOpen', true);
                $(this).removeClass('isClosed');
            });
            openCloseTrigger.bind('closeList', function(e, animate) {
                var list = $(this).data('list');
                if(animate || animate == undefined) {
                    list.slideUp();
                }
                else {
                    list.hide();
                }
                $(this).data('isOpen', false);
                $(this).addClass('isClosed');
            });
            openCloseTrigger.click(function(e) {
                e.preventDefault();
                if($(this).data('isOpen')) { $(this).trigger('closeList'); }
                else { $(this).trigger('openList'); }
            });
            section.append(openCloseTrigger);
            
            // Addding similar songs
            var ul = $('<ul class="similar"></ul>');
            section.append(ul);
            openCloseTrigger.data('list', ul);
            
            var similarCount = 0;
            for(var i = 0; i < songs.length; i++) {
                if(jQuery.trim(songs[i]) === '') continue;
                similarCount++;
                var item = $('<li><a href="#">'+songs[i]+'</a></li>');
                item.click(function(e) {
                    e.preventDefault();
                    $('#similarSongs input[type=text]').val($(this).text());
                    $('#similarSongs form').submit();
                });
                ul.append(item);
            }
            
            if(similarCount === 0) {
                ul.after('None');
                ul.remove();
                openCloseTrigger.remove();
            }
            else {
                if(playingSongsCount >= collapseThreshold) {
                    openCloseTrigger.trigger('closeList', [ false ]);
                }
            }
        };
    
    }
}