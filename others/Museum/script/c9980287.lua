--外传纪录·愤怒之梅丽莎
function c9980287.initial_effect(c)
	c:EnableCounterPermit(0x1)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),2,2,c9980287.lcheck)
	c:EnableReviveLimit()
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c9980287.ctcon)
	e2:SetOperation(c9980287.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c9980287.atkval)
	c:RegisterEffect(e4)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980287,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980287)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9980287.thtg)
	e1:SetOperation(c9980287.thop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980287.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980287.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980287,1))
end
function c9980287.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xbc4)
end
function c9980287.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0xbc4) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0xbc4) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c9980287.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9980287.cfilter,1,nil,e:GetHandler())
end
function c9980287.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1,1)
end
function c9980287.atkval(e,c)
	return Duel.GetCounter(c:GetControler(),1,0,0x1)*100
end
function c9980287.filter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function c9980287.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c9980287.filter(chkc) end
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1,1,REASON_EFFECT)
		and Duel.IsExistingTarget(c9980287.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9980287.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c9980287.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsCanRemoveCounter(tp,1,1,0x1,1,REASON_EFFECT) then
		Duel.RemoveCounter(tp,1,1,0x1,1,REASON_EFFECT)
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980287,1))
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
