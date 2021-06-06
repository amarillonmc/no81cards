local m=31405487
local cm=_G["c"..m]
cm.name="赤化掠光之异界兽-死棱黑镜"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.btg)
	e2:SetOperation(cm.bop)
	c:RegisterEffect(e2)
end
function cm.actfilter_1(c)
	return c:IsCode(31406029,31406047) and c:IsAbleToHand() and c:IsPosition(POS_FACEUP)
end
function cm.show_filter(c)
	return c:IsCode(31406029,31406047) and not c:IsPublic()
end
function cm.actfilter_2(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_PSYCHO) and c:IsAbleToHand() and c:IsPosition(POS_FACEUP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk_1=Duel.IsExistingMatchingCard(cm.actfilter_1,tp,LOCATION_REMOVED,0,1,nil)
	local chk_2=Duel.IsExistingMatchingCard(cm.show_filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(cm.actfilter_2,tp,LOCATION_REMOVED,0,1,nil)
	if chk==0 then return chk_1 or chk_2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.splimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	local chk_1=Duel.IsExistingMatchingCard(cm.actfilter_1,tp,LOCATION_REMOVED,0,1,nil)
	local chk_2=Duel.IsExistingMatchingCard(cm.show_filter,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(cm.actfilter_2,tp,LOCATION_REMOVED,0,1,nil)
	if not(chk_1 or chk_2) then return end
	local op
	if chk_1 and chk_2 then 
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif chk_1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,2))+1
	end
	local tg=Duel.GetMatchingGroup(cm.actfilter_1,tp,LOCATION_REMOVED,0,nil)
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.show_filter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		tg=Duel.GetMatchingGroup(cm.actfilter_2,tp,LOCATION_REMOVED,0,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	tc=tg:Select(tp,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.splimit(e,c)
	return not (c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_PSYCHO))
end
function cm.bfilter_th(c)
	return c:IsSetCard(0x6311) and c:IsAbleToHand() and c:IsPosition(POS_FACEUP)
end
function cm.bfilter_td(c)
	return c:IsSetCard(0x6311) and c:IsAbleToDeck()
end
function cm.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.bfilter_th,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
end
function cm.bop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local th=Duel.SelectMatchingCard(tp,cm.bfilter_th,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if th then
		Duel.SendtoHand(th,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,th)
	else
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local td=Duel.SelectMatchingCard(tp,cm.bfilter_td,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if td then
		Duel.BreakEffect()
		Duel.SendtoDeck(td,nil,2,REASON_EFFECT)
		td:ReverseInDeck()
	end
end