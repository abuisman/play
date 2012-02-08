require 'net/http'
require 'json'

module Play
  class AfplayClient < Client
     
    # Night owl custom posting
    # 
    # Custom posting of our songs.
    def self.updateSite
    
        begin            
            url = URI.parse('http://nightowlinteractive.com/updatemusic.php?key=4FG4SD423MWRP23')

            post_args = {values: Net::HTTP.get_response(URI.parse('http://localhost:5050/api/now_playing')).body}

            resp, data = Net::HTTP.post_form(url, post_args)
        end

       
    end 
      
    # Cause the client to play a song
    #
    # Returns nothing
    def self.play(song_path)
      updateSite
      system("afplay", song_path)
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
      `killall afplay > /dev/null 2>&1`
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
      `ps aux | grep afplay | grep -v grep | wc -l | tr -d ' '`.chomp != '0'
    end

    # Stop the music, and stop the music server.
    #
    # Returns nothing.
    def self.stop
      `killall afplay > /dev/null 2>&1`
      super
    end

    # Say things over the speakers, lol.
    #
    # Returns nothing.
    def self.say(msg)
      return unless msg
      system "say #{msg}"
    end

    # Set the volume level.
    #
    #   number - The Integer volume level. This should be a number between 0
    #            and 100, with "0" being "muted" and "100" being "real real loud"
    #
    # Returns nothing.
    def self.volume=(num)
      system "osascript -e 'set volume output volume #{num}' 2>/dev/null"
    end

    # Get the current volume level.
    #
    # Returns the current volume from 0 to 100
    def self.volume
      vol = `osascript -e 'get output volume of (get volume settings)'`
      vol.to_i
    end
  end
end
