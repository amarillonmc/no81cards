--甲虫装机 吉咖大黄蜂
function c98920385.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),3,2)
	c:EnableReviveLimit()
--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920385,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920385)
	e1:SetCondition(c98920385.eqcon)
	e1:SetTarget(c98920385.eqtg)
	e1:SetOperation(c98920385.eqop)
	c:RegisterEffect(e1)
--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920385,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930385)
	e3:SetCost(c98920385.descost)
	e3:SetTarget(c98920385.destg)
	e3:SetOperation(c98920385.desop)
	c:RegisterEffect(e3)
end
function c98920385.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920385.eqfilter(c,ec)
	return c:IsRace(RACE_INSECT) and not c:IsForbidden()
end
function c98920385.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c98920385.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c98920385.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup()
		and c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c98920385.eqfilter,tp,LOCATION_DECK,0,1,1,nil,c)
		if g:GetCount()>0 then
			Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(c98920385.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			g:GetFirst():RegisterEffect(e2)
		end
	end
end
function c98920385.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c98920385.tgfilter(c,tp)
	return c:IsAbleToGraveAsCost()
end
function c98920385.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c98920385.tgfilter,1,nil,tp) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)  
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c98920385.tgfilter,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)   
end
function c98920385.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c98920385.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end