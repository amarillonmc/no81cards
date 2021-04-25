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
	e2:SetCost(c9330015.cost)
	e2:SetCondition(c9330015.condition)
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
	return Duel.IsExistingMatchingCard(c9330015.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9330015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetProperty(EFFECT_FLAG_OATH)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9330015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
end
function c9330015.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf9c)
end
function c9330015.posfilter(c)
	return c:IsDefensePos() or c:IsFacedown()
end
function c9330015.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c9330015.posfilter,tp,LOCATION_MZONE,0,nil)
	if sg:GetCount()>0 then
			Duel.ChangePosition(sg,POS_FACEUP_ATTACK)
		local tc=sg:GetFirst()
		while tc do
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e0)
			tc:RegisterFlagEffect(31245780,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			tc=sg:GetNext()
		end
	end
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf9c))
	e1:SetValue(1800)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_LEVEL)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c9330015.distg)
	e2:SetValue(12)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--can not xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(c9330015.splimit)
	Duel.RegisterEffect(e3,tp)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c9330015.filter2,tp,LOCATION_MZONE,0,1,nil) and
	   Duel.SelectYesNo(tp,aux.Stringid(9330015,0)) then
		local xyzg=Duel.GetMatchingGroup(c9330015.filter2,tp,LOCATION_MZONE,0,nil,g) 
		if xyzg:GetCount()>0 then
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		   local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		   c:CancelToGrave()
		   Duel.Overlay(xyz,c)
		end
	end
end
function c9330015.distg(e,c)
	return not c:IsOriginalCodeRule(9330001)
end
function c9330015.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c9330015.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330015.setfilter(c)
	if not (c:IsSetCard(0xf9c) and c:IsType(TYPE_TRAP) and not c:IsCode(9330015)) then return false end
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













