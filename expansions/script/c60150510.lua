--幻想曲的终章
function c60150510.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab20),10,2)
	c:EnableReviveLimit()
	--cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(c60150510.tgvalue)
	c:RegisterEffect(e1)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1,60150510)
	e12:SetCost(c60150510.thcost)
	e12:SetTarget(c60150510.thtg)
	e12:SetOperation(c60150510.thop)
	c:RegisterEffect(e12)
end
function c60150510.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c60150510.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c60150510.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60150510.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsControler(1-tp) then seq=seq+16 end
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetLabel(seq)
		e1:SetCondition(c60150510.discon)
		e1:SetOperation(c60150510.disop)
		e1:SetReset(0)
		Duel.RegisterEffect(e1,tp)
	end
end
function c60150510.cfilter(c)
	return c:IsFaceup() and c:IsCode(60150510)
end
function c60150510.discon(e)
	if Duel.IsExistingMatchingCard(c60150510.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		return true
	end
	e:Reset()
	return false
end
function c60150510.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end