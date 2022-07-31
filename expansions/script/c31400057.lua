local m=31400057
local cm=_G["c"..m]
cm.name="星兹逃生仓"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.linkfilter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCost(cm.spcost)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.descon)
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)	
end
function cm.linkfilter(c)
	return c:IsSetCard(0xd2) and not c:IsCode(31400057)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler()
	if chk==0 then return Duel.GetMatchingGroupCount(cm.spfilter,tp,LOCATION_MZONE,0,nil)>0 end
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,nil,tc)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.spfilter(c,tc)
	return c:IsSetCard(0xd2) and c:IsRace(RACE_PSYCHO) and c:IsAbleToRemoveAsCost() and Duel.GetLocationCountFromEx(tp,tp,c,tc)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 or not tc:IsLocation(LOCATION_EXTRA) then return end
	Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and e:GetHandler():IsLocation(LOCATION_GRAVE) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.desfiltersp(c,e,tp)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.desfilterth(c)
	return c:IsSetCard(0xd2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sp=(Duel.IsExistingMatchingCard(cm.desfiltersp,tp,LOCATION_DECK,0,1,nil,e,tp) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	local th=Duel.IsExistingMatchingCard(cm.desfilterth,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return sp or th end
	if sp and not th then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	end
	if th and not sp then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local sp=(Duel.IsExistingMatchingCard(cm.desfiltersp,tp,LOCATION_DECK,0,1,nil,e,tp) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
	local th=Duel.IsExistingMatchingCard(cm.desfilterth,tp,LOCATION_DECK,0,1,nil)
	if not sp and not th then return end
	local oper
	if sp and th then
		oper=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	else 
		if sp then
			oper=0
		else
			oper=1
		end
	end
	if oper==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.desfiltersp,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.desfilterth,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end