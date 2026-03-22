--幻叙 furioso
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0,true)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sumcon)
	e1:SetTarget(s.sumtarget)
	e1:SetOperation(s.sumactivate)
	c:RegisterEffect(e1,true)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3,true)
end

function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function s.ffilter(c)
	return c.SetCard_HuanXuGongFang and c:IsAbleToDeckAsCost() and c:IsFaceupEx()
end
function s.sumtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 and Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,9,nil)
	end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,9,9,nil)
	Duel.HintSelection(g1)
	Duel.SendtoDeck(g1,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.sumactivate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)==0 then return end
	e:GetHandler():ResetFlagEffect(id)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end