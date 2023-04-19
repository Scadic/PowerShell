from Get_Media_Tag import Get_Media_Tag
from sys import argv

if __name__=="__main__":
    if len(argv) >= 2:
        media_tag = Get_Media_Tag(str(argv[1]))
        print(media_tag.get_media_file_name())
    else:
        print("Usage: Get_Media_Tag.py <media_file>\nUsage: python Get_Media_Tag.py <media_file>")