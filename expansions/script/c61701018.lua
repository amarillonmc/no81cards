--永远的和平...
function c61701018.initial_effect(c)
	aux.AddCodeList(c,61701001)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c61701018.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,0xc)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,61701018+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c61701018.condition)
	e1:SetCost(c61701018.cost)
	e1:SetOperation(c61701018.activate)
	c:RegisterEffect(e1)
end
function c61701018.hcfilter(c)
	return c:IsCode(61701001) and c:IsFaceup()
end
function c61701018.handcon(e)
	return Duel.IsExistingMatchingCard(c61701018.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c61701018.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return tp~=Duel.GetTurnPlayer() and bit.band(ph,PHASE_MAIN2+PHASE_END)==0
end
function c61701018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g:GetCount()>0 end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c61701018.cfilter(c)
	return c:IsRace(RACE_WINDBEAST) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup()
end
function c61701018.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(0,1)
	Duel.RegisterEffect(e1,tp)
	local g=Duel.GetMatchingGroup(c61701018.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	if g:GetClassCount(Card.GetCode)>=13 and #dg>0 then
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
