--晶忆梦现
if not c71401001 then dofile("expansions/script/c71401001.lua") end
---@param c Card
function c71402005.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71402005,0))
	e1:SetCountLimit(1,71402005)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c71402005.con)
	e1:SetCost(yume.ButterflyLimitCost)
	e1:SetTarget(c71402005.tg)
	e1:SetOperation(c71402005.op)
	c:RegisterEffect(e1)
	yume.ButterflyCounter()
end
function c71402005.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD+LOCATION_HAND)
end
function c71402005.spfilter(c,e,tp)
	return c:IsRace(RACE_SPELLCASTER) and c:IsFaceupEx()
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c71402005.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c71402005.exfilter,tp,LOCATION_EXTRA,0,1,nil,g)
end
function c71402005.exfilter(c,g)
	local ct=g:GetCount()
	return c:IsRace(RACE_SPELLCASTER) and (c:IsLinkSummonable(g,nil,ct,ct) or 
		c:IsSynchroSummonable(nil,g,ct,ct) or c:IsXyzSummonable(g,ct,ct))
end
function c71402005.chkfilter(c,tp)
	return c:IsRace(RACE_SPELLCASTER) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c71402005.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return false end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return false end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local cg=Duel.GetMatchingGroup(c71402005.chkfilter,tp,LOCATION_EXTRA,0,nil,tp)
		if #cg==0 then return false end
		local g=Duel.GetMatchingGroup(c71402005.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		return g:CheckSubGroup(c71402005.fselect,1,ft,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c71402005.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c71402005.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectSubGroup(tp,c71402005.fselect,false,1,ft,tp)
		if not sg then return end
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local og=Duel.GetOperatedGroup()
		Duel.AdjustAll()
		if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)<sg:GetCount() then return end
		local tg=Duel.GetMatchingGroup(c71402005.exfilter,tp,LOCATION_EXTRA,0,nil,og)
		if og:GetCount()==sg:GetCount() and tg:GetCount()>0 then
			Duel.BreakEffect()
			local ct=#og
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local exc=tg:Select(tp,1,1,nil):GetFirst()
			if exc:IsType(TYPE_SYNCHRO) then
				Duel.SynchroSummon(tp,exc,nil,og,ct,ct)
			elseif exc:IsType(TYPE_XYZ) then
				Duel.XyzSummon(tp,exc,og,ct,ct)
			elseif exc:IsType(TYPE_LINK) then
				Duel.LinkSummon(tp,exc,og,nil,ct,ct)
			end
		end
	end
end