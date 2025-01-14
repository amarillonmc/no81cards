--粉红飞球
local m=13254067
local cm=_G["c"..m]
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	elements={{"tama_elements",{{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_CHAOS,1},{TAMA_ELEMENT_LIFE,1}}}}
	cm[c]=elements
	
end
function cm.cfilter(c)
	return #(tama.tamas_getElements(c))~=0 and c:IsAbleToDeckAsCost()
end
function cm.tdfilter1(c)
	return tama.tamas_getElementCount(c,TAMA_ELEMENT_ORDER)>0 and c:IsAbleToDeckAsCost()
end
function cm.tdfilter2(c)
	return tama.tamas_getElementCount(c,TAMA_ELEMENT_CHAOS)>0 and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.tdfilter2,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsReleasable,tp,0,LOCATION_MZONE,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local el={{TAMA_ELEMENT_ORDER,1},{TAMA_ELEMENT_CHAOS,1}}
	local mg=tama.tamas_checkGroupElements(Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_GRAVE,0,nil),el)
	local sg=tama.tamas_selectElementsMaterial(mg,el,tp)
	local sumEl=tama.tamas_sumElements(sg)
	local order=tama.tamas_getElementCount(sumEl,TAMA_ELEMENT_ORDER)
	local chaos=tama.tamas_getElementCount(sumEl,TAMA_ELEMENT_CHAOS)
	local ct=math.min(order,chaos)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0,LOCATION_MZONE,1,ct,nil)
	Duel.Release(g,REASON_COST)
end
