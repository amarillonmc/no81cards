--灵式装置 真神
function c9910026.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9910026.target)
	e1:SetOperation(c9910026.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9910026.eqlimit)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,9910026)
	e3:SetCondition(c9910026.spcon)
	e3:SetTarget(c9910026.sptg)
	e3:SetOperation(c9910026.spop)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910026,1))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,9910027)
	e4:SetCondition(aux.exccon)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c9910026.thtg)
	e4:SetOperation(c9910026.thop)
	c:RegisterEffect(e4)
end
function c9910026.eqlimit(e,c)
	return c:IsSetCard(0x3950)
end
function c9910026.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x3950)
end
function c9910026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c9910026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9910026.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9910026.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c9910026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local res=ec and ec:GetReasonCard() and ec:IsReason(REASON_MATERIAL+REASON_XYZ)
	if not res then return false end
	local rc=ec:GetReasonCard()
	local mg=rc:GetMaterial()
	return c:IsReason(REASON_LOST_TARGET) and mg:IsContains(ec) and not rc:GetFlagEffectLabel(9910026)
end
function c9910026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local rc=ec:GetReasonCard()
	local lg=rc:GetOverlayGroup()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and lg:IsContains(ec) and ec:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	ec:CreateEffectRelation(e)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,ec,1,0,0)
end
function c9910026.matfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function c9910026.xfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9910026.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ec=c:GetPreviousEquipTarget()
	local res=false
	if ec and ec:IsRelateToEffect(e) and Duel.SpecialSummonStep(ec,0,tp,tp,false,false,POS_FACEUP) then
		if c:IsRelateToEffect(e) and Duel.Equip(tp,c,ec) then
			res=true
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c9910026.eqlimit2)
			e1:SetLabelObject(ec)
			c:RegisterEffect(e1)
		end
	end
	if Duel.SpecialSummonComplete()==0 or not res then return end
	local rc=ec:GetReasonCard()
	if rc:IsOnField() then rc:RegisterFlagEffect(9910026,RESET_EVENT+RESETS_STANDARD,0,1) end
	local lg=rc:GetOverlayGroup()
	local g1=Duel.GetMatchingGroup(c9910026.matfilter,tp,0,LOCATION_ONFIELD,nil,e)
	local g2=Duel.GetMatchingGroup(c9910026.xfilter,tp,LOCATION_MZONE,0,nil,e)
	if g1:GetCount()>0 and g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9910026,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc1=g1:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc2=g2:Select(tp,1,1,nil):GetFirst()
		if not tc1 or not tc2 or tc1:IsImmuneToEffect(e) then return end
		local og=tc1:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		tc1:CancelToGrave()
		Duel.Overlay(tc2,Group.FromCards(tc1))
	end
end
function c9910026.eqlimit2(e,c)
	return e:GetLabelObject()==c
end
function c9910026.thfilter(c)
	return c:IsSetCard(0x5950) and not c:IsCode(9910026) and c:IsAbleToHand()
end
function c9910026.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910026.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910026.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910026.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
