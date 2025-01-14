--飞球造物·钢屑球
local m=13254064
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1},{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_FIRE,1},{TAMA_ELEMENT_EARTH,0}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
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
function cm.desfilter(c,ec,ct)
	return c:IsAttackBelow(ec:GetAttack()+ct*200)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local ct,ct1=e:GetLabel()
	local loc=0
	if ct<3 then loc=LOCATION_MZONE end
	local sg=Duel.GetMatchingGroup(cm.desfilter,tp,loc,LOCATION_MZONE,nil,c,ct1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct,ct1=e:GetLabel()
	local loc=0
	if ct<3 then loc=LOCATION_MZONE end
	local sg=Duel.GetMatchingGroup(cm.desfilter,tp,loc,LOCATION_MZONE,nil,c,ct1)
	Duel.Destroy(sg,REASON_EFFECT)
end
