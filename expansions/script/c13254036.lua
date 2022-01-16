--元始飞球·黑
local m=13254036
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.smcost)
	e2:SetTarget(cm.smtg)
	e2:SetOperation(cm.smop)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_CHAOS,2}}}}
	cm[c]=elements
	
end
function cm.cfilter(c,tp)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_CHAOS) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) and Duel.IsPlayerCanDraw(tp,2))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		e:SetLabel(1)
	else e:SetLabel(0) end
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==1 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if e:GetLabel()==1 then
		e:SetCategory(bit.bor(e:GetCategory(),CATEGORY_DRAW))
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	if e:GetLabel()==1 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function cm.tdfilter(c)
	return c:IsAbleToDeckAsCost() and tama.tamas_isExistElement(c,TAMA_ELEMENT_CHAOS)
end
function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g,tp,2,REASON_COST)
end
function cm.smfilter(c)
	return c:IsSetCard(0x3356) and c:IsSummonable(true,nil)
end
function cm.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.smfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.smop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.smfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
