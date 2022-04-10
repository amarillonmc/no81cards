--暗黑界的将军 埃梅拉德
function c359566.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),4,2,nil,nil,99)
	c:EnableReviveLimit()
	--announce 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(359566,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c359566.anccon)
	e1:SetTarget(c359566.anctg)
	e1:SetOperation(c359566.ancop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c359566.thtg)
	e2:SetOperation(c359566.thop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c359566.reptg)
	c:RegisterEffect(e3)
end
c359566.ac={}
function c359566.anccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c359566.anctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetHandler():GetOverlayGroup():Filter(Card.IsSetCard,nil,0x6)
	local num=g:GetCount()
	local i=1
	e:SetLabel(num)
	for i=1,num do 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
		c359566.ac[i]=Duel.AnnounceCard(tp)
	end
	Duel.SetTargetParam(table.unpack(c359566.ac))
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c359566.ancop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		c:SetHint(CHINT_CARD,c359566.ac[1])
	end
	for i=1,e:GetLabel() do 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabel(c359566.ac[i])
		e1:SetLabelObject(c)
		e1:SetCondition(c359566.discon)
		e1:SetOperation(c359566.disop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		c359566.ac[i]=nil
	end
end
function c359566.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gc=e:GetLabelObject()
	return gc and gc:IsLocation(LOCATION_MZONE)
		and re:GetHandler():GetCode()==e:GetLabel() and re:GetOwnerPlayer()~=tp
end
function c359566.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c359566.disop2)
	end
end
function c359566.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(1-tp,0,LOCATION_HAND)>0 then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
end
function c359566.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(359566,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,0)
		return true
	else return false end
end
function c359566.thfilter(c)
	return c:IsSetCard(0x6) and c:IsAbleToHand()
end
function c359566.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c359566.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(359566)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c359566.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c359566.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
