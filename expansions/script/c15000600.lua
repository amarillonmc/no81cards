local m=15000600
local cm=_G["c"..m]
cm.name="幻智指令·钙质化"
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,0))
	--e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	--e1:SetType(EFFECT_TYPE_ACTIVATE)
	--e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	--e1:SetTarget(cm.target)
	--e1:SetOperation(cm.activate)
	--c:RegisterEffect(e1)
	--cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm[0]={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if re then table.insert(cm[0],re) end
end
function cm.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0 or (Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1 and Duel.GetFieldGroup(e:GetHandlerPlayer(),LOCATION_MZONE,0):GetFirst():IsSetCard(0xf36))
end
function cm.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf36) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.damval2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(cm.damcon)
	Duel.RegisterEffect(e4,tp)
end
function cm.splimit(e,c)
	return not c:IsRace(RACE_PSYCHO)
end
function cm.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0 then
		Duel.RegisterFlagEffect(e:GetHandlerPlayer(),m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function cm.damcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=true
	local b2=(Duel.GetLP(tp)>2000 and Duel.IsExistingMatchingCard(cm.tg2filter,tp,LOCATION_DECK,0,1,nil))
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,0)},
		{b2,aux.Stringid(m,1)})
	if op==2 then
		local lp=Duel.GetLP(tp)
		Duel.PayLPCost(tp,lp-2000)
	end
end
function cm.tg2filter(c)
	return c:IsSetCard(0xf36) and c:IsAbleToHand() and not c:IsCode(m)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local b=0
	for _,v in ipairs(cm[0]) do
		if v==e then
			b=1
			break
		end
	end
	local b1=true
	local b2=(Duel.GetLP(tp)>2000 and e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsExistingMatchingCard(cm.tg2filter,tp,LOCATION_DECK,0,1,nil))
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	if b==0 then
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
		e:SetLabel(1)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
	if b==1 then
		e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
		e:SetLabel(2)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local ag=Duel.SelectMatchingCard(tp,cm.tg2filter,tp,LOCATION_DECK,0,1,1,nil)
		if ag:GetCount()>0 then
			Duel.SendtoHand(ag,nil,REASON_EFFECT)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--damage reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetTargetRange(1,0)
	e3:SetValue(cm.damval2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e4:SetCondition(cm.damcon)
	Duel.RegisterEffect(e4,tp)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b=e:GetLabel()
	if b==1 then cm.activate(e,tp,eg,ep,ev,re,r,rp) end
	if b==2 then cm.activate2(e,tp,eg,ep,ev,re,r,rp) end
end