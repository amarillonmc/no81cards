--狂风箭矢
local m=40009164
local cm=_G["c"..m]
cm.named_with_BLASTER=1
function cm.BLASTERBlade(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BLASTERBlade
end
function cm.initial_effect(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)   

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)   
	local e4=e3:Clone()
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	c:RegisterEffect(e4) 
end
function cm.filter(c)
	return cm.BLASTERBlade(c) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) and Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then return end
	if Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
	if Duel.GetFlagEffect(tp,m)==0 then 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,3))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WARRIOR))
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end

function cm.cfilter(c)
	return cm.BLASTERBlade(c) and c:IsAbleToDeckAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Release(e:GetHandler(),REASON_COST)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.setfilter(c)
	return c:IsCode(40009261) and c:IsSSetable()
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end