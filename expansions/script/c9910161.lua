--战车道装甲·MK.Ⅳ
Duel.LoadScript("c9910100.lua")
function c9910161.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,nil,7,2,c9910161.xyzfilter,99)
	c:EnableReviveLimit()
	--inactivatable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_INACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9910161.effectfilter)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910161,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(c9910161.mattg)
	e2:SetOperation(c9910161.matop)
	c:RegisterEffect(e2)
end
function c9910161.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
end
function c9910161.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c9910161.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910161.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910161.xfilter(chkc) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c9910161.xfilter,tp,LOCATION_MZONE,0,1,c)
		and (c:IsCanOverlay() or c:GetOverlayCount()>0) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910161.xfilter,tp,LOCATION_MZONE,0,1,1,c)
end
function c9910161.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local g=Group.FromCards(c)
		local og=c:GetOverlayGroup()
		if og:GetCount()>0 then g:Merge(og) end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910161,1))
		local sg=g:Select(tp,1,1,nil)
		if sg:IsContains(c) then
			if og:GetCount()>0 then Duel.SendtoGrave(og,REASON_RULE) end
		else
			Duel.RaiseSingleEvent(c,EVENT_DETACH_MATERIAL,e,0,0,0,0)
		end
		Duel.Overlay(tc,sg)
	end
end
