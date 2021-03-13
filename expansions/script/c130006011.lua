--瞬杀星 哈维兰
if not pcall(function() require("expansions/script/c130001000") end) then require("script/c130001000") end
local m,cm=rscf.DefineCard(130006011)
function cm.initial_effect(c)
	local e1 = rscf.SetSummonCondition(c,false)
	local e2 = rscf.AddSpecialSummonProcdure(c,LOCATION_HAND,cm.sprcon,nil,cm.sprop)
	local e3 = rsef.FV_LIMIT_PLAYER(c,"sp",nil,cm.tg,{1,0})
end
function cm.tg(e,c)
	return not c:IsType(TYPE_SYNCHRO)
end
function cm.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.sprcon(e,c,tp)
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,0x4011,0,0,2,RACE_WARRIOR,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then return false end
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone = 0
	local zone_list = {}
	for tc in aux.Next(g) do 
		local szone = tc:GetColumnZone(LOCATION_MZONE,tp) & 0x1f
		if szone & 0x60 > 0 then
			szone = szone - (szone & 0x60)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,szone) > 0 then
			zone = zone | szone
			table.insert(zone_list,szone)
		end
	end 
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		return zone > 0 and (Duel.GetLocationCount(tp,LOCATION_MZONE,LOCATION_REASON_TOFIELD,0x1f - zone) > 0 or #zonelist > 1 )
	else
		return zone > 0 and Duel.GetLocationCount(tp,LOCATION_MZONE,LOCATION_REASON_TOFIELD,0x1f - zone) > 0 and zone < 0x1f
	end
end 
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g = Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local zone = 0
	local zone_list = {}
	for tc in aux.Next(g) do 
		local szone = tc:GetColumnZone(LOCATION_MZONE,tp) & 0x1f
		if szone & 0x60 > 0 then
			szone = szone - (szone & 0x60)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,szone) > 0 then
			zone = zone | szone
			table.insert(zone_list,szone)
		end
	end 
	local tk
	local sg = Group.CreateGroup()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then 
		tk = Duel.CreateToken(tp,m+1)
		Duel.SpecialSummonStep(tk,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
		sg:AddCard(tk)
	else
		for i = 1 , #zone_list do 
			tk = Duel.CreateToken(tp,m+1)
			Duel.SpecialSummonStep(tk,0,tp,tp,false,false,POS_FACEUP_ATTACK,zone)
			sg:AddCard(tk)	   
		end
	end
	Duel.SpecialSummonComplete()
	local e1 = rsef.FC({c,tp},EVENT_LEAVE_FIELD,nil,nil,nil,nil,cm.descon,cm.desop)
	sg:KeepAlive()
	e1:SetLabelObject(sg)
end
function cm.clfilter(c,tp,seq)
	return aux.GetColumn(c,tp) == seq
end
function cm.descfilter(c,tp,og)
	return og:IsContains(c) and Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,c:GetPreviousSequence())
end
function cm.descon(e,tp,eg)
	local dg = e:GetLabelObject()
	if dg:FilterCount(Card.IsOnField,nil) == 0 then
		e:Reset()
	end
	return eg:IsExists(cm.descfilter,1,nil,tp,dg)
end
function cm.desop(e,tp,eg)
	local dg = eg:Filter(cm.descfilter,nil,tp,e:GetLabelObject())
	local dg2 = Group.CreateGroup()
	for tc in aux.Next(dg) do
		dg2:Merge(Duel.GetMatchingGroup(cm.clfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,tc:GetPreviousSequence()))
	end
	rshint.Card(m)
	Duel.Destroy(dg2,REASON_RULE)
end