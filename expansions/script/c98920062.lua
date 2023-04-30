--虫之魔妖-净元虫
function c98920062.initial_effect(c)
	c:SetSPSummonOnce(98920062)
	c:SetUniqueOnField(1,0,98920062)
	--link summon
	aux.AddLinkProcedure(c,c98920062.matfilter,1,1)
	c:EnableReviveLimit()
	--indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c98920062.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920062)
	e2:SetCondition(c98920062.thcon)
	e2:SetTarget(c98920062.thtg)
	e2:SetOperation(c98920062.thop)
	c:RegisterEffect(e2)
end
function c98920062.matfilter(c)
	return c:IsLinkSetCard(0x121) and not c:IsLinkType(TYPE_LINK)
end
function c98920062.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c98920062.indcon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c98920062.lkfilter,1,nil)
end
function c98920062.cfilter2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsType(TYPE_SYNCHRO) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c98920062.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920062.cfilter2,1,nil,tp)
end
function c98920062.thfilter(c)
	return c:IsSetCard(0x121) and c:IsAbleToHand()
end
function c98920062.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920062.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920062.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920062.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end