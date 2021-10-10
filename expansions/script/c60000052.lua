--普兰妮 血月来客
local m=60000052
local cm=_G["c"..m]
function cm.initial_effect(c)
    aux.AddCodeList(c,60000043)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--duel lose lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtarget)
	e2:SetOperation(cm.thoperation)
	c:RegisterEffect(e2)
	--resurrection  summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.cost1)
	e5:SetCondition(cm.spcon3)
	e5:SetTarget(cm.sptg3)
	e5:SetOperation(cm.spop3)
	c:RegisterEffect(e5)
	--removed
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCondition(function(e)
		return e:GetHandler():IsFaceup()
	end)
	e6:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e6)
	if cm.activate_check~=true then
		cm.activate_check=true
		Tab_for_Hai_Activate_Times={0,0}
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(cm.regcon)
		e1:SetOperation(cm.regop1)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_NEGATED)
		e2:SetCondition(cm.regcon)
		e2:SetOperation(cm.regop2)
		Duel.RegisterEffect(e2,0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x628)
end
function cm.regop1(e,tp,eg,ep,ev,re,r,rp)
	Tab_for_Hai_Activate_Times[rp+1]=Tab_for_Hai_Activate_Times[rp+1]+1
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local ct=Tab_for_Hai_Activate_Times[rp+1]
	if ct==0 then return end
	Tab_for_Hai_Activate_Times[rp+1]=Tab_for_Hai_Activate_Times[rp+1]-1
end
--to hand
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.filter(c)
	return c:IsSetCard(0x628) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetCode(EFFECT_UPDATE_LEVEL)
			  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			  e1:SetValue(-5)
			  c:RegisterEffect(e1)
	end
end
--duel lose lp
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHandAsCost() end
	Duel.SendtoHand(c,tp,REASON_COST)
end
function cm.thtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Tab_for_Hai_Activate_Times[tp+1]>0 end
end
function cm.thoperation(e,tp,eg,ep,ev,re,r,rp)
	local num=Tab_for_Hai_Activate_Times[tp+1]
	local lp=Duel.GetLP(1-tp)
	if lp<num*100 then
		Duel.SetLP(1-tp,0)
	else
		Duel.SetLP(1-tp,lp-num*100)
	end
end
--resurrection  summon--
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60000052)==0 end
	Duel.RegisterFlagEffect(tp,60000052,RESET_CHAIN,0,1)
end
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsCode(60000043)
end
function cm.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)
	end
end