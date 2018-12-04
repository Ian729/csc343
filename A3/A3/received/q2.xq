declare variable $dataset0 external;
let $pdoc := $dataset0

(: find the max value across all posting skills :)
let $maxValue := max(
  for $posting in $pdoc/postings/posting
  let $value := $posting/reqSkill/(@level * @importance)
  return $value)

(: select postings which have one or more skill of the highest value :)
let $allPostings :=
(for $posting in $pdoc/postings/posting
where $posting/reqSkill/(@level * @importance) = $maxValue
return $posting)

(: select all dictinct values from the postings with skill of highest value :)
let $distinct :=
fn:distinct-values( $allPostings )

(: get rid of duplicates :)
let $answer :=
(for $posting in $pdoc/postings/posting
where fn:index-of($distinct, data($posting)) > 0
return $posting)

return <important> {$answer} </important>
