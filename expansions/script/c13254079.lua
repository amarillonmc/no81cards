--飞球之创星
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_ORDER,1}}}
	s[c]=elements
end
function s.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost() and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.thfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function s.thfilter1(c)
	return c:IsSetCard(0x356) and c:IsAbleToHand()
end
function s.rmfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToRemove()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local nocost=e:GetLabel()~=100
	local el={{TAMA_ELEMENT_WIND,2},{TAMA_ELEMENT_EARTH,2},{TAMA_ELEMENT_WATER,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil),el)
	local b1=mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el) and Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_DECK,1,nil)
	local b2=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(id,1)},
			{b2,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND)
		if not nocost then
			local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
			Duel.SendtoDeck(sg,nil,2,REASON_COST)
		end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			local g1=Duel.GetMatchingGroup(s.thfilter1,tp,LOCATION_DECK,0,nil)
			if g1:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g1:Select(tp,1,1,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
