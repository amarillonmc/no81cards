--神树勇者的守护结界
function c9910316.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x956))
	e2:SetValue(c9910316.evalue)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9910316.thcon)
	e3:SetTarget(c9910316.thtg)
	e3:SetOperation(c9910316.thop)
	c:RegisterEffect(e3)
end
function c9910316.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function c9910316.cfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x956) and c:IsControler(tp) and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0
end
function c9910316.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910316.cfilter,1,nil,tp)
end
function c9910316.tgfilter(c,tp,eg,mc)
	local att=c:GetAttribute()
	local labels={Duel.GetFlagEffectLabel(tp,9910317)}
	local flag=0
	for i=1,#labels do flag=bit.bor(flag,labels[i]) end
	local g=Group.FromCards(c,mc)
	return eg:IsContains(c)
		and Duel.IsExistingMatchingCard(c9910316.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,g)
		and bit.band(flag,att)==0
end
function c9910316.thfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9910316.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910316.tgfilter(chkc,tp,eg) end
	if chk==0 then return Duel.IsExistingTarget(c9910316.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp,eg,e:GetHandler())
		and Duel.GetFlagEffect(tp,9910316)==0 end
	Duel.RegisterFlagEffect(tp,9910316,RESET_CHAIN,0,1)
	if eg:GetCount()==1 then
		Duel.SetTargetCard(eg)
		e:SetLabel(eg:GetFirst():GetAttribute())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectTarget(tp,c9910316.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,eg,e:GetHandler())
		e:SetLabel(g:GetFirst():GetAttribute())
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_ONFIELD)
end
function c9910316.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Group.FromCards(c,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=Duel.SelectMatchingCard(tp,c9910316.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g)
	if sg:GetCount()>0 then Duel.SendtoHand(sg,nil,REASON_EFFECT) end
	Duel.RegisterFlagEffect(tp,9910317,RESET_PHASE+PHASE_END,0,1,e:GetLabel())
end
