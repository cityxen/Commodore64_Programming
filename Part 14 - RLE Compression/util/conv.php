<?php

$x=file_get_contents("a.txt");

$ls=explode("\n",$x);
$fo=fopen("a.out","wt");

foreach($ls as $k => $v) {

    $tv=str_split($v,2);
    foreach($tv as $tkk => $tvv) {
        $kr=$tv;
        $tv[$tkk]="$".$tvv.",";
        echo " $kr -> $tvv";
    }
    echo "\n";
    $jv=join($tv);

    fputs($fo,$jv,strlen($jv));
    fputs($fo,"\n",1);

}
fclose($fo);
