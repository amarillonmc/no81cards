--月神之都
function c9910059.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910059+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910059.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c9910059.setcon)
	e2:SetOperation(c9910059.setop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetOperation(c9910059.regop)
	c:RegisterEffect(e3)
end
function c9910059.filter(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function c9910059.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c9910059.filter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910059,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		if Duel.GetFlagEffect(tp,9910059)~=0 then return end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(9910059,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetTargetRange(LOCATION_HAND,0)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9951))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,9910059,RESET_PHASE+PHASE_END,0,1)
	end
end
function c9910059.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local turnp=Duel.GetTurnPlayer()
	local tc=eg:GetFirst()
	while tc do
		if tc:GetSummonPlayer()==turnp then
			local flag=c:GetFlagEffectLabel(9910059)
			if flag then
				c:SetFlagEffectLabel(9910059,flag+1)
			else
				c:RegisterFlagEffect(9910059,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
			end
		end
		tc=eg:GetNext()
	end
end
function c9910059.setcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffectLabel(9910059)
	return ct and ct>=3
end
function c9910059.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		if Duel.ChangePosition(c,POS_FACEDOWN)~=1 then return end
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
