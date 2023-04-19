from datetime import date, datetime

def get_date():
    date_time = datetime.now()
    date_time = date_time.strftime("%d.%m.%Y %H:%M:%S")
    print(date_time)