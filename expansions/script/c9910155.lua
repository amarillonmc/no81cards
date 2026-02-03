--战车道装甲·玛蒂尔达
Duel.LoadScript("c9910100.lua")
function c9910155.initial_effect(c)
	--xyz summon
	QutryZcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2,c9910155.xyzfilter,99)
	c:EnableReviveLimit()
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910155,1))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910155)
	e1:SetCost(c9910155.cost)
	e1:SetTarget(c9910155.target)
	e1:SetOperation(c9910155.operation)
	c:RegisterEffect(e1)
end
function c9910155.xyzfilter(c)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x9958) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910155.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9910155.matfilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_MONSTER) and c:IsCanOverlay()
end
function c9910155.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanChangePosition() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c9910155.matfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c9910155.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e)
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0
		and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c9910155.matfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(c,g)
		end
	end
end
