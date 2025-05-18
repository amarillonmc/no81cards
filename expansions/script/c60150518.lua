--幻想曲 无法停止的梦
function c60150518.initial_effect(c)
	--instant
	--local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_NEGATE)
	--e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e2:SetRange(LOCATION_GRAVE)
	--e2:SetCode(EVENT_CHAIN_ACTIVATING)
	--e2:SetCountLimit(2,6010518)
	--e2:SetCondition(c60150518.condition2)
	--e2:SetOperation(c60150518.activate2)
	--c:RegisterEffect(e2)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60150518,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,60150518)
	e1:SetCondition(c60150518.condition)
	e1:SetCost(c60150518.cost)
	e1:SetTarget(c60150518.target)
	e1:SetOperation(c60150518.operation)
	c:RegisterEffect(e1)
end
function c60150518.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==tp then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
	end
end
function c60150518.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60150518.filter(c)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and not c:IsCode(60150518) and c:IsFaceup()
end
function c60150518.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150518.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150518.filter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c60150518.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60150518.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_EXTRA)
end
function c60150518.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:GetCode()==EVENT_SPSUMMON_SUCCESS and c:IsSetCard(0xab20) and Duel.IsChainNegatable(ev)
end
function c60150518.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(60150518,1)) then Duel.Hint(HINT_CARD,0,60150518)
		Duel.NegateActivation(ev)
	end
end