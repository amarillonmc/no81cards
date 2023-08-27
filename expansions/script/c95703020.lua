--黑魔导封印阵
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(s.chainop)
	c:RegisterEffect(e2)
	--todesk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.totg)
	e3:SetOperation(s.toop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetOperation(s.regop1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_CHAIN_NEGATED)
	e5:SetOperation(s.regop2)
	c:RegisterEffect(e5)
end
function s.filter(c)
	return aux.IsCodeListed(c,46986414) and c:IsType(TYPE_CONTINUOUS) and not c:IsCode(id) 
		and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.chainop(e,tp,eg,ep,ev,re,r,rp)
	if aux.IsCodeListed(re:GetHandler(),46986414) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and ep==tp then
		Duel.SetChainLimit(s.chainlm)
	end
end
function s.chainlm(e,rp,tp)
	return tp==rp
end
function s.regop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(id)
		if flag then
			c:SetFlagEffectLabel(id,flag+1)
		else
			c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
		end
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local flag=c:GetFlagEffectLabel(id)
		if flag and flag>0 then
			c:SetFlagEffectLabel(id,flag-1)
		end
	end
end
function s.tofilter(c)
	return (c:IsCode(46986414) or aux.IsCodeListed(c,46986414)) and c:IsAbleToDeck()
end
function s.totg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsAbleToDeck() end
	local ct=e:GetHandler():GetFlagEffectLabel(id)
	if chk==0 then return ct and ct>0 and Duel.IsExistingTarget(s.tofilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.NecroValleyFilter(s.tofilter),tp,LOCATION_GRAVE,0,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),tp,LOCATION_GRAVE)
end
function s.toop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end