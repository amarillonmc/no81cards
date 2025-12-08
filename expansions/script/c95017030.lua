local s,id=GetID()
Duel.LoadScript("kcode_myxyz.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	myxyz.AddXyzProcedure(c, id, 1)
	 
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(id,1))
	e01:SetCategory(CATEGORY_EQUIP)
	e01:SetType(EFFECT_TYPE_QUICK_O)
	e01:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetRange(LOCATION_MZONE)
	e01:SetCountLimit(1,id)
	e01:SetTarget(s.eqtg)
	e01:SetOperation(s.eqop)
	c:RegisterEffect(e01)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(s.ctcost)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end

s.nightmare_setcode = my



function s.eqfilter(c)
	return c:IsSetCard(s.nightmare_setcode) and c:IsLevel(2) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_GRAVE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,0)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	local ec=g:GetFirst()
	if ec then
		if not Duel.Equip(tp,ec,tc,true) then return end
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetCode(EFFECT_EQUIP_LIMIT)
		e01:SetReset(RESET_EVENT+RESETS_STANDARD)
		e01:SetValue(s.eqlimit)
		ec:RegisterEffect(e01)
	end
end

function s.eqlimit(e,c)
	return true
end

function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsControlerCanBeChanged() and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,s.nightmare_setcode)
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.ctfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,s.ctfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.GetControl(tc,tp,PHASE_END,1)
	end
end