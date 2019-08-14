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
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(95992081,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,60150518)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c60150518.cost)
	e1:SetTarget(c60150518.target)
	e1:SetOperation(c60150518.operation)
	c:RegisterEffect(e1)
end
function c60150518.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60150518.filter(c)
	return c:IsSetCard(0xab20) and c:IsType(TYPE_MONSTER) and not c:IsCode(60150518) and c:IsFaceup()
end
function c60150518.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c60150518.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c60150518.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60150518.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c60150518.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c60150518.filter,nil,e,tp)
	if g:GetCount()<1 then return end
	local tc1=g:GetFirst()
	while tc1 do
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(0)
		tc1:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_DEFENSE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(0)
		tc1:RegisterEffect(e3)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e4)
		tc1=g:GetNext()
	end
	Duel.SpecialSummonComplete()
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