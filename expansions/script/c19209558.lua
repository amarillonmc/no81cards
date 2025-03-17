--心象风景 爱意
function c19209558.initial_effect(c)
	aux.AddCodeList(c,19209528)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,19209558+EFFECT_COUNT_CODE_OATH)
	--e1:SetCondition(c19209558.condition)
	e1:SetTarget(c19209558.target)
	e1:SetOperation(c19209558.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1153)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(c19209558.setcon)
	e2:SetTarget(c19209558.settg)
	e2:SetOperation(c19209558.setop)
	c:RegisterEffect(e2)
end
function c19209558.tfilter(c)
	return c:IsCode(19209528) and c:IsFaceup()
		--and Duel.IsExistingTarget(c19209558.cfilter,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
function c19209558.cfilter(c,race)
	return not c:IsRace(race) and c:IsFaceup()
end
function c19209558.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c19209558.tfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209558.tfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c19209558.tfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RACE)
	local rc=Duel.AnnounceRace(tp,1,RACE_ALL-tc:GetRace())
	e:SetLabel(rc)
	--e:SetLabelObject(tc)
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	--Duel.SelectTarget(tp,c19209558.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tc:GetRace())
end
function c19209558.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(e:GetLabel())
		tc:RegisterEffect(e1)
	end
end
function c19209558.chkfilter(c,tp)
	return c:IsSummonLocation(LOCATION_EXTRA+LOCATION_GRAVE) and c:IsCode(19209528) and c:IsControler(tp)
end
function c19209558.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c19209558.chkfilter,1,nil,tp) and re and re:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c19209558.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c19209558.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
