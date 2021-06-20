--冲锋陷阵！
function c9330015.initial_effect(c)
	aux.AddCodeList(c,9330001)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c9330015.handcon)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,9330015+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c9330015.condition)
	e2:SetTarget(c9330015.target)
	e2:SetOperation(c9330015.activate)
	c:RegisterEffect(e2)
	--set/to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,9330115+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c9330015.thcost)
	e3:SetTarget(c9330015.settg)
	e3:SetOperation(c9330015.setop)
	c:RegisterEffect(e3)
end
function c9330015.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330015.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
			or Duel.IsExistingMatchingCard(c9330015.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9330015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function c9330015.filter1(c,e,tp)
	return c:IsCode(9330001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9330015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==1 then
		e:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	else
		e:SetProperty(0)
	end
end
function c9330015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandler():GetControler()
	local t=Duel.GetFieldGroupCount(p,0,LOCATION_ONFIELD)
	local s=Duel.GetFieldGroupCount(p,LOCATION_ONFIELD,0)
	local ct=t-s
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_MUST_ATTACK)
	e0:SetTargetRange(LOCATION_MZONE,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	if ct>=1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
		e1:SetValue(1500)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if ct>=4 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetCode(EFFECT_CANNOT_ACTIVATE)
		e2:SetTargetRange(0,1)
		e2:SetValue(c9330015.aclimit)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if ct>=5 then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetTargetRange(LOCATION_ONFIELD,0)
		e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
		e3:SetValue(1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		Duel.RegisterEffect(e4,tp)
	end
	if ct>=6 then
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e5:SetTargetRange(LOCATION_SZONE,0)
		e5:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
		e5:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e5,tp)
	end
	if ct>=7 then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetCode(EFFECT_IMMUNE_EFFECT)
		e6:SetTargetRange(LOCATION_ONFIELD,0)
		e6:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xaf93))
		e6:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e6,tp)
	end
	local g=Duel.SelectMatchingCard(tp,c9330015.filter1,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if ct>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9330015.aclimit(e,re,tp)
	local c=re:GetHandler()
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
end
function c9330015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330015.setfilter(c)
	if not (c:IsSetCard(0xaf93) and c:IsType(TYPE_TRAP) and not c:IsCode(9330015)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330015.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330015.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330015.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330015.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not tc:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end













