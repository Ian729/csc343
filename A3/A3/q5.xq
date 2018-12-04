<histogram>{
let $p := fn:doc("posting.xml")
let $r := fn:doc("resume.xml")
let $skills := fn:distinct-values($p/postings/posting/reqSkill/@what)
let $resumes := $r/resumes/resume
let $levels := (1,2,3,4,5)
for $skill in $skills
for $level in $levels
let $num := count(
for $resume in $resumes
return (
if ($skill = $resume/resume/skills/skill and
$level = $resume/resume/skills/skill/@level)
then $resume
else()
)
)
return
<skill name='{data($skill)}'>
<count level='{data($level)}' n='{data($num)}'/>
</skill>
}
</histogram>
