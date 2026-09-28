--战车道装甲·T-34
Duel.LoadScript("c9910100.lua")
function c9910134.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2,c9910134.xyzfilter,99)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910134,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c9910134.matcost)
	e1:SetTarget(c9910134.mattg)
	e1:SetOperation(c9910134.matop)
	c:RegisterEffect(e1)
end
function c9910134.xyzfilter(c,xyzc)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910134.xfilter2(c,e)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and not c:IsImmuneToEffect(e)
end
function c9910134.matcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910134.mfilter(c,tp,mc)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_XYZ) and (Duel.GetTurnPlayer()==tp or c~=mc)
end
function c9910134.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c9910134.mfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
		and Duel.IsExistingTarget(Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c9910134.mfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectTarget(tp,Card.IsCanOverlay,tp,0,LOCATION_MZONE,1,1,nil)
end
function c9910134.matop(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local tg=Duel.GetTargetsRelateToChain()
	if #tg~=2 then return end
	local tc=tg:GetFirst()
	if tc==hc then tc=tg:GetNext() end
	if hc:IsControler(tp) and not hc:IsImmuneToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(hc,Group.FromCards(tc))
	end
end
