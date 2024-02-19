--深土的境限
local m=30013065
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Effect 1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64753988,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.qkcon)
	e2:SetCost(cm.qkcost)
	e2:SetTarget(cm.setmtg)
	e2:SetOperation(cm.setmop)
	c:RegisterEffect(e2)
	local e21=e2:Clone()
	e21:SetType(EFFECT_TYPE_QUICK_O)
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetHintTiming(0,TIMING_END_PHASE)
	e21:SetCondition(cm.qqkcon)
	e21:SetCost(cm.qkcost)
	c:RegisterEffect(e21)
	--Effect 2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_MSET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e5:SetTarget(cm.postg)
	e5:SetOperation(cm.posop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SSET)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_POSITION)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_CHANGE_POS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCondition(cm.poscon)
	e7:SetTarget(cm.postg)
	e7:SetOperation(cm.posop)
	c:RegisterEffect(e7)  
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_POSITION)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e8:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e8:SetCondition(cm.ppscon)
	e8:SetTarget(cm.postg)
	e8:SetOperation(cm.posop)
	c:RegisterEffect(e8)
	--Effect 3 
	local e15=Effect.CreateEffect(c)
	e15:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e15:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e15:SetCode(EVENT_TO_GRAVE)
	e15:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e15:SetCondition(cm.spcon)
	e15:SetTarget(cm.sptg)
	e15:SetOperation(cm.spop)
	c:RegisterEffect(e15)
end
--Effect 1
function cm.qkcon(e)
	local tsp=e:GetHandler():GetControler()
	return not Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.qqkcon(e)
	local tsp=e:GetHandler():GetControler()
	return Duel.IsPlayerAffectedByEffect(tsp,30013020)
end
function cm.qkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return ec:GetFlagEffect(m+110)==0 end
	ec:RegisterFlagEffect(m+110,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
end
function cm.mset(c)
	return c:IsMSetable(true,nil)
end
function cm.setmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.setmop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.mset,tp,LOCATION_HAND,0,nil)
	if #sg==0 then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=sg:Select(tp,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsMSetable(true,nil) then
			Duel.MSet(tp,tc,true,nil)
		end
	end	
end
--Effect 2
function cm.cps(c)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown() 
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cps,1,nil)
end
function cm.cf2(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function cm.ppscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cf2,1,nil)
end
function cm.ps(c)
	return  c:IsCanTurnSet() or c:IsCanChangePosition()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.ps(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.ps,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,cm.ps,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) then
		local pos1=0
		if tc:IsCanTurnSet() then pos1=pos1+POS_FACEDOWN_DEFENSE end
		if not tc:IsPosition(POS_FACEUP_DEFENSE) then pos1=pos1+POS_FACEUP_DEFENSE end
		local pos2=Duel.SelectPosition(tp,tc,pos1)
		Duel.ChangePosition(tc,pos2)
	end
end
--Effect 3 
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and e:GetHandler():IsPreviousControler(tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,tc)
	end
end
 
