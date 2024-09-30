--神械的滋长
function c9910636.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_REMOVED,LOCATION_MZONE+LOCATION_REMOVED)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0xc954)
	c:RegisterEffect(e2)
	local e2g=e2:Clone()
	e2g:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e2g:SetCondition(c9910636.gravecon)
	c:RegisterEffect(e2g)
	--search/destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910636,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c9910636.thdescon)
	e3:SetTarget(c9910636.thdestg)
	e3:SetOperation(c9910636.thdesop)
	c:RegisterEffect(e3)
end
function c9910636.gravecon(e)
	local tp=e:GetHandlerPlayer()
	return not Duel.IsPlayerAffectedByEffect(tp,EFFECT_NECRO_VALLEY)
		and not Duel.IsPlayerAffectedByEffect(1-tp,EFFECT_NECRO_VALLEY)
end
function c9910636.remfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c9910636.thdescon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9910636.remfilter,1,nil)
end
function c9910636.thfilter(c,tp)
	local lv=c:GetLevel()
	return c:IsSetCard(0xc954) and c:IsType(TYPE_MONSTER) and lv>0 and c:IsAbleToHand()
		and not Duel.IsExistingMatchingCard(c9910636.filter1,tp,LOCATION_REMOVED,0,1,nil,lv)
end
function c9910636.filter1(c,lv)
	return c:IsFaceup() and c:IsLevel(lv)
end
function c9910636.thdestg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	local b1=Duel.IsExistingMatchingCard(c9910636.thfilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(9910636,1)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(9910636,2)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(9910636,sel+1))
	if sel==0 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	end
end
function c9910636.thdesop(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c9910636.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end
