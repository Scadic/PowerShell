from tinytag import TinyTag

def __format_time__(duration=0):
    return int(duration)

def __extract_track_number__(track=""):
    try:
        int(track)
        return int(track)
    except:
        #print(f"Error. Not a number: {track}")
        return 0

def __get_media_info__(file_path=""):
    if file_path=="":
        return {}
    tag = TinyTag.get(file_path)
    return {
        "duration": __format_time__(tag.duration),
        "artist": tag.artist,
        "title": tag.title,
        "track": __extract_track_number__(tag.track)
    }

class Get_Media_Tag():
    def __init__(self, file_path=""):
        self.file_path = file_path
        self.info = __get_media_info__(self.file_path)

    def get_extinf(self):
        return f"{self.info['duration']},{self.info['artist']} - {self.info['title']}"

    def get_media_file_name(self):
        return f"{self.info['track']:02} - {self.info['title']}"