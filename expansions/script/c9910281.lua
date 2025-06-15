--星幽正道者
function c9910281.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c9910281.lcheck)
	c:EnableReviveLimit()
	--can not be effect target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c9910281.indtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910281,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,9910281)
	e2:SetCondition(c9910281.thcon)
	e2:SetTarget(c9910281.thtg)
	e2:SetOperation(c9910281.thop)
	c:RegisterEffect(e2)
end
function c9910281.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x3957)
end
function c9910281.indtg(e,c)
	return e:GetHandler()==c or (c:IsType(TYPE_PENDULUM) and e:GetHandler():GetLinkedGroup():IsContains(c))
end
function c9910281.cfilter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsFacedown()
end
function c9910281.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910281.cfilter,1,nil)
end
function c9910281.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if not g:IsExists(Card.IsControler,1,nil,1-tp) then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c9910281.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c9910281.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local sg=Duel.GetOperatedGroup()
		local g2=Duel.GetMatchingGroup(c9910281.thfilter,tp,LOCATION_DECK,0,nil)
		if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
			and e:GetLabel()==1 and #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(9910281,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg2)
		end
	end
end
