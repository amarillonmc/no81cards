--奇妙物语 奇妙小伙伴
function c10128009.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2)
	c:EnableReviveLimit()  
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6336))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	--replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_SEND_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c10128009.reptg)
	e2:SetOperation(c10128009.repop)
	c:RegisterEffect(e2)
end
function c10128009.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:GetDestination()==LOCATION_GRAVE end
	return true
end
function c10128009.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,2,REASON_EFFECT+REASON_REDIRECT)~=0 and c:IsLocation(LOCATION_EXTRA) and Duel.SelectEffectYesNo(tp,c) then
	   Duel.Hint(HINT_CARD,0,10128009)
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_SET_ATTACK)
	   e1:SetTargetRange(LOCATION_MZONE,0)
	   e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6336))
	   e1:SetValue(3000)
	   Duel.RegisterEffect(e1,tp)
	end
end