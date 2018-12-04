declare variable $dataset0 external;
declare variable $dataset1 external;
let $p := $dataset0
let $r := $dataset1
let $skills := fn:distinct-values($p/postings/posting/reqSkill/@what)
let $resumes := $r/resumes/resume

return
<histogram>{
for $skill in $skills
  let $allLevel :=
  for $level in 1 to 5
    let $num := count(
      $resumes//skill[@what = $skill and @level = $level])
  return <count level= "{$level}" n="{$num}"/>
return
<skill name='{$skill}'>
 {$allLevel}
</skill>
}</histogram>
