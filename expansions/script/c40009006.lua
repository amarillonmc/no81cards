--圣金魔灵 恐惧之沙
function c40009006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ROCK),3,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)  
	--win
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c40009006.winop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009006,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,40009006)
	e2:SetCondition(c40009006.descon)
	e2:SetTarget(c40009006.destg)
	e2:SetOperation(c40009006.desop)
	c:RegisterEffect(e2)  
	local e5=e2:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009006,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,40009008)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c40009006.thcost)
	e3:SetOperation(c40009006.operation)
	c:RegisterEffect(e3)
end
function c40009006.cfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_ROCK) and c:IsControler(tp)
end
function c40009006.descon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c40009006.cfilter,1,nil,tp)
end
function c40009006.desfilter(c)
	return c:IsFaceup() and not (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE))
end
function c40009006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c40009006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c40009006.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c40009006.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
	end
end
function c40009006.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c40009006.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetTarget(c40009006.distg)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e3,tp)
end
function c40009006.distg(e,c)
	return c:IsFacedown()
end
function c40009006.cwfilter(c)
	return c:IsFacedown()
end
function c40009006.winop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c40009006.cwfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>=7 then 
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(40009006,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(40009006,0))
		Duel.Win(tp,nil)
	end
end
