local m=4879117
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_GRAVE_ACTION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m+1)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
end

function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return rp==tp and re:GetHandler():IsSetCard(0xae51) 
	and bit.band(loc,LOCATION_ONFIELD)==0
end
function cm.setfilter(c)
	return c:IsSetCard(0xae51) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsSSetable()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
	   Duel.SSet(tp,g:GetFirst())
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.thop1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	end
end
function cm.filter1(c)
	return c:IsSetCard(0xae51) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
 if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)

	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter1),tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
--function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
--end
--function cm.operation(e,tp,eg,ep,ev,re,r,rp)
 --   local e1=Effect.CreateEffect(e:GetHandler())
 --   e1:SetType(EFFECT_TYPE_FIELD)
 --   e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
 --   e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
 --   e1:SetTargetRange(LOCATION_MZONE,0)
 --   e1:SetTarget(cm.efftg)
 --   e1:SetValue(aux.tgoval)
 --   e1:SetReset(RESET_PHASE+PHASE_END)
  --  Duel.RegisterEffect(e1,tp)
--	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
--end
--function cm.efftg(e,c)
 --   return c:IsSetCard(0xc7)
--end