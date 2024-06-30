local m=40011451
local cm=_G["c"..m]
cm.name="蒸汽淑女 乌璐璐"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon_ig)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.thcon_quick)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCountLimit(1,m+100)
	e4:SetCondition(cm.tdcon)
	e4:SetTarget(cm.tdtg)
	e4:SetOperation(cm.tdop)
	c:RegisterEffect(e4)
end
function cm.thcon_ig(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40011457)
end
function cm.thcon_quick(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40011457) or Duel.IsPlayerAffectedByEffect(tp,40011463)
end
function cm.thcostfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0xaf1a)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c) and c:IsAbleToRemoveAsCost() end
	if not Duel.IsPlayerAffectedByEffect(tp,40011457) then
		local e=Duel.IsPlayerAffectedByEffect(tp,40011463)
		if e then e:Reset() end
		Duel.Hint(HINT_CARD,0,40011463)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
	e:SetLabel(0)
	if g:GetFirst():GetOriginalType()&TYPE_MONSTER>0 then
		e:SetLabel(1)
	end
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf1a) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)==0 then return end
	Duel.ConfirmCards(1-tp,tg)
	if e:GetLabel()==0 then return end
	local options={}
	table.insert(options,aux.Stringid(m,0))
	local neg_check=Duel.IsExistingMatchingCard(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if neg_check then table.insert(options,aux.Stringid(m,1)) end
	local draw_check=Duel.IsPlayerCanDraw(tp,1)
	if draw_check then table.insert(options,aux.Stringid(m,2)) end
	local op=Duel.SelectOption(tp,table.unpack(options))
	if op==0 then return end
	Duel.BreakEffect()
	if not neg_check then op=op+1 end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local tc=Duel.SelectMatchingCard(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	if op==2 then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:GetReason()==REASON_COST and c:GetReasonEffect():GetHandler():IsSetCard(0xaf1a) then
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+EVENT_CHAIN_END,0,1)
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.tdfilter(c,e)
	return c:IsSetCard(0xaf1a) and c:IsAbleToDeck() and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.tdspfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0xaf1a) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function cm.tdgfilter(g,e,tp,c)
	return g:IsContains(c) and Duel.IsExistingMatchingCard(cm.tdspfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,#g*2)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.tdfilter(chkc) end
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,0,nil,e)
		return g:CheckSubGroup(cm.tdgfilter,1,#g,e,tp,c)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_REMOVED,0,nil,e)
	g:SelectSubGroup(tp,cm.tdgfilter,false,1,#g,e,tp,c)
	Duel.SetTargetCard(g)
	e:SetLabel(#g*2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,cm.tdspfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetLabel()):GetFirst()
	if sc then
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end