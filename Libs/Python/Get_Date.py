<<<<<<< HEAD
from Get_Date import get_date

if __name__ == "__main__":
    get_date()
=======
from datetime import date, datetime

if __name__ == "__main__":
    date_time = datetime.now()
    date_time = date_time.strftime("%d.%m.%Y %H:%M:%S")
    print(date_time)
>>>>>>> 460f66ae2a0cf711a1a2db2a8e5f678e67ab4845
