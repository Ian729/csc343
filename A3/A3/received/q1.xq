declare variable $dataset0 external;
for $posting in $dataset0/postings/posting
where $posting//reqSkill/@what="SQL" and $posting//reqSkill/@level="5"
return <dbjobs> {$posting} </dbjobs>
