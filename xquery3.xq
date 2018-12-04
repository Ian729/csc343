<answered>
{let $d := doc("quiz.xml")
for $x in $d//questions/*
where $x/@qid = $d//response/@qid
return $x/question
}</answered>