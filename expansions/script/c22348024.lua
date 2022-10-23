--金 属 化 接 触
local m=22348024
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--act in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(c22348024.handcon)
	c:RegisterEffect(e1)
	--change name
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22348024,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,22348024)
	e2:SetCost(c22348024.cost)
	e2:SetTarget(c22348024.target)
	e2:SetOperation(c22348024.activate)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348024,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabel(0)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,22348025)
	e3:SetCost(c22348024.spcost)
	e3:SetTarget(c22348024.sptg)
	e3:SetOperation(c22348024.spop)
	c:RegisterEffect(e3)
	
end

function c22348024.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end
function c22348024.filter(c)
	return c:IsSetCard(0x613) and c:IsDiscardable()
end
function c22348024.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348024.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c22348024.filter,1,1,REASON_COST+REASON_DISCARD)
end
function c22348024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function c22348024.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		local tc=sg:GetFirst()
		if tc:IsFaceup() then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD)
			e0:SetCode(EFFECT_CHANGE_CODE)
			e0:SetValue(22348025)
			tc:RegisterEffect(e0)
		end
	end
end
function c22348024.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c22348024.cfilter(c,e,tp)
	local lv=c:GetOriginalLevel()
	return bit.band(c:GetOriginalType(),TYPE_MONSTER)~=0 and lv>0 and c:IsFaceup() and c:IsReleasable()
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348024.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,lv,e,tp) and c:IsSetCard(0x613)
end
function c22348024.spfilter(c,lv,e,tp)
	return c:IsLevelAbove(lv+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x613)
end
function c22348024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c22348024.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c22348024.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.GetMZoneCount(tp,tc)>0 then
	Duel.Release(tc,REASON_COST)
	e:SetLabel(tc:GetLevel())
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	end
end
function c22348024.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348024.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end