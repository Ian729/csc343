let $d := doc("quiz.xml")
for $s in $d//student
	where every $res in $s/response
	satisfies $res/@qid=$d//questions/*/@qid and $res/@answer=$d//questions/*[@qid=$res/@qid]/@solution
return $s/@sid