--旧 都 住 人 帕 露 西 
local m=22348103
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22348103.xyzcondition)
	e1:SetTarget(c22348103.xyztarget)
	e1:SetOperation(c22348103.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--zengjiasucai
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348103.sccost)
	e2:SetTarget(c22348103.sctg)
	e2:SetOperation(c22348103.scop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c22348103.efcon)
	e3:SetOperation(c22348103.efop)
	c:RegisterEffect(e3)
end
function c22348103.xyzfilter1(c)
	return (c:IsXyzType(TYPE_XYZ) and c:IsRank(4)) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),c:GetCode()) and c:IsLocation(LOCATION_GRAVE))
end
function c22348103.xyzfilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c22348103.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	end
	return mg:IsExists(c22348103.xyzfilter1,2,nil) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(c22348103.xyzfilter2,1,nil))
end
function c22348103.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		mg=Duel.GetMatchingGroup(c22348103.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	   g=mg:Select(tp,2,2,nil)
	else
		mg=Duel.GetMatchingGroup(c22348103.xyzfilter1,tp,LOCATION_MZONE,0,nil)
		mg2=Duel.GetMatchingGroup(c22348103.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,mg)
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
function c22348103.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c22348103.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	if og:GetCount()>0 then
		local og1=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
		if og1:GetCount()>0 then
			Duel.Remove(og1,POS_FACEUP,REASON_COST)
		end
	end
end
function c22348103.scfilter(c)
	return c:IsCanOverlay() and c:IsSetCard(0x704)
end
function c22348103.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348103.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c22348103.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c22348103.scfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
function c22348103.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22348103.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348103)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--DISABLE
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22348104,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348103.dacon)
	e1:SetCost(c22348103.dacost)
	e1:SetTarget(c22348103.datg)
	e1:SetOperation(c22348103.daop)
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
function c22348103.dacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348103.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348103.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c22348103.hthfilter(c)
	return c:IsSetCard(0x704) and c:IsAbleToHand()
end
function c22348103.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-700)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		if tc:GetControler()==tp and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c22348103.hthfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(22348104,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=Duel.SelectMatchingCard(tp,c22348103.hthfilter,tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end










