require 'net/http'
require 'json'

module Play
  class Mpg123Client < Client
    # Night owl custom posting
    # 
    # Custom posting of our songs.
    def self.updateSite
      begin
        if(Play.now_playing)
          post_args = {
            'values' => music_response(Play.now_playing),
            'key' => "4FG4SD423MWRP23"
          }   
          uri = URI.parse('http://nightowlinteractive.com/updatemusic.php')
          resp = Net::HTTP.post_form(uri,post_args)
        end
      end
    end 

    # Cause the client to play a song
    #
    # Returns nothing
    def self.play(song_path)
      updateSite()
      system("mpg123", song_path)
    end

    # The temp file we use to signify whether Play should be paused.
    #
    # Returns the String path of the pause file.
    def self.pause_path
      '/tmp/play_is_paused'
    end

    # "Pauses" a client by stopping currently playing songs and setting up the
    # pause temp file.
    #
    # Returns nothing.
    def self.pause
      paused? ? `rm -f #{pause_path}` : `touch #{pause_path}`
      `killall mpg123 > /dev/null 2>&1`
    end

    # Are we currently paused?
    #
    # Returns the Boolean value of whether we're paused.
    def self.paused?
      File.exist?(pause_path)
    end

    # Are we currently playing? Look at the process list and check it out.
    #
    # Returns true if we're playing, false if we aren't.
    def self.playing?
      `ps aux | grep mpg123 | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `killall mpg123 > /dev/null 2>&1`
      super
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
      return unless msg
      system("echo '#{msg}' | festival --tts")
    end

    # Set the volume level of the client.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 100, with "0" being "muted" and "100" being "real real loud"
    #
    # Returns nothing.
    def self.volume=(volume)
      system "amixer set Master #{volume}% > /dev/null 2>&1"
    end

    # Get the current volume level
    #
    # Returns the current volume from 0 to 100
    def self.volume
      vol = `amixer get Master`.scan(/([0-9]+)%/).first.last
      vol.to_i
    end

    def music_response(song)
      {
        'artist_name'         => song.artist_name,
        'song_title'          => song.title,
        'album_name'          => song.album_name,
        'last_played_at'      => song.last_played_at,
        'song_download_path'  => "/song/#{song.id}/download",
        'album_download_path' => "/album/#{song.album_id}/download",
        'alumb_art_url'       => song.album.art_url
      }.to_json
    end

  end
end
