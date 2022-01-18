--乘樱从风且祀春
--22.01.02
local m=11451642
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp,mg)
	if bit.band(c:GetType(),0x81)~=0x81 or c.mat_filter or c.mat_group_check or not (c:IsAttribute(ATTRIBUTE_WIND) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	local ct=math.max(1,c:GetLevel()//3)
	if c.mat_filter then
		local g=mg:Filter(cm.mfilter2,nil,c)
		if c.mat_group_check then return #g>0 and g:CheckSubGroup(cm.fselect2,ct,ct,tp,rc) end
		return #g>0 and g:CheckSubGroup(cm.fselect,ct,ct,tp)
	end
	return #mg>0 and mg:CheckSubGroup(cm.fselect,ct,ct,tp)
end
function cm.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function cm.fselect2(g,tp)
	return Duel.GetMZoneCount(tp,g)>0 and rc.mat_group_check(g)
end
function cm.mfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGrave()
end
function cm.mfilter2(c,rc)
	return c:IsType(TYPE_MONSTER) and rc.mat_filter(c)
end
function cm.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	mg=mg:Filter(cm.filter1,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local ct=math.max(1,tc:GetLevel()//3)
		local mat=mg:SelectSubGroup(tp,cm.fselect,false,ct,ct,tp)
		if not mat or #mat==0 then return end
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.filter(c,e,tp,ec)
	return c:IsSetCard(0x97f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.clfilter,tp,LOCATION_GRAVE,0,1,ec,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.clfilter(c,tc)
	return aux.IsCodeListed(tc,c:GetCode())
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end