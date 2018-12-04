declare variable $dataset0 external;
declare variable $dataset1 external;
let $i := $dataset0
let $r := $dataset1

let $allHaha :=
  for $interview in $i/interviews/interview
    let $pid := $interview/@pID
    let $highest := ($interview/assessment/communication,
    $interview/assessment/enthusiasm,
    $interview/assessment/collegiality)
    let $value := max($highest)
    let $skill := (
        for $skill in $i/interviews/interview/assessment
        return
        (
          if ($skill/communication=$value)
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

    let $rID := $interview//@rID
    let $name := $r/resumes/resume[@rID = $rID]//forename

    return
    <best resume='{$name}' position='{$pid}'>{$skill}</best>

return <bestskills> {$allHaha} </bestskills>
