--遥 远 之 民 辟 易 的 少 女
local m=22348194
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,4,3,nil,nil,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetDescription(aux.Stringid(22348194,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22348194)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22348194.spcon1)
	e1:SetCost(c22348194.spcost)
	e1:SetTarget(c22348194.sptg)
	e1:SetOperation(c22348194.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348194.spcon2)
	c:RegisterEffect(e2)
	
end
function c22348194.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c22348194.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return aux.MZoneSequence(e:GetHandler():GetSequence())<4
end
function c22348194.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348194.filter(c)
	return c:IsCanOverlay()
end
function c22348194.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c22348194.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22348194.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SelectTarget(tp,c22348194.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c22348194.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
