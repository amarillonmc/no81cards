--战车道装甲·T-34
require("expansions/script/c9910106")
function c9910134.initial_effect(c)
	--xyz summon
	Zcd.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2,c9910134.xyzfilter,aux.Stringid(9910134,0),99)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910134,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2,9910134)
	e1:SetCost(c9910134.cost)
	e1:SetTarget(c9910134.target)
	e1:SetOperation(c9910134.operation)
	c:RegisterEffect(e1)
end
function c9910134.xyzfilter(c,xyzc)
	return (c:IsType(TYPE_MONSTER) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x952) and c:IsFaceup()))
		and c:IsRace(RACE_MACHINE)
end
function c9910134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c9910134.filter(c,tp)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and (c:IsControler(tp) or c:IsAbleToChangeControler())
end
function c9910134.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and c9910134.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910134.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c9910134.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c,tp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c9910134.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	else return end
	local g=Duel.GetMatchingGroup(nil,1-tp,LOCATION_MZONE+LOCATION_HAND,0,nil)
	if c:GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x952) and g:GetCount()>0 then
		Duel.BreakEffect()
		local sg=g:Select(1-tp,1,1,nil)
		Duel.HintSelection(sg)
		local sc=sg:GetFirst()
		local osg=sc:GetOverlayGroup()
		if osg:GetCount()>0 then
			Duel.SendtoGrave(osg,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(sc))
	end
end
