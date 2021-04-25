--元始飞球·白
local m=13254035
local cm=_G["c"..m]
xpcall(function() require("expansions/script/tama") end,function() require("script/tama") end)
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
	elements={{"tama_elements",{{TAMA_ELEMENT_ORDER,2}}}}
	cm[c]=elements
	
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.dFilter,tp,LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.dFilter(c)
	return tama.tamas_isExistElement(c,TAMA_ELEMENT_ORDER)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.DiscardHand(tp,cm.dFilter,1,2,REASON_EFFECT+REASON_DISCARD)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local el={{TAMA_ELEMENT_ORDER,2}}
	local mg=tama.tamas_checkGroupElements(Duel.GetFieldGroup(tp,LOCATION_GRAVE,0),el)
	local sg=Group.CreateGroup()
	if chk==0 then 
		return mg:GetCount()>0 and mg:IsExists(tama.tamas_selectElementsForAbove,1,nil,mg,sg,el)
	end
	local sg=tama.tamas_selectAllSelectForAbove(mg,el,tp)
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(p,0,LOCATION_ONFIELD+LOCATION_HAND)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		Duel.ShuffleHand(1-tp)
	end
	local e11=Effect.CreateEffect(e:GetHandler())
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_PUBLIC)
	e11:SetTargetRange(LOCATION_HAND,0)
	e11:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e11,1-tp)
	local e12=Effect.CreateEffect(e:GetHandler())
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_CANNOT_SSET)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetTargetRange(1,0)
	e12:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e12,1-tp)
	local e13=e12:Clone()
	e13:SetCode(EFFECT_CANNOT_MSET)
	Duel.RegisterEffect(e13,1-tp)
end
