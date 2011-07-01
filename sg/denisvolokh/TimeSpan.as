package sg.denisvolokh
{
    import mx.utils.StringUtil;

    public class TimeSpan
    {
        private var _totalMilliseconds:Number;

        public function TimeSpan(milliseconds:Number)
        {
            _totalMilliseconds = Math.floor(milliseconds);
        }

        private static var less_than_X_seconds_ago:String = "less than {0} seconds ago";

        private static var less_than_X_minutes_ago:String = "less than {0} minutes ago";

        private static var about_X_hours_ago:String = "about {0} hours ago";

        /**
         * Gets two dates to calculate distance
         *
         * @example TimeSpan.distance_of_time_in_words(new Date(), new Date()) will return phase "few minutes ago"
         *
         * @param from_date
         * @param to_date
         *
         * @return Returns the approximate distance of time in words
         */

        public static function distance_of_time_in_words(from_date:Date, to_date:Date, include_seconds:Boolean = false):String
        {
            var TimeSpan:TimeSpan = TimeSpan.fromDates(from_date, to_date);

            if (TimeSpan.totalMinutes <= 0)
            {
                if (include_seconds)
                {
                    if (TimeSpan.totalSeconds == 0)
                    {
                        return 'just happened'
                    }

                    if (TimeSpan.totalSeconds > 0 && TimeSpan.totalSeconds <= 4)
                    {
                        return StringUtil.substitute(less_than_X_seconds_ago, [ 5 ]);
                    }

                    if (TimeSpan.totalSeconds > 5 && TimeSpan.totalSeconds <= 9)
                    {
                        return StringUtil.substitute(less_than_X_seconds_ago, [ 10 ]);
                    }

                    if (TimeSpan.totalSeconds > 11 && TimeSpan.totalSeconds <= 19)
                    {
                        return StringUtil.substitute(less_than_X_seconds_ago, [ 20 ]);
                    }

                    if (TimeSpan.totalSeconds > 30 && TimeSpan.totalSeconds <= 59)
                    {
                        return "less than a minute ago";
                    }
                }
                else
                {
                    return "few minutes ago";
                }
            }

            if (TimeSpan.totalMinutes > 1 && TimeSpan.totalMinutes <= 10)
            {
                return StringUtil.substitute(less_than_X_minutes_ago, [ 10 ]);
            }

            if (TimeSpan.totalMinutes > 10 && TimeSpan.totalMinutes <= 20)
            {
                return StringUtil.substitute(less_than_X_minutes_ago, [ 20 ]);
            }

            if (TimeSpan.totalMinutes > 20 && TimeSpan.totalMinutes <= 30)
            {
                return "about half an hour ago";
            }

            if (TimeSpan.totalMinutes > 30 && TimeSpan.totalMinutes <= 45)
            {
                return "more than half an hour ago";
            }

            if (TimeSpan.totalMinutes > 45 && TimeSpan.totalMinutes <= 60)
            {
                return "about hour ago";
            }

            if (TimeSpan.totalMinutes > 90 && TimeSpan.totalMinutes <= 1439)
            {
                return StringUtil.substitute(about_X_hours_ago, [ int(TimeSpan.totalMinutes / 60)]);
            }

            if (TimeSpan.totalMinutes > 1440 && TimeSpan.totalMinutes <= 2879)
            {
                return "1 day ago";
            }

            if (TimeSpan.totalMinutes > 2880 && TimeSpan.totalMinutes <= 43199)
            {
                return StringUtil.substitute("{0} days", [ int(TimeSpan.totalMinutes / 1440)]) + " ago";
            }

            if (TimeSpan.totalMinutes > 43200 && TimeSpan.totalMinutes <= 86399)
            {
                return "about 1 month ago";
            }

            if (TimeSpan.totalMinutes > 86400 && TimeSpan.totalMinutes <= 525599)
            {
                return StringUtil.substitute("about {0} months", [ int(TimeSpan.totalMinutes / 43200)]) + " ago";
            }

            if (TimeSpan.totalMinutes > 525600 && TimeSpan.totalMinutes <= 1051199)
            {
                return "about 1 year ago";
            }

            if (TimeSpan.totalMinutes > 1051200)
            {
                return "long long time ago";
            }

            return 'some time ago';
        }

        /**
         * Gets the number of whole days
         *
         * @example In a TimeSpan created from TimeSpan.fromHours(25),
         *                      totalHours will be 1.04, but hours will be 1
         * @return A number representing the number of whole days in the TimeSpan
         */
        public function get days():int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_DAY);
        }

        /**
         * Gets the number of whole hours (excluding entire days)
         *
         * @example In a TimeSpan created from TimeSpan.fromMinutes(1500),
         *                      totalHours will be 25, but hours will be 1
         * @return A number representing the number of whole hours in the TimeSpan
         */
        public function get hours():int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_HOUR) % 24;
        }

        /**
         * Gets the number of whole minutes (excluding entire hours)
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(65500),
         *                      totalSeconds will be 65.5, but seconds will be 5
         * @return A number representing the number of whole minutes in the TimeSpan
         */
        public function get minutes():int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_MINUTE) % 60;
        }

        /**
         * Gets the number of whole seconds (excluding entire minutes)
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(65500),
         *                      totalSeconds will be 65.5, but seconds will be 5
         * @return A number representing the number of whole seconds in the TimeSpan
         */
        public function get seconds():int
        {
            return int(_totalMilliseconds / MILLISECONDS_IN_SECOND) % 60;
        }

        /**
         * Gets the number of whole milliseconds (excluding entire seconds)
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(2123),
         *                      totalMilliseconds will be 2001, but milliseconds will be 123
         * @return A number representing the number of whole milliseconds in the TimeSpan
         */
        public function get milliseconds():int
        {
            return int(_totalMilliseconds) % 1000;
        }

        /**
         * Gets the total number of days.
         *
         * @example In a TimeSpan created from TimeSpan.fromHours(25),
         *                      totalHours will be 1.04, but hours will be 1
         * @return A number representing the total number of days in the TimeSpan
         */
        public function get totalDays():Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_DAY;
        }

        /**
         * Gets the total number of hours.
         *
         * @example In a TimeSpan created from TimeSpan.fromMinutes(1500),
         *                      totalHours will be 25, but hours will be 1
         * @return A number representing the total number of hours in the TimeSpan
         */
        public function get totalHours():Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_HOUR;
        }

        /**
         * Gets the total number of minutes.
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(65500),
         *                      totalSeconds will be 65.5, but seconds will be 5
         * @return A number representing the total number of minutes in the TimeSpan
         */
        public function get totalMinutes():Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_MINUTE;
        }

        /**
         * Gets the total number of seconds.
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(65500),
         *                      totalSeconds will be 65.5, but seconds will be 5
         * @return A number representing the total number of seconds in the TimeSpan
         */
        public function get totalSeconds():Number
        {
            return _totalMilliseconds / MILLISECONDS_IN_SECOND;
        }

        /**
         * Gets the total number of milliseconds.
         *
         * @example In a TimeSpan created from TimeSpan.fromMilliseconds(2123),
         *                      totalMilliseconds will be 2001, but milliseconds will be 123
         * @return A number representing the total number of milliseconds in the TimeSpan
         */
        public function get totalMilliseconds():Number
        {
            return _totalMilliseconds;
        }

        /**
         * Adds the TimeSpan represented by this instance to the date provided and returns a new date object.
         * @param date The date to add the TimeSpan to
         * @return A new Date with the offseted time
         */
        public function add(date:Date):Date
        {
            var ret:Date = new Date(date.time);
            ret.milliseconds += totalMilliseconds;

            return ret;
        }

        /**
         * Creates a TimeSpan from the different between two dates
         *
         * Note that start can be after end, but it will result in negative values.
         *
         * @param start The start date of the TimeSpan
         * @param end The end date of the TimeSpan
         * @return A TimeSpan that represents the difference between the dates
         *
         */
        public static function fromDates(start:Date, end:Date):TimeSpan
        {
            return new TimeSpan(end.time - start.time);
        }

        /**
         * Creates a TimeSpan from the specified number of milliseconds
         * @param milliseconds The number of milliseconds in the TimeSpan
         * @return A TimeSpan that represents the specified value
         */
        public static function fromMilliseconds(milliseconds:Number):TimeSpan
        {
            return new TimeSpan(milliseconds);
        }

        /**
         * Creates a TimeSpan from the specified number of seconds
         * @param seconds The number of seconds in the TimeSpan
         * @return A TimeSpan that represents the specified value
         */
        public static function fromSeconds(seconds:Number):TimeSpan
        {
            return new TimeSpan(seconds * MILLISECONDS_IN_SECOND);
        }

        /**
         * Creates a TimeSpan from the specified number of minutes
         * @param minutes The number of minutes in the TimeSpan
         * @return A TimeSpan that represents the specified value
         */
        public static function fromMinutes(minutes:Number):TimeSpan
        {
            return new TimeSpan(minutes * MILLISECONDS_IN_MINUTE);
        }

        /**
         * Creates a TimeSpan from the specified number of hours
         * @param hours The number of hours in the TimeSpan
         * @return A TimeSpan that represents the specified value
         */
        public static function fromHours(hours:Number):TimeSpan
        {
            return new TimeSpan(hours * MILLISECONDS_IN_HOUR);
        }

        /**
         * Creates a TimeSpan from the specified number of days
         * @param days The number of days in the TimeSpan
         * @return A TimeSpan that represents the specified value
         */
        public static function fromDays(days:Number):TimeSpan
        {
            return new TimeSpan(days * MILLISECONDS_IN_DAY);
        }

        /**
         * The number of milliseconds in one day
         */
        public static const MILLISECONDS_IN_DAY:Number = 86400000;

        /**
         * The number of milliseconds in one hour
         */
        public static const MILLISECONDS_IN_HOUR:Number = 3600000;

        /**
         * The number of milliseconds in one minute
         */
        public static const MILLISECONDS_IN_MINUTE:Number = 60000;

        /**
         * The number of milliseconds in one second
         */
        public static const MILLISECONDS_IN_SECOND:Number = 1000;
    }
}