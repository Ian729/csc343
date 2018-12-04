let $d := doc("quiz.xml")
for $x in $d//mc-question
where $x/count(option)=max($d//mc-question/count(option))
return $x/question
