--秘计螺旋 黑拥
local s,id,o=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.rmcon)
	e2:SetTarget(s.rmtg)
	e2:SetOperation(s.rmop)
	c:RegisterEffect(e2)
	--replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE) 
	e3:SetTarget(s.reptg)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFacedown,1,nil)
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetOperation(s.drop)
	Duel.RegisterEffect(e1,tp)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return (c:IsLocation(LOCATION_MZONE+LOCATION_REMOVED+LOCATION_EXTRA) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsLocation(LOCATION_SZONE)) and c:IsFacedown() and c:GetDestination()==LOCATION_HAND end
	if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		if c:IsLocation(LOCATION_SZONE) then
			Duel.ChangePosition(c,POS_FACEUP)
		else
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
		return true
	else return false end
end