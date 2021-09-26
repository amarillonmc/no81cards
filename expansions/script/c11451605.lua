--块斩机 算子汉密尔顿
--21.08.08
local m=11451605
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,1,nil,nil,99)
	c:EnableReviveLimit()
	--xyz effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.effcon)
	e1:SetCost(cm.ctcost)
	e1:SetTarget(cm.efftg)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	c:RemoveOverlayCard(tp,ct,ct,REASON_COST)
	e:SetLabel(ct)
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	if ct>=1 then
		e:SetCategory(CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
	if ct>=3 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		e:SetCategory(CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
	end
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct>=1 then
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		local dg=Duel.GetOperatedGroup()
		if #dg>0 and not dg:GetFirst():IsSetCard(0x132) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTargetRange(1,0)
			Duel.RegisterEffect(e1,tp)
		end
	end
	if ct>=2 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_CONFIRM)
		e2:SetOperation(cm.tgop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	if ct>=3 then
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
		if #g>0 then
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
function cm.tfilter(c)
	return c:IsSetCard(0x132) and c:IsAbleToGrave()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local dg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(dg,REASON_EFFECT)
		e:Reset()
	end
end
function cm.tgfilter(c)
	return c:IsSetCard(0x132) and c:IsFaceup()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil)
end
function cm.spfilter2(c,e,tp)
	return c:IsSetCard(0x132) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsExistingMatchingCard(cm.atfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function cm.atfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end