--渡 桥 值 班 帕 露 西
local m=22348100
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22348100.xyzcondition)
	e1:SetTarget(c22348100.xyztarget)
	e1:SetOperation(c22348100.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348100.spcost)
	e2:SetTarget(c22348100.sptg)
	e2:SetOperation(c22348100.spop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c22348100.efcon)
	e3:SetOperation(c22348100.efop)
	c:RegisterEffect(e3)
end
function c22348100.xyzfilter1(c)
	return (c:IsXyzType(TYPE_XYZ) and c:IsRank(4)) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),c:GetCode()) and c:IsLocation(LOCATION_GRAVE))
end
function c22348100.xyzfilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c22348100.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	end
	return mg:IsExists(c22348100.xyzfilter1,2,nil) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(c22348100.xyzfilter2,1,nil))
end
function c22348100.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		mg=Duel.GetMatchingGroup(c22348100.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	   g=mg:Select(tp,2,2,nil)
	else
		mg=Duel.GetMatchingGroup(c22348100.xyzfilter1,tp,LOCATION_MZONE,0,nil)
		mg2=Duel.GetMatchingGroup(c22348100.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,mg)
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
function c22348100.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c22348100.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	if og:GetCount()>0 then
		local og1=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
		if og1:GetCount()>0 then
			Duel.Remove(og1,POS_FACEUP,REASON_COST)
		end
	end
end
function c22348100.spfilter(c,e,tp)
	return c:IsSetCard(0x704) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348100.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22348100.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c22348100.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348100.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c22348100.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22348100.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348100)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--tohand
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22348100,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348100.thcon)
	e1:SetCost(c22348100.thcost)
	e1:SetTarget(c22348100.thtg)
	e1:SetOperation(c22348100.thop)
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
function c22348100.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348100.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348100.thfilter(c)
	return c:IsAbleToHand() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c22348100.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348100.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c22348100.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c22348100.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348100.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	local tc=g:GetFirst()
	local aaa=tc:GetCode()
	local ttp=tc:GetOwner()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c22348100.sumlimit)
	e1:SetLabel(aaa)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e3,tp)
		if Duel.IsExistingMatchingCard(c22348100.thspfilter,ttp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(ttp,aux.Stringid(22348100,2)) then
		   Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,ttp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(ttp,c22348100.thspfilter,ttp,LOCATION_HAND,0,1,1,nil,e,tp)
		if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,ttp,ttp,false,false,POS_FACEUP)
		end
		end
	end  
end 
function c22348100.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end 
function c22348100.thspfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end