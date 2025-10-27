local m=15005627
local cm=_G["c"..m]
cm.name="枯绿追忆术-『矶翰纳遗梦』"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005613)
	--Activate deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.r1tg)
	e1:SetOperation(cm.r1op)
	c:RegisterEffect(e1)
	--Activate hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.r2tg)
	e2:SetOperation(cm.r2op)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.thcost)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
end
function cm.filter(c,e,tp)
	return c:IsCode(15005613) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_LINK) and c:IsLinkBelow(4) and c:IsAbleToRemove()
end
function cm.fselect(g,tp)
	return g:GetSum(Card.GetLink)==4 and Duel.GetMZoneCount(tp,g)>0
end
function cm.r1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.fselect,1,#g,tp) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.r1op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_MZONE,0,nil)
	if g:CheckSubGroup(cm.fselect,1,#g,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,#g,tp)
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
		local mg=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		local tc=tg:GetFirst()
		Duel.BreakEffect()
		tc:SetMaterial(mg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.r2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if chk==0 then
		return g:CheckSubGroup(cm.fselect,1,#g,tp) and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.r2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_EXTRA,0,nil)
	if g:CheckSubGroup(cm.fselect,1,#g,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:SelectSubGroup(tp,cm.fselect,false,1,#g,tp)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)==0 then return end
		local mg=Duel.GetOperatedGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		local tc=tg:GetFirst()
		Duel.BreakEffect()
		tc:SetMaterial(mg)
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0xf42) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end