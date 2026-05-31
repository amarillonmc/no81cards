--烬灵鸠合之处-火神山
function c9911810.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--destroy decktop
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c9911810.ddtcon1)
	e2:SetOperation(c9911810.ddtop1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c9911810.regcon)
	e4:SetOperation(c9911810.regop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_CHAIN_SOLVED)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c9911810.ddtcon2)
	e6:SetOperation(c9911810.ddtop2)
	c:RegisterEffect(e6)
	--search
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCountLimit(1,9911810)
	e7:SetCost(c9911810.thcost)
	e7:SetTarget(c9911810.thtg)
	e7:SetOperation(c9911810.thop)
	c:RegisterEffect(e7)
end
function c9911810.etfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa957) and c:GetOriginalType()&TYPE_MONSTER~=0
end
function c9911810.ddtcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and not Duel.IsChainSolving()
		and Duel.IsExistingMatchingCard(c9911810.etfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911810.ddtop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	local g=Duel.GetDecktopGroup(tp,1)
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
end
function c9911810.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp) and Duel.IsChainSolving()
		and Duel.IsExistingMatchingCard(c9911810.etfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c9911810.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9911810,RESET_CHAIN,0,1)
end
function c9911810.ddtcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,9911810)>0
end
function c9911810.ddtop2(e,tp,eg,ep,ev,re,r,rp)
	local n=math.min(Duel.GetFlagEffect(tp,9911810),Duel.GetFieldGroupCount(tp,LOCATION_DECK,0))
	Duel.ResetFlagEffect(tp,9911810)
	if n<1 then return end
	local g=Duel.GetDecktopGroup(tp,n)
	Duel.DisableShuffleCheck()
	Duel.Destroy(g,REASON_EFFECT)
end
function c9911810.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	local tc=g:GetFirst()
	if tc:IsFaceup() then Duel.HintSelection(g)
	else Duel.ConfirmCards(1-tp,tc) end
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ShuffleHand(tp)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9911810,0))
	end
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
end
function c9911810.thfilter(c)
	return not c:IsType(TYPE_FIELD) and c:IsSetCard(0xa957) and c:IsAbleToHand()
end
function c9911810.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911810.thfilter,tp,LOCATION_DECK,0,1,nil) end
	local tc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c9911810.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9911810.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		local tc=e:GetLabelObject()
		if tc and tc:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
