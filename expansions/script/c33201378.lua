--唤祐重器 鹿角立鹤
local s,id,o=GetID()
Duel.LoadScript("c33201370.lua")
Duel.LoadScript("c33201350.lua")
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.VHisc_HYZQ=true
s.VHisc_CNTreasure=true

function s.filter(c)
	return VHisc_CNTdb.nck(c) and c:IsAbleToDeck()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil):GetCount()>1 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tg=g:Select(tp,1,5,nil)
		local tdc=Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		if tdc>=1 then 
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetTargetRange(LOCATION_MZONE,0)
			e1:SetValue(tdc*200)
			e1:SetReset(RESET_PHASE+PHASE_END,2)
			Duel.RegisterEffect(e1,tp)
		end
		if tdc>=3 and VHisc_HYZQ.mck(tp,id) then 
			VHisc_HYZQ.mop(e,tp,id)
		end
		if tdc>=5 and Duel.GetMatchingGroup(s.thft,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then 
			local thg=Duel.GetMatchingGroup(s.thft,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=thg:Select(tp,1,2,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
		end
	end
end
function s.thft(c)
	return c:IsAbleToHand()
end