--弹 幕 战 斗 帕 露 西
local m=22348101
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22348101.xyzcondition)
	e1:SetTarget(c22348101.xyztarget)
	e1:SetOperation(c22348101.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348101.sccost)
	e2:SetTarget(c22348101.sctg)
	e2:SetOperation(c22348101.scop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c22348101.efcon)
	e3:SetOperation(c22348101.efop)
	c:RegisterEffect(e3)
	
end
function c22348101.xyzfilter1(c)
	return (c:IsXyzType(TYPE_XYZ) and c:IsRank(4)) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),c:GetCode()) and c:IsLocation(LOCATION_GRAVE))
end
function c22348101.xyzfilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c22348101.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	end
	return mg:IsExists(c22348101.xyzfilter1,2,nil) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(c22348101.xyzfilter2,1,nil))
end
function c22348101.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		mg=Duel.GetMatchingGroup(c22348101.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	   g=mg:Select(tp,2,2,nil)
	else
		mg=Duel.GetMatchingGroup(c22348101.xyzfilter1,tp,LOCATION_MZONE,0,nil)
		mg2=Duel.GetMatchingGroup(c22348101.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,mg)
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
function c22348101.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c22348101.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	if og:GetCount()>0 then
		local og1=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
		if og1:GetCount()>0 then
			Duel.Remove(og1,POS_FACEUP,REASON_COST)
		end
	end
end
function c22348101.thfilter(c)
	return c:IsSetCard(0x704) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToHand()
end
function c22348101.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348101.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c22348101.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348101.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348101.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22348101.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348101)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--copy effect
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22348101,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348101.cpcon)
	e1:SetCost(c22348101.cpcost)
	e1:SetTarget(c22348101.cptg)
	e1:SetOperation(c22348101.cpop)
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
function c22348101.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and Duel.GetTurnPlayer()~=tp
end
function c22348101.cpfilter(c)
	return c:IsSetCard(0x704) and c:IsType(TYPE_QUICKPLAY) and c:IsAbleToGraveAsCost() and c:CheckActivateEffect(false,true,false)~=nil
end
function c22348101.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c22348101.cpfilter,tp,LOCATION_DECK,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c22348101.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	g:GetFirst():CreateEffectRelation(e)
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
 
end
function c22348101.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return true end
	Duel.ClearTargetCard()
	local te=e:GetLabelObject()
	te:GetHandler():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	Duel.ClearOperationInfo(0)
end
function c22348101.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end









