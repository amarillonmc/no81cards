--幻想曲的终章
function c60150510.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xab20),10,2)
	c:EnableReviveLimit()
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(60150510,0))
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
		local g=Duel.GetOperatedGroup()
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		if ct>0 then
			Duel.BreakEffect()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetLabel(seq)
			e1:SetOperation(c60150510.disop)
			e1:SetReset(0)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c60150510.disop(e,tp)
	return bit.lshift(0x1,e:GetLabel())
end