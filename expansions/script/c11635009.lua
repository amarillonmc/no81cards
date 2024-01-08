--石像鬼的例行检查
local m=11635009
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)	
end
cm.SetCard_shixianggui=true
function cm.thfilter(c)
	return c.SetCard_shixianggui  and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,check) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer() 
	local check=(Duel.GetFieldGroupCount(p,0,LOCATION_MZONE)>0)
	local tg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	tg:Merge(g) 
	local tc=g:GetFirst()
	if (tc:IsLocation(LOCATION_GRAVE) or check) and Duel.SelectYesNo(tp,aux.Stringid(m,0))  then
		local loc=LOCATION_GRAVE
		if check then
			loc=LOCATION_GRAVE+LOCATION_DECK
		end
		local g1=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,loc,0,1,1,nil)
		tg:Merge(g1) 
	end	 
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end