--护法之魔棋阵
function c51931000.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--aclimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,51931000)
	e1:SetCost(c51931000.licost)
	e1:SetOperation(c51931000.liop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,51931001)
	e2:SetCost(c51931000.setcost)
	e2:SetTarget(c51931000.settg)
	e2:SetOperation(c51931000.setop)
	c:RegisterEffect(e2)
end
function c51931000.lifilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToGraveAsCost()
end
function c51931000.licost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931000.lifilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,c51931000.lifilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c51931000.mfilter(c)
	return c:IsSetCard(0x6258) and c:IsFaceup()
end
function c51931000.liop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c51931000.actcon)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6258))
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c51931000.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c51931000.rmfilter(c)
	return c:IsSetCard(0x6258) and c:IsAbleToRemoveAsCost()
end
function c51931000.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51931000.rmfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	sg=Duel.SelectMatchingCard(tp,c51931000.rmfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	sg:AddCard(e:GetHandler())
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c51931000.setfilter(c,tp)
	return c:IsSetCard(0x6258) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c51931000.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c51931000.setfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c51931000.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c51931000.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
