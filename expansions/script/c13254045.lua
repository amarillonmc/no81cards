--元始飞球秘术·元始
local m=13254045
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.remtg)
	e1:SetOperation(cm.remop)
	c:RegisterEffect(e1)
	elements={{"tama_elements",{{TAMA_ELEMENT_WIND,1},{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_WATER,1},{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_MANA,1}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_WIND,2},{TAMA_ELEMENT_EARTH,2},{TAMA_ELEMENT_WATER,2},{TAMA_ELEMENT_FIRE,2},{TAMA_ELEMENT_ORDER,2},{TAMA_ELEMENT_CHAOS,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el)
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function cm.remop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_DECK,nil)
	local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA,nil)
	local sg=Group.CreateGroup()
	local a=0
	if g1:GetCount()>0 and ((g2:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.HintSelection(sg1)
		sg:Merge(sg1)
		a=a+1
	end
	if g2:GetCount()>0 and ((sg:GetCount()==0 and g3:GetCount()==0) or Duel.SelectYesNo(tp,aux.Stringid(m,3))) then
		Duel.ConfirmCards(tp,g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg2=g2:Select(tp,1,1,nil)
		Duel.HintSelection(sg2)
		sg:Merge(sg2)
		a=a+2
	end
	if g3:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,aux.Stringid(m,4))) then
		Duel.ConfirmCards(tp,g3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg3=g3:Select(tp,1,1,nil)
		sg:Merge(sg3)
		a=a+4
	end
	Duel.Remove(sg,POS_FACEDOWN,REASON_EFFECT)
	if bit.band(a,1) then Duel.ShuffleHand(1-tp) end
	if bit.band(a,2) then Duel.ShuffleDeck(1-tp) end
	if bit.band(a,4) then Duel.ShuffleExtra(1-tp) end
end
