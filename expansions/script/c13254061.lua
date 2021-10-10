--飞球造物·隐飞球
local m=13254061
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(cm.discost1)
	e2:SetTarget(cm.distg1)
	e2:SetOperation(cm.disop1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCost(cm.discost2)
	e3:SetCondition(cm.discon2)
	e3:SetTarget(cm.distg2)
	e3:SetOperation(cm.disop2)
	c:RegisterEffect(e3)
	elements={{"tama_elements",{{TAMA_ELEMENT_EARTH,1}}}}
	cm[c]=elements
	
end
function cm.spfilter(c)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_EARTH) and c:IsAbleToDeckAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_MZONE,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tdfilter1(c)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_CHAOS) and c:IsAbleToDeckAsCost()
end
function cm.discost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,tp,2,REASON_COST)
end
function cm.distg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 and Duel.IsPlayerCanDiscardDeck(tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
end
function cm.tdfilter2(c)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_FIRE) and c:IsAbleToDeckAsCost()
end
function cm.discost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(cm.tdfilter2,tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,cm.tdfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g,tp,2,REASON_COST)
		e:SetLabel(1)
	end
end
function cm.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()
end
function cm.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=3
	local op=e:GetLabel()
	if Duel.GetAttackTarget()==nil then ct=5 end
	if op>0 then ct=ct*2 end
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,ct)
end
function cm.disop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=3
	local op=e:GetLabel()
	if Duel.GetAttackTarget()==nil then ct=5 end
	if op>0 then ct=ct*2 end
	Duel.DiscardDeck(tp,ct,REASON_EFFECT)
end
