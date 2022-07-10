--救祓少女·斯塔米罗
--21.12.31
local m=11451644
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,cm.matfilter,1,1)
	c:EnableReviveLimit()
	--activate cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetCondition(cm.costcon)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_SPSUMMON_COST)
	c:RegisterEffect(e3)
	--sset
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.matfilter(c)
	return c:IsLinkSetCard(0x172) and not c:IsLinkType(TYPE_LINK)
end
function cm.costcon(e)
	local tp=e:GetHandlerPlayer()
	if Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)==0 then return false end
	return true
end
function cm.costchk(e,te_or_c,tp)
	local p=e:GetHandlerPlayer()
	if p==tp then
		return true
	elseif cm[0] and (cm[0]:IsStatus(STATUS_SPSUMMON_STEP) or cm[0]:IsStatus(STATUS_SUMMONING)) then
		return true
	elseif Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_GRAVE,0,1,te_or_c) then
		e:SetLabelObject(te_or_c)
		cm[0]=nil
		return true
	end
	return false
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandlerPlayer()
	if p==tp then return end
	local tc=e:GetLabelObject()
	if cm[0] then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_GRAVE,0,1,1,tc)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	cm[0]=tc
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.filter(c)
	return c:IsSetCard(0x172) and c:IsType(TYPE_MONSTER)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(tp) and Duel.IsPlayerCanDraw(tp,2) and not Duel.IsPlayerAffectedByEffect(tp,63060238) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND,0,nil)
	if g and #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		if tg and #tg>0 then Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP) end
	else
		local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
end