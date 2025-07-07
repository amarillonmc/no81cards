--墨染山河 洛神赋图
local s,id,o=GetID()
Duel.LoadScript("c33201381.lua")
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCountLimit(1,id)
	e0:SetLabel(id,id-40)
	e0:SetCost(s.cost)
	e0:SetTarget(VHisc_MRSH.tg)
	e0:SetOperation(VHisc_MRSH.gop)
	c:RegisterEffect(e0)   
end
s.VHisc_MRSH=true
s.VHisc_CNTreasure=true

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.spfilter(c,e,tp)
	return c.VHisc_MRSH and c:IsType(TYPE_PENDULUM) and 
	((c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or 
	(c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)) 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.top(c,e)
	Duel.Hint(HINT_CARD,c:GetPreviousControler(),id-40)
	local tp=c:GetPreviousControler()
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end