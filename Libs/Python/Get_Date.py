from datetime import date, datetime

if __name__ == "__main__":
    date_time = datetime.now()
    date_time = date_time.strftime("%d.%m.%Y %H:%M:%S")
    print(date_time)