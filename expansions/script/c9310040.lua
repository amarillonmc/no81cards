--单调士道
function c9310040.initial_effect(c)
	aux.AddCodeList(c,9310027)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9310040+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c9310040.cost)
	e1:SetOperation(c9310040.activate)
	c:RegisterEffect(e1)
	--change code
	aux.EnableChangeCode(c,9310027)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c9310040.sumcon)
	e2:SetOperation(c9310040.sumsuc)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--DISABLE
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_GRAVE)
	e4:SetCountLimit(1,9311040)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9310040.target)
	e4:SetOperation(c9310040.op)
	c:RegisterEffect(e4)
end
function c9310040.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	local lp=Duel.GetLP(tp)
	local m=math.floor(math.min(lp,1500)/500)
	local t={}
	for i=1,m do
		t[i]=i*500
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,ac)
	e:SetLabel(ac)
	e:GetHandler():RegisterFlagEffect(9310040,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c9310040.thfilter(c,ac)
	return c:IsType(TYPE_TUNER) and c:IsLevel(4) and c:IsAttribute(ATTRIBUTE_LIGHT)
			and c:IsDefense(ac) and c:IsAttack(ac) and c:IsAbleToHand()
end
function c9310040.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9310040.thfilter,tp,LOCATION_DECK,0,nil,e:GetLabel())
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9310040,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c9310040.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and aux.AtkEqualsDef(c)
end
function c9310040.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9310040.filter,1,nil)
end
function c9310040.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c9310040.efun)
end
function c9310040.efun(e,ep,tp)
	return ep==tp
end
function c9310040.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function c9310040.op(e,tp,eg,ep,ev,re,r,rp)
	local exc=nil
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then exc=e:GetHandler() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectMatchingCard(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,exc)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
		local atk=tc:GetAttack()
		if atk>0 then
			Duel.Recover(tp,atk,REASON_EFFECT)
		end
	end
end