--丑 时 怨 咒 帕 露 西
local m=22348102
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22348102.xyzcondition)
	e1:SetTarget(c22348102.xyztarget)
	e1:SetOperation(c22348102.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--atkdown
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348102.atkcost)
	e2:SetTarget(c22348102.atktg)
	e2:SetOperation(c22348102.atkop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c22348102.efcon)
	e3:SetOperation(c22348102.efop)
	c:RegisterEffect(e3)
	
end
function c22348102.xyzfilter1(c)
	return (c:IsXyzType(TYPE_XYZ) and c:IsRank(4)) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),c:GetCode()) and c:IsLocation(LOCATION_GRAVE))
end
function c22348102.xyzfilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c22348102.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	end
	return mg:IsExists(c22348102.xyzfilter1,2,nil) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(c22348102.xyzfilter2,1,nil))
end
function c22348102.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		mg=Duel.GetMatchingGroup(c22348102.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	   g=mg:Select(tp,2,2,nil)
	else
		mg=Duel.GetMatchingGroup(c22348102.xyzfilter1,tp,LOCATION_MZONE,0,nil)
		mg2=Duel.GetMatchingGroup(c22348102.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,mg)
	g=mg:Select(tp,1,1,nil)
	local g2=mg2:Select(tp,1,1,nil)
	 Group.Merge(g,g2)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c22348102.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=nil
	if og then
		mg=og
	else
		mg=e:GetLabelObject()
	local sg=Group.CreateGroup()
	local tc=mg:GetFirst()
	while tc do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
		tc=mg:GetNext()
		end
	Duel.SendtoGrave(sg,REASON_RULE)
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function c22348102.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	if og:GetCount()>0 then
		local og1=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
		if og1:GetCount()>0 then
			Duel.Remove(og1,POS_FACEUP,REASON_COST)
		end
	end
end
function c22348102.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x704) and c:IsAbleToDeck()
end
function c22348102.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	and Duel.IsExistingMatchingCard(c22348102.atkfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,0,0)
end
function c22348102.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local aaa=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if aaa>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22348102,3))
		if aaa>3 then aaa=3 end
		local g=Duel.SelectMatchingCard(tp,c22348102.atkfilter,tp,LOCATION_REMOVED,0,1,aaa,nil)
		local aaaa=Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		if aaaa>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aaaa,nil) then
			Duel.BreakEffect()
		local ag=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,aaaa,aaaa,nil)
		local tc=ag:GetFirst()
		local aaaaa=c:GetAttack()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-aaaaa)
		tc:RegisterEffect(e1)
		tc=ag:GetNext()
	end
	end
	end
end
function c22348102.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22348102.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348102)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--DESTROY
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22348102,1))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c22348102.descon)
	e1:SetCost(c22348102.descost)
	e1:SetTarget(c22348102.destg)
	e1:SetOperation(c22348102.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function c22348102.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348102.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348102.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348102.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end








