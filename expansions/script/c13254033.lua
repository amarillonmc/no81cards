--元始飞球·蓝
local m=13254033
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost1)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	elements={"tama_elements",{{13254033,1}}}
	cm[c]=elements
	
end
function cm.rmfilter(c)
	return c:IsSetCard(0x356) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)>0 and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_REMOVED,LOCATION_REMOVED)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=g:Select(tp,1,2,nil)
	local ct=Duel.SendtoGrave(g1,REASON_EFFECT)
	if ct>0 and Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,ct,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK,0,ct,ct,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{13254033,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	local sg=Group.CreateGroup()
	if chk==0 then 
		return mg:GetCount()>0 and mg:IsExists(tama.tamas_selectElementsForAbove,1,nil,mg,sg,el)
	end
	local sg=tama.tamas_selectAllSelectForAbove(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.rmfilter1(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_EXTRA) and cm.rmfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfilter1,tp,0,LOCATION_EXTRA,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectTarget(tp,cm.rmfilter1,tp,0,LOCATION_EXTRA,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,1-tp,LOCATION_ONFIELD)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	if Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==2 then
		local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_REMOVED,nil)
		if sg:GetCount()>=2 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg1=sg:Select(tp,2,2,nil)
			Duel.SendtoDeck(sg1,nil,2,REASON_EFFECT)
		end
	end
end
