#!/usr/bin/php
<?php
    class Person
    {
        public $string_name;
        public $double_total = 0;
        public $int_num_marks = 0;
        public $int_moul_total = 0;
        public $int_moul_num_marks = 0;

        function __construct($string_name)
        {
            $this->string_name = $string_name;
        }

        function ret_average()
        {
            return ($mark / $int_num_marks);
        }
    }

    function cmp($str1, $str2)
    {
        return (strcmp($str1->string_name, $str2->string_name));
    }

    if ($argc == 2)
    {
        $fd = fopen("php://stdin", "r");
        $line = fgets($fd);
        if ($argv[1] == "average")
        {
            $avg = 0;
            $int_num_marks = 0;
            while (!feof($fd))
            {
                $line = trim(fgets($fd));
                $mark = explode(";", $line);
                if ($mark[2] != "moulinette" && is_numeric($mark[1]))
                {
                    $avg += intval(trim($mark[1]));
                    $int_num_marks++;
                }
            }
            echo $avg / $int_num_marks . "\n";
        }
        else if ($argv[1] == "average_user")
        {
            $people = array();
            while (!feof($fd))
            {
                $line = trim(fgets($fd));
                $mark = explode(";", $line);
                $was_found = false;
                if ($mark[2] != "moulinette" && is_numeric($mark[1]))
                { 
                    foreach ($people as $user)
                    {
                        if ($mark[0] == $user->string_name)
                        {
                            $was_found = true;
                            $user->total += (intval($mark[1]));
                            $user->num_marks++;
                            break;
                        }
                    }
                    if ($was_found == false)
                    {
                        $person = new Person($mark[0]);
                        $person->total += (intval($mark[1]));
                        $person->num_marks++;
                        $people[] = $person;
                    }
                }
            }
            usort($people, "cmp");
            foreach ($people as $user)
            {
                $tot = $user->total / $user->num_marks;
                echo $user->string_name . " " . $tot . "\n";
            }
        }
        else if ($argv[1] == "moulinette_variance")
        {
            $people = array();
            while (!feof($fd))
            {
                $line = trim(fgets($fd));
                $mark = explode(";", $line);
                $was_found = false;
                if (is_numeric($mark[1]))
                { 
                    foreach ($people as $user)
                    {
                        if ($mark[0] == $user->string_name)
                        {
                            $was_found = true;
                            if ($mark[2] == "moulinette")
                            {
                                $user->int_moul_total += (intval($mark[1]));
                                $user->int_moul_num_marks++;
                            }
                            else
                            {
                                $user->total += (intval($mark[1]));
                                $user->num_marks++;
                            }
                            break;
                        }
                    }
                    if ($was_found == false)
                    {
                        $person = new Person($mark[0]);
                        $person->total += (intval($mark[1]));
                        $person->num_marks++;
                        $people[] = $person;
                    }
                }
            }
            usort($people, "cmp");
            foreach ($people as $user)
            {
                $tot = ($user->total / $user->num_marks) - ($user->int_moul_total / $user->int_moul_num_marks);
                echo $user->string_name . " " . $tot . "\n";
            }
        }
    }
?>