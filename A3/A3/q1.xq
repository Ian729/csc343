<dbjobs>
{for $posting in fn:doc("posting.xml")/postings/posting
where $posting//reqSkill/@what="SQL" and $posting//reqSkill/@level="5"
return ($posting)}
</dbjobs>
