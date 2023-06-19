--猩 红 庭 院 的 男 爵
local m=22348267
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,5,2,nil,nil,99)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348267,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348267.flipcon)
	e1:SetCost(c22348267.flipcost)
	e1:SetTarget(c22348267.fliptg)
	e1:SetOperation(c22348267.flipop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348267,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c22348267.fliptg1)
	e2:SetOperation(c22348267.flipop1)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348267,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22348267.condition)
	e3:SetTarget(c22348267.target)
	e3:SetOperation(c22348267.operation)
	c:RegisterEffect(e3)
	--flip
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_FLIP)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c22348267.flipop0)
	c:RegisterEffect(e4)
	
end

function c22348267.flipcon(e)
	return e:GetHandler():GetSequence()<5
end
function c22348267.spfilter(c,e,tp)
	return c:IsSetCard(0x70a3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c22348267.flipcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ctg=Duel.GetMatchingGroupCount(c22348267.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and ctg>0 and ct>0 end
	local spct=0
	if ct>3 then ct=3 end
	if ct>ctg then ct=ctg end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if Duel.CheckRemoveOverlayCard(tp,LOCATION_MZONE,0,1,REASON_COST) then
		spct=Duel.RemoveOverlayCard(tp,LOCATION_MZONE,0,1,ct,REASON_COST)
	end
	e:SetLabel(spct)
end
function c22348267.fliptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ctg=Duel.GetMatchingGroupCount(c22348267.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	local spct=e:GetLabel()
	if chk==0 then return c:IsCanTurnSet() and ctg>0 and ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,spct,tp,LOCATION_DECK+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end

function c22348267.flipop(e,tp,eg,ep,ev,re,r,rp)
	local spct=e:GetLabel()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<spct then return end
	if spct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348267.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,spct,spct,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ConfirmCards(1-tp,g)
			Duel.BreakEffect()
		if Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)>0 then
		g:AddCard(c)
		Duel.ShuffleSetCard(g)
		end
	end
end
function c22348267.chfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function c22348267.fliptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348267.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c22348267.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c22348267.smfilter(c)
	return c:IsSummonable(true,nil)
end
function c22348267.flipop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348267.chfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.ChangePosition(g,POS_FACEUP_DEFENSE)>0 and Duel.IsExistingMatchingCard(c22348267.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348267,3)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,c22348267.smfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
	end
end


function c22348267.flipop0(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(22348267,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c22348267.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(22348267)~=0
end
function c22348267.xyzfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c22348267.xyzfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x70a3) and c:IsCanOverlay()
end
function c22348267.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22348267.xyzfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingTarget(c22348267.xyzfilter2,tp,LOCATION_GRAVE,0,1,nil)end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c22348267.xyzfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SelectTarget(tp,c22348267.xyzfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c22348267.ovfilter(c,e)
	return not c:IsImmuneToEffect(e)
end
function c22348267.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ttg=g:Filter(c22348267.ovfilter,nil,e)
	if  c:IsRelateToEffect(e) and ttg:GetCount()>0 then
		local ttc=ttg:GetFirst()
		while ttc do
		local og=ttc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		ttc=ttg:GetNext()
		end
		Duel.Overlay(c,ttg)
	end
end