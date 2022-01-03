--元素飞球之暴雨
local m=13254065
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_RECOVER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	elements={{"tama_elements",{{TAMA_ELEMENT_WATER,1}}}}
	cm[c]=elements
	
end
function cm.disfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsSetCard(0x356)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.disfilter,tp,LOCATION_HAND,0,1,nil) end
	local ct=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,ct,tp,LOCATION_HAND)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.disfilter,tp,LOCATION_HAND,0,nil)
	local c=e:GetHandler()
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_EFFECT)
	local sg1=Duel.GetOperatedGroup()
	if sg1:GetCount()<=0 then return end
	local j=1
	if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_ORDER)>=1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
		j=j+1
	end
	if (sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_WATER)+sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_WIND))>=1 then
		Duel.SelectOption(tp,aux.Stringid(m,2))
		for i=1,j do
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
	if (sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_EARTH)+sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_ENERGY))>=1 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) then
		Duel.SelectOption(tp,aux.Stringid(m,3))
		for i=1,j do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				if Duel.Destroy(g,REASON_EFFECT)>0 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
	if (sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_FIRE)+sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_ENERGY))>=1 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) then
		Duel.SelectOption(tp,aux.Stringid(m,4))
		for i=1,j do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				if Duel.Destroy(g,REASON_EFFECT)>0 then
					Duel.Draw(tp,1,REASON_EFFECT)
				end
			end
		end
	end
	if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_LIFE)>=1 then
		Duel.SelectOption(tp,aux.Stringid(m,5))
		for i=1,j do
			Duel.BreakEffect()
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
	if sg1:GetSum(tama.tamas_getElementCount,TAMA_ELEMENT_CHAOS)>=1 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		Duel.SelectOption(tp,aux.Stringid(m,6))
		Duel.ConfirmCards(tp,g)
		for i=1,j do
			local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
			if g:GetCount()>0 then
				Duel.BreakEffect()
				Duel.ConfirmCards(tp,g)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=g:Select(tp,1,1,nil)
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ShuffleDeck(1-tp)
			end
		end
		Duel.ShuffleDeck(1-tp)
	end
end
