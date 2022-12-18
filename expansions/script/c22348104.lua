--夏 日 泳 装 帕 露 西
local m=22348104
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c22348104.xyzcondition)
	e1:SetTarget(c22348104.xyztarget)
	e1:SetOperation(c22348104.XyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--SearchCard
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c22348104.sccost)
	e2:SetTarget(c22348104.sctg)
	e2:SetOperation(c22348104.scop)
	c:RegisterEffect(e2)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(c22348104.efcon)
	e3:SetOperation(c22348104.efop)
	c:RegisterEffect(e3)
	
end
function c22348104.xyzfilter1(c)
	return (c:IsXyzType(TYPE_XYZ) and c:IsRank(4)) or (Duel.IsPlayerAffectedByEffect(c:GetOwner(),c:GetCode()) and c:IsLocation(LOCATION_GRAVE))
end
function c22348104.xyzfilter2(c)
	return c:IsXyzType(TYPE_XYZ) and c:IsRank(4) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c22348104.xyzcondition(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg
	if og then
		mg=og
	else
		mg=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_GRAVE,0)
	end
	return mg:IsExists(c22348104.xyzfilter1,2,nil) and (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or mg:IsExists(c22348104.xyzfilter2,1,nil))
end
function c22348104.xyztarget(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=nil
	local mg2=nil
	local g=nil
	if og then
		mg=og 
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		mg=Duel.GetMatchingGroup(c22348104.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	   g=mg:Select(tp,2,2,nil)
	else
		mg=Duel.GetMatchingGroup(c22348104.xyzfilter1,tp,LOCATION_MZONE,0,nil)
		mg2=Duel.GetMatchingGroup(c22348104.xyzfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,mg)
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
function c22348104.XyzOperation(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
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
function c22348104.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:GetCount()>0 and og:FilterCount(Card.IsAbleToRemoveAsCost,nil)>0 end
	if og:GetCount()>0 then
		local og1=og:FilterSelect(tp,Card.IsAbleToRemoveAsCost,1,1,nil)
		if og1:GetCount()>0 then
			Duel.Remove(og1,POS_FACEUP,REASON_COST)
		end
	end
end
function c22348104.thfilter(c)
	return c:IsSetCard(0x704) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not c:IsCode(22348104)
end
function c22348104.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348104.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c22348104.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c22348104.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c22348104.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function c22348104.efop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348104)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--imm
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(22348103,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348104.immcon)
	e1:SetCost(c22348104.immcost)
	e1:SetOperation(c22348104.immop)
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
function c22348104.immcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and  e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c22348104.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22348104.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x704)
end
function c22348104.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348104.imfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(c22348104.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(c22348104,RESET_CHAIN,0,1)
			tc=g:GetNext()
	end
end
function c22348104.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
