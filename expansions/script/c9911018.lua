--沧海姬 瑞亚克
function c9911018.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_AQUA),2,2,c9911018.lcheck)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9911018,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,9911018)
	e1:SetCondition(c9911018.drcon)
	e1:SetCost(c9911018.drcost)
	e1:SetTarget(c9911018.drtg)
	e1:SetOperation(c9911018.drop)
	c:RegisterEffect(e1)
	--change attribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911018,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9911019)
	e2:SetCondition(c9911018.attcon)
	e2:SetTarget(c9911018.atttg)
	e2:SetOperation(c9911018.attop)
	c:RegisterEffect(e2)
end
function c9911018.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount()
end
function c9911018.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9911018.cfilter(c,tp,mc)
	local b1=c:IsLocation(LOCATION_MZONE)
	local b2=c:IsLocation(LOCATION_EXTRA) and Duel.IsPlayerAffectedByEffect(tp,9911013)
		and Duel.GetFlagEffect(tp,9911013)==0 and mc:IsLevelAbove(0) and c:IsLevelAbove(mc:GetLevel()+1)
	return (b1 or b2) and c:IsReleasable()
end
function c9911018.attfilter(c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end
function c9911018.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c9911018.cfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil,tp,c)
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=g:Select(tp,1,1,nil)
	local label=0
	if rg:IsExists(c9911018.attfilter,1,nil) then label=1 end
	if rg:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then
		Duel.RegisterFlagEffect(tp,9911013,RESET_PHASE+PHASE_END,0,0)
	end
	e:SetLabel(label)
	Duel.SendtoGrave(rg,REASON_RELEASE+REASON_COST)
end
function c9911018.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return (ct1<ct2 and Duel.IsPlayerCanDraw(tp,1)) or (ct1>ct2 and Duel.IsPlayerCanDraw(1-tp,1)) end
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	end
end
function c9911018.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local res=0
	if ct1<ct2 then res=Duel.Draw(tp,1,REASON_EFFECT)
	elseif ct1>ct2 then res=Duel.Draw(1-tp,1,REASON_EFFECT) end
	if res==0 or e:GetLabel()~=1 then return end
	ct1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if ct1<ct2 then Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	elseif ct1>ct2 then Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD) end
end
function c9911018.attcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9911018.thfilter(c)
	return c:IsSetCard(0x6954) and c:IsAbleToHand()
end
function c9911018.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH)
		and Duel.IsExistingMatchingCard(c9911018.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c9911018.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(ATTRIBUTE_EARTH)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(c9911018.thfilter,tp,LOCATION_DECK,0,1,nil) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c9911018.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
