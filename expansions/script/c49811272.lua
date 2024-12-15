--コアキメイルート・ビースト
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,36623431)
	--search
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
    e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.thcon)
    e1:SetCost(s.thcost)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --apply effect (canceled)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e2:SetCode(EVENT_CUSTOM+id)
	--e2:SetRange(LOCATION_REMOVED)
	--e2:SetCondition(s.acon)
	--e2:SetOperation(s.aop)
	--c:RegisterEffect(e2)
	--if not s.global_check then
	--	s.global_check=true
	--	local _ConfirmCards=Duel.ConfirmCards
	--	function Duel.ConfirmCards(p,g)
	--		local res=_ConfirmCards(p,g)
	--		Duel.RaiseEvent(g,EVENT_CUSTOM+id,e2,0,0,p,0)
	--		--Debug.Message(#g)
	--		return res
	--	end
	--end
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,4))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCost(s.tdcost)
	e2:SetCondition(s.tdcon)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_RELEASE)
	e3:SetCondition(s.tdcon2)
	c:RegisterEffect(e3)
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost(POS_FACEUP) end
    Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST,tp)
end
function s.confilter(c)
	return c:IsSetCard(0x1d) and c:IsType(TYPE_LINK)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp or (Duel.GetTurnPlayer()==tp and Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_MZONE,0,1,nil))
end
function s.thfilter(c)
	return c:IsCode(36623431) and c:IsAbleToHand()
end
function s.thfilter2(c)
	return aux.IsCodeListed(c,36623431) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		end
	end
end
--function s.nopubfilter(c)
--	return not c:IsPublic()
--end
--function s.corefilter(c,code)
--	return c:IsOriginalCodeRule(36623431) and (c:GetLocation()==LOCATION_HAND or c:GetLocation()==LOCATION_DECK)
--end
--function s.acon(e,tp,eg,ep,ev,re,r,rp)
--	return ep==1-tp and eg:IsExists(s.corefilter,1,nil)
--end
--function s.aop(e,tp,eg,ep,ev,re,r,rp)
	--Debug.Message(1)
--	local c=e:GetHandler()
--	local b1=Duel.IsExistingMatchingCard(s.nopubfilter,tp,0,LOCATION_HAND,1,nil)
--	local b3=c:IsAbleToDeck()
--	local op=0
--	Duel.Hint(HINT_CARD,0,id)
--	if b1 and b3 then
--		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3),aux.Stringid(id,4))
--	elseif b1 then
--		op=Duel.SelectOption(tp,aux.Stringid(id,2),aux.Stringid(id,3))
--	elseif b3 then
--		op=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))+1
--	else
--		op=Duel.SelectOption(tp,aux.Stringid(id,3))+1
--	end
	--Debug.Message(2)
--	if op==0 then
--		local g=Duel.GetMatchingGroup(s.nopubfilter,tp,0,LOCATION_HAND,nil)
--		local tc=g:RandomSelect(tp,1):GetFirst()
--		Duel.ConfirmCards(tp,tc)
--		local e1=Effect.CreateEffect(c)
--		e1:SetType(EFFECT_TYPE_SINGLE)
--		e1:SetDescription(66)
--	    e1:SetCode(EFFECT_PUBLIC)
--	    e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
--		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
--		tc:RegisterEffect(e1)
--	elseif op==1 then
--		Duel.Damage(1-tp,250,REASON_EFFECT)
--	elseif op==2 then
--		Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
--	end	
--end
function s.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x1d) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
		and c:IsReason(REASON_EFFECT) 
end
function s.cfilter2(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousSetCard(0x1d) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function s.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function s.tdcostfilter(c)
	return c:IsCode(81994591) and c:IsAbleToGraveAsCost()
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.tdcostfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,s.tdcostfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end