local m=53721012
local cm=_G["c"..m]
cm.name="在未知之蓝面前"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.sumop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.actcon)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,tp)
	end
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsAttribute(ATTRIBUTE_WATER)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil) then
		Duel.RegisterFlagEffect(e:GetHandler():GetControler(),m,0,0,1)
		e:Reset()
	end
end
function cm.thfilter(c)
	return c:IsSetCard(0xa531) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tdfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsAbleToDeck()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g1:GetFirst()
	Duel.DisableShuffleCheck()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		Duel.ShuffleDeck(tp)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local tg=sg:Select(tp,1,1,nil)
			Duel.HintSelection(tg)
			Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
		end
	end
end
function cm.actcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)==0
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetTargetRange(0,0xff)
	e3:SetCondition(cm.costcon)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop1)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SPSUMMON_COST)
	e4:SetTargetRange(0,0xff)
	e4:SetCondition(cm.costcon)
	e4:SetCost(cm.costchk)
	e4:SetOperation(cm.costop2)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetLabelObject(e3)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CUSTOM+m)
	e5:SetOperation(cm.costop3)
	e5:SetReset(RESET_PHASE+PHASE_END)
	e5:SetLabelObject(e4)
	Duel.RegisterEffect(e5,tp)
end
function cm.cfilter(c)
	return c:IsSetCard(0xa531) and c:IsRace(RACE_FISH) and c:IsAbleToDeckAsCost()
end
function cm.costcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.cfilter),e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function cm.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.cfilter),e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil)
end
function cm.costop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.cfilter),tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.ConfirmCards(tp,sg)
	Duel.SendtoDeck(sg,nil,0,REASON_COST)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+m,e,0,0,0,0)
	e:Reset()
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.cfilter),tp,0,LOCATION_GRAVE,1,1,nil)
	Duel.ConfirmCards(tp,sg)
	Duel.SendtoDeck(sg,nil,0,REASON_COST)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.costop3(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
