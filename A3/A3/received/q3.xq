(: import the documents :)
declare variable $dataset0 external;
let $rdoc := $dataset0

(: select attributes and element to match the target DTD :)
let $answer :=
for $resume in $rdoc/resumes/resume
where count($resume/skills/skill) > 3
return <candidate
          rid = '{data($resume//@rID)}'
          numskills = '{count($resume/skills/skill)}'
          citizenzhip = '{data($resume//citizenship)}'>
            <name> {data($resume//forename)} </name>
            </candidate>
return <qualified>{$answer}</qualified>
