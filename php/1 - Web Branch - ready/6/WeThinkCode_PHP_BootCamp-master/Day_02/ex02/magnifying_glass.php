#!/usr/bin/php
<?PHP
if (is_readable($argv[1]))
{
    #global variables
    $result = array();
    $file_content = file_get_contents($argv[1]);
    $file_content_length = strlen($file_content);
    $count_index = 0;


    # functions to go through the document
    function in_doc()
    {
        global $file_content_length, $count_index;
        return ($count_index < $file_content_length);
    }

    function get_current()
    {
        global $file_content, $count_index;
        return substr($file_content, $count_index, 1);
    }

    function compare_current($compare_to)
    {
        global $count_index, $file_content, $file_content_length;
        $length = strlen($compare_to);
        if ($count_index + $length > $file_content_length)
            return false;
        return strcasecmp(substr($file_content, $count_index, $length), substr($compare_to, 0, $length)) == 0;
    }

    function increment_count_index($number = 1)
    {
        global $result, $count_index;
        while ($number != 0)
        {
            array_push($result, get_current());
            $count_index += 1;
            $number -=1;
        }
    }

    function toupper_incr_count()
    {
        global $result, $count_index;
        array_push($result, strtoupper(get_current()));
        $count_index += 1;
    }

    # logic functions to
    function decision_factor()
    {
        read_inside_tag();
        while (compare_current("</a>") == false && in_doc())
        {
            if (compare_current("<"))
                read_inside_tag();
      			else
      				toupper_incr_count();
        }
        increment_count_index(4);
    }

    function read_inside_tag()
    {
        while (get_current() !== ">" && in_doc())
        {
            if (compare_current("title=\"") == true)
            {
                increment_count_index(7);
                while (get_current() !== "\"")
                    toupper_incr_count();
            }
            increment_count_index();
        }
        increment_count_index();
    }

    while ($count_index < $file_content_length)
    {
        if (compare_current("<a ") || compare_current("<a>"))
        {
            increment_count_index(2);
            decision_factor();
        }
        increment_count_index(1);
    }

    $final_html = implode("", $result);

    echo "$final_html";
}
?>
