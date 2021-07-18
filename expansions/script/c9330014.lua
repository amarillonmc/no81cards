--陷敌入阵
function c9330014.initial_effect(c)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c9330014.handcon)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c9330014.condition)
	e2:SetTarget(c9330014.target)
	e2:SetOperation(c9330014.activate)
	c:RegisterEffect(e2)
	--set/to hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCountLimit(1,9330014+EFFECT_COUNT_CODE_DUEL)
	e3:SetCost(c9330014.thcost)
	e3:SetTarget(c9330014.settg)
	e3:SetOperation(c9330014.setop)
	c:RegisterEffect(e3)
end
function c9330014.filter(c)
	return c:IsFaceup() and c:IsCode(9330001)
end
function c9330014.handcon(e)
	return Duel.IsExistingMatchingCard(c9330014.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c9330014.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_TRAP) and c:IsSetCard(0xaf93)
end
function c9330014.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and
		   (Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)>1
			or Duel.IsExistingMatchingCard(c9330014.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil))
end
function c9330014.filter1(c)
	return c:IsAttackPos()
end
function c9330014.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9330014.filter1,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c9330014.filter1,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,g,g:GetCount(),0,0)
	if not c:IsStatus(STATUS_ACT_FROM_HAND) and c:IsLocation(LOCATION_SZONE)
	   and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c9330014.chlimit)
	end
end
function c9330014.chlimit(e,ep,tp)
	return tp==ep
end
function c9330014.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() then
	local g=Duel.GetMatchingGroup(c9330014.filter1,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local c=e:GetHandler()
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_LEVEL)
			e4:SetValue(6)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
			e5:SetValue(c9330014.synlimit)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
			tc:RegisterEffect(e5)
			local e6=e5:Clone()
			e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
			tc:RegisterEffect(e6)
			local e7=e5:Clone()
			e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
			tc:RegisterEffect(e7)
			local e8=e5:Clone()
			e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
			tc:RegisterEffect(e8)
			tc=g:GetNext()
			end
		end
	end
end  
function c9330014.synlimit(e,c)
	if not c then return false end
	return not c:IsSetCard(0xaf93)
end
function c9330014.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c9330014.setfilter(c)
	if not (c:IsSetCard(0xaf93) and c:IsType(TYPE_TRAP) and not c:IsCode(9330014)) then return false end
	return c:IsAbleToHand() or c:IsSSetable()
end
function c9330014.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9330014.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c9330014.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9330014.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
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