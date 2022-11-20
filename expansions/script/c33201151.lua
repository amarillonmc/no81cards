--寂海的住民 唤雨人鱼
local s,id,o=GetID()
Duel.LoadScript("c33201150.lua")
function s.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetLabelObject(e1)
	e2:SetLabel(id)
	e2:SetCondition(Mermaid_VHisc.effcon)
	e2:SetOperation(Mermaid_VHisc.effop)
	c:RegisterEffect(e2)
end
s.VHisc_Mermaid=true

--e1
function s.smfilter(c,e,tp)
	return c.VHisc_Mermaid and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Mermaid_VHisc.fgck(e:GetHandler(),id) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(s.smfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Mermaid_VHisc.flagc(e:GetHandler(),id)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsRelateToEffect(e) and Duel.IsExistingMatchingCard(s.smfilter,tp,LOCATION_HAND,0,1,nil,e,tp) then 
		Mermaid_VHisc.sp(e:GetHandler(),tp)
		if e:GetHandler():IsLocation(LOCATION_SZONE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.smfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

