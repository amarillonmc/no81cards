--飞球造物·钢屑球
local s,id,o=GetID()
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(s.condition1)
	e2:SetCost(s.cost1)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.operation1)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_LIFE,1}}}}
	s[c]=elements
	
end
function s.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_EARTH,0}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	if chk==0 then 
		return mg:GetCount()>0 and tama.tamas_isCanSelectElementsForAbove(mg,el) and e:GetHandler():IsAbleToGraveAsCost()
	end
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	local ct=tama.tamas_getElementCount(tama.tamas_sumElements(sg),TAMA_ELEMENT_FIRE)
	local ct1=tama.tamas_getElementCount(tama.tamas_sumElements(sg),TAMA_ELEMENT_EARTH)-0
	e:SetLabel(ct,ct1)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.desfilter(c,ec,ct)
	return c:IsAttackBelow(ec:GetAttack()+ct*1200)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ct,ct1=e:GetLabel()
	local loc=0
	if ct<3 then loc=LOCATION_MZONE end
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,loc,LOCATION_MZONE,nil,c,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,ct1=e:GetLabel()
	local loc=0
	if ct<3 then loc=LOCATION_MZONE end
	local sg=Duel.GetMatchingGroup(s.desfilter,tp,loc,LOCATION_MZONE,nil,c,ct1)
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.desfilter1(c,ec)
	return c:IsAttackBelow(ec:GetAttack())
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 end
	local sg=Duel.GetMatchingGroup(s.desfilter1,tp,0,LOCATION_MZONE,nil,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.tgfilter(c)
	return (tama.tamas_isExistElement(c,TAMA_ELEMENT_FIRE) or tama.tamas_isExistElement(c,TAMA_ELEMENT_EARTH)) and c:IsAbleToGrave()
end
function s.desfilter2(c,ec,ct)
	return c:IsAttackBelow(ec:GetAttack()+ct*200)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,5) then return end
	Duel.ConfirmDecktop(tp,5)
	local g=Duel.GetDecktopGroup(tp,5)
	local ct=g:GetCount()
	local ctF=0
	local ctE=0
	if ct>0 then
		Duel.DisableShuffleCheck()
		local sg=g:Filter(s.tgfilter,nil)
		if sg:GetCount()>0 then
			ctF=tama.tamas_getElementCount(tama.tamas_sumElements(sg),TAMA_ELEMENT_FIRE)
			ctE=tama.tamas_getElementCount(tama.tamas_sumElements(sg),TAMA_ELEMENT_EARTH)
			Duel.SendtoGrave(sg,REASON_EFFECT+REASON_REVEAL)
			ct=ct-sg:GetCount()
		end
	end
	if ct>0 then
		Duel.SortDecktop(tp,tp,ct)
		for i=1,ct do
			local mg=Duel.GetDecktopGroup(tp,1)
			Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
	end
	local loc=0
	if ct<3 then loc=LOCATION_MZONE end
	local sg=Duel.GetMatchingGroup(s.desfilter2,tp,loc,LOCATION_MZONE,nil,c,ct1)
	Duel.Destroy(sg,REASON_EFFECT)
end
