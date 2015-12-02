require 'vnehm/track_manager'

module Vnehm
  class TracksViewCommand < Command

    DEFAULT_LIMIT = 10

    DEFAULT_OFFSET = 0

    def initialize
      super
    end

    def execute
      setup_environment

      old_offset = @offset

      @queue = []
      @track_manager = TrackManager.new(@options)

      tracks = get_tracks
      UI.term 'У Вас ещё нет аудиозаписей' if tracks.nil?

      loop do
        # If offset changed, update list of tracks
        unless old_offset == @offset
          tracks = get_tracks
          old_offset = @offset
        end

        if tracks.nil?
          prev_page
          next
        end

        show_menu(tracks)
      end
    end

    protected

    def get_tracks; end

    def show_menu(tracks)
      UI.menu do |menu|
        menu.header = 'Введите номер аудиозаписи, чтобы добавить её в очередь'.green

        ids = @queue.map(&:id) # Get ids of tracks in queue
        tracks.each do |track|
          track_info = "#{track.full_name} | #{track.duration}"

          if ids.include? track.id
            menu.choice(:added, track_info)
          else
            menu.choice(:inc, track_info) { add_track_to_queue(track) }
          end
        end

        menu.newline

        menu.choice('d', 'Скачать аудиозаписи из очереди'.green.freeze) { download_tracks_from_queue; UI.term }
        menu.choice('n', 'Следующая страница'.magenta.freeze) { next_page }
        menu.choice('p', 'Предыдущая страница'.magenta.freeze) { prev_page }
      end
    end

    def setup_environment
      @limit = @options[:limit] ? @options[:limit].to_i : DEFAULT_LIMIT
      @offset = @options[:offset] ? @options[:offset].to_i : DEFAULT_OFFSET
    end

    def add_track_to_queue(track)
      @queue << track
    end

    def download_tracks_from_queue
      UI.newline
      @track_manager.process_tracks(@queue)
    end

    def next_page
      @offset += @limit
    end

    def prev_page
      @offset -= @limit if @offset >= @limit
    end

  end
end
