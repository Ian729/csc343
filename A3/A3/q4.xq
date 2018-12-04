let $i := fn:doc("interview.xml")
let $r := fn:doc("resume.xml")
for $interview in $i/interviews/interview
let $pid := $interview/@pID
let $highest := ($interview/assessment/communication,
$interview/assessment/enthusiasm,
$interview/assessment/collegiality)
let $value := max($highest)
let $skill := (
    for $skill in $i/interviews/interview/assessment
    return
    (if ($skill/communication=$value)
        then let $a := $skill/communication
        return $a
            else (
                if ($skill/enthusiasm=$value)
                then let $b := $skill/enthusiasm
                return $b
                else(
                    if ($skill/collegiality=$value)
                    then let $c := $skill/collegiality
                    return $c
                    else()
                )
            )
    )
)

let $rID := $interview/@rID
let $resume := (
    for $resume in $r/resumes/resume
    return
    if ($resume/@rID=$rID)
    then $resume/identification/name/forename
    else()

)

return
<best resume='{data($resume)}' position='{$pid}'>{$skill}</best>
