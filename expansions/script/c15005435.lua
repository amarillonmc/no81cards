local m=15005435
local cm=_G["c"..m]
cm.name="泣声终末"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_ACTION+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,15005435+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--to deck & hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,15005436)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
end
function cm.filter(c,e,tp)
	local p=c:GetControler()
	return c:IsType(TYPE_TUNER) and Duel.GetLocationCount(p,LOCATION_MZONE,tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if not aux.NecroValleyNegateCheck(tc) then
			local p=tc:GetControler()
			local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
			if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,p) and ft>0 then
				Duel.SpecialSummon(tc,0,tp,p,false,false,POS_FACEUP)
			end
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function cm.tdfilter(c,e)
	return c:IsSetCard(0x9f3f) and (c:IsAbleToDeck() or c:IsAbleToHand()) and c:IsCanBeEffectTarget(e)
end
function cm.tdcheck(g)
	return g:IsExists(cm.thfilter,1,nil,g)
end
function cm.thfilter(c,g)
	return c:IsAbleToHand() and g:IsExists(Card.IsAbleToDeck,#g-1,c)
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.tdfilter(chkc,e) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),e)
	if chk==0 then return g:CheckSubGroup(cm.tdcheck,3,3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ag=g:SelectSubGroup(tp,cm.tdcheck,false,3,3)
	Duel.SetTargetCard(ag)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,ag,ag:GetCount()-1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,ag,1,0,0)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	if tg:IsExists(cm.thfilter,1,nil,tg) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local ag=tg:FilterSelect(tp,cm.thfilter,1,1,nil,tg)
		if Duel.SendtoHand(ag,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,ag)
			tg:Sub(ag)
		end
	end
	if #tg>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end