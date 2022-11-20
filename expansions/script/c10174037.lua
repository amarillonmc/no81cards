--巨怪虫
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(10174037)
function cm.initial_effect(c)
	local e1=rsef.QO(c,nil,{m,0},nil,"sp",nil,LOCATION_HAND+LOCATION_GRAVE,nil,aux.AND(rscost.cost(cm.cfilter,"rm",LOCATION_GRAVE,0,3,3,c),rscost.regflag()),rsop.target(rscf.spfilter2(),"sp"),cm.spop)
	local e2=rsef.QO(c,nil,{m,2},{1,0x1},"sp,tk",nil,LOCATION_MZONE,rscon.phbp,nil,cm.tktg,cm.tkop)
	local e3=rsef.QO(c,nil,{m,3},{1,0x1},"des",nil,LOCATION_MZONE,rscon.phbp,nil,rsop.target(aux.TRUE,"des",LOCATION_ONFIELD,LOCATION_ONFIELD,1,cm.ctfun),cm.desop) 
end
function cm.cfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToRemoveAsCost()
end
function cm.spop(e,tp)
	local c=aux.ExceptThisCard(e)
	if c then rssf.SpecialSummon(c) end
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,10174038,0,0x4011,2000,2000,8,RACE_REPTILE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,10174038,0,0x4011,2000,2000,8,RACE_REPTILE,ATTRIBUTE_EARTH) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)+1
	local sct=math.min(ft,ct)
	if sct<=0 then return end
	sct=Duel.IsPlayerAffectedByEffect(tp,59822133) and 1 or sct
	local list={}
	for i=1,sct do
		table.insert(list,i)
	end
	sct=Duel.AnnounceNumber(tp,table.unpack(list))
	local bool=false
	for i=1,sct do
		local token=Duel.CreateToken(tp,10174038)
		bool=bool or Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
	end
	if bool then
		Duel.SpecialSummonComplete()
	end
end
function cm.repfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE)
end
function cm.ctfun(e,tp)
	return Duel.GetMatchingGroupCount(cm.repfilter,tp,LOCATION_MZONE,0,nil)
end
function cm.desop(e,tp)
	local ct=cm.ctfun(e,tp)
	if ct<=0 or not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end
	rshint.Select(tp,"des")
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	rsop.Destroy(g)
end
