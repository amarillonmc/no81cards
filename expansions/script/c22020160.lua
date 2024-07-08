--人理之基 花嫁尼禄
function c22020160.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--summon success
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c22020160.sumcon)
	e0:SetOperation(c22020160.sumsuc)
	c:RegisterEffect(e0)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22020130)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020160,1))
	e2:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22020160)
	e2:SetTarget(c22020160.cointg)
	e2:SetOperation(c22020160.coinop)
	c:RegisterEffect(e2)
	--coin
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22020160,2))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22020160)
	e3:SetCondition(c22020160.erescon)
	e3:SetCost(c22020160.erecost)
	e3:SetTarget(c22020160.cointg)
	e3:SetOperation(c22020160.coinop)
	c:RegisterEffect(e3)
end
function c22020160.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c22020160.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SelectOption(tp,aux.Stringid(22020160,0))
end
function c22020160.thfilter(c)
	return aux.IsCodeListed(c,22020130) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c22020160.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SelectOption(tp,aux.Stringid(22020160,3))
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22020160.coinop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	local c=e:GetHandler()
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3==0 then
		Duel.SelectOption(tp,aux.Stringid(22020160,4))
	end
	if c1+c2+c3>=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		Duel.SelectOption(tp,aux.Stringid(22020160,5))
		local g=Duel.SelectMatchingCard(tp,c22020160.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if c1+c2+c3>=2 then
		Duel.SelectOption(tp,aux.Stringid(22020160,6))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
	if c1+c2+c3==3 and sg:GetCount()>0 then
		Duel.SelectOption(tp,aux.Stringid(22020160,7))
		Duel.SetLP(tp,8000)
	end
end
function c22020160.erescon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22020160.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end