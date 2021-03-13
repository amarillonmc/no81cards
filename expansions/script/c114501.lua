--里械仪者·地仪斧
local m = 114501
local cm = _G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.postg)
	e1:SetOperation(cm.posop)
	c:RegisterEffect(e1)
	--des 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetCountLimit(1,m+100)
	e1:SetCost(cm.descost)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
end
function cm.pfilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsCanChangePosition()
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_FLIP) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xca1) and c:IsAbleToHand()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
	local b2 = Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.pfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.pfilter,tp,LOCATION_MZONE,0,1,nil) and (b1 or b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,cm.pfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsPosition(POS_FACEDOWN_DEFENSE) and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) > 0 then
		local b1 = Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp)
		local b2 = Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
		if not b1 and not b2 then return end
		Duel.BreakEffect()
		local op = 2
		if b1 and b2 then 
			op = Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3)) + 1 
		elseif b1 then op = 1
		end
		if op == 1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,sg)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)	  
			local tg = Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end
	end
end
function cm.descost(e)
	e:SetLabel(100)
	return true
end
function cm.desfilter(c,rc)
	return not rc:GetEquipGroup():IsContains(c)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk == 0 then
		if e:GetLabel() ~= 100 then
			return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		else
			e:SetLabel(0)
			return c:IsReleasable() and Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
		end
	end
	if e:GetLabel() == 100 then
		Duel.Release(c,REASON_COST)
	end
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.desop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg = Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if #dg > 0 then
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end