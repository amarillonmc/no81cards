--致薰风的离风
--21.08.04
local m=11451608
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.sltg)
	e2:SetOperation(cm.slop)
	c:RegisterEffect(e2)
	--Unaffected
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetValue(cm.efilter)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetTarget(cm.etarget)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(aux.bfgcost)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
end
function cm.filter1(c)
	return c:IsSetCard(0x10) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.filter2(c,mg)
	return (c:IsSynchroSummonable(nil,mg) or c:IsLinkSummonable(mg)) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function cm.filter3(c)
	return c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function cm.sltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_GRAVE,0,2,nil) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,mg) and e:GetHandler():GetFlagEffect(m)==0 end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.slop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg==2 then
		Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct==2 then
			local mg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,mg)
			if #sg>0 then
				local tc=sg:GetFirst()
				if tc:IsSynchroSummonable(nil,mg) then
					Duel.SynchroSummon(tp,tc,nil,mg)
				else
					Duel.LinkSummon(tp,tc,mg)
				end
			end
		end
	end
end
function cm.etarget(e,c)
	return c:IsFaceup() and c:IsSetCard(0x10)
end
function cm.efilter(e,te)
	if not (te:IsActivated() and te:GetOwnerPlayer()==1-e:GetHandlerPlayer()) then return false end
	local ev=Duel.GetCurrentChain()
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return not (ex and (tg~=nil or tc>0))
end
function cm.thfilter(c)
	return c:GetAttack()>0 and (c:IsSetCard(0x10) or c:IsSetCard(0xb5)) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.atkfilter(c)
	return c:GetAttack()>0 and c:IsFaceup()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
		local tg=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil)
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-g:GetFirst():GetAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end