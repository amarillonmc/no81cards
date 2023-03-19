--海晶少女·海天使蓝蓝
local m=42620015
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.mfilter,2,2)
	c:EnableReviveLimit()
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--tohand from grave
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.thfgcon)
	e2:SetCost(cm.thfgcost)
	e2:SetTarget(cm.thfgtg)
	e2:SetOperation(cm.thfgop)
	c:RegisterEffect(e2)
end

c42620015.SetCard_Blue=true

function cm.mfilter(c)
	return c:IsLinkSetCard(0x12b)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.thfilter(c)
	return c:IsAttackBelow(1500) and c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToHand()
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.spllimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)
end

function cm.spllimit(e,c)
	return not c:IsRace(RACE_CYBERSE)
end

function cm.thfgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0
end

function cm.thfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end

function cm.thfgfilter(c)
	return c:IsSetCard(0x12b) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end

function cm.thfg2filter(c)
	return c:IsRace(RACE_CYBERSE) and c:IsAbleToHand()
end

function cm.thfgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfgfilter,tp,LOCATION_GRAVE,0,1,nil) and
	Duel.IsExistingMatchingCard(cm.thfg2filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_GRAVE)
end

function cm.thfgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfgfilter,tp,LOCATION_GRAVE,0,nil)
	local gg=Duel.GetMatchingGroup(cm.thfg2filter,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 or gg:GetCount()>0 then
		local gc=nil
		local ggc=nil
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			gc=g:Select(tp,1,1,nil)
		end
		if gg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			ggc=gg:Select(tp,1,1,nil)
		end
		if gc and ggc then
			local ggg=Group.__add(gc,ggc)
			Duel.SendtoHand(ggg,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ggg)
		elseif gc then
			Duel.SendtoHand(gc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,gc)
		elseif ggc then
			Duel.SendtoHand(ggc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,ggc)
		end
	end
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.splimit)
	e4:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e4,tp)  
end

function cm.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER)
end