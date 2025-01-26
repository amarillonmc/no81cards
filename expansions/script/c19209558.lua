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
end
function c19209558.chkfilter(c)
	return c:IsCode(19209528) and c:IsFaceup()
		and Duel.IsExistingTarget(c19209558.cfilter,tp,0,LOCATION_MZONE,1,nil,c:GetRace())
end
function c19209558.cfilter(c,race)
	return not c:IsRace(race) and c:IsFaceup()
end
function c19209558.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c19209558.chkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,c19209558.chkfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c19209558.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tc:GetRace())
end
function c19209558.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetsRelateToChain()
	if #g~=2 then return end
	local tc=e:GetLabelObject()
	local c1=g:GetFirst()
	if tc==c1 then c2=g:GetNext() end
	if c1:IsFaceup() and c1:IsControler(tp) and c2:IsFaceup() and c2:IsControler(1-tp) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(c2:GetRace())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c1:RegisterEffect(e1)
	end
end
