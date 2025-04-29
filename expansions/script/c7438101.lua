--背反之料理 前菜-日式猪肉角煮
local m=7438101
local cm=_G["c"..m]

cm.named_with_Crooked_Cook=1
cm.named_with_Crooked_Cook_Antipasto=1

function cm.Crooked_Cook(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_Crooked_Cook or c:IsCode(82697249))
end
function cm.Crooked_Cook_Antipasto(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Antipasto
end
function cm.Crooked_Cook_Soup(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Soup
end
function cm.Crooked_Cook_Enree(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Enree
end
function cm.Crooked_Cook_Main_Course(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Main_Course
end
function cm.Crooked_Cook_Salad(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Salad
end
function cm.Crooked_Cook_Dessert(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Dessert
end
function cm.Crooked_Cook_Drink(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Crooked_Cook_Drink
end

function cm.initial_effect(c)
	--act qp in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(cm.actcon)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--activate
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(m,1))
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e01:SetCode(EVENT_CHAIN_SOLVED)
	e01:SetRange(LOCATION_SZONE)
	e01:SetProperty(EFFECT_FLAG_DELAY)
	e01:SetCondition(cm.actcon2)
	e01:SetTarget(cm.acttg)
	e01:SetOperation(cm.actop)
	c:RegisterEffect(e01)
	local e02=e01:Clone()
	e02:SetCode(7438201)
	c:RegisterEffect(e02)
	--destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_DESTROYED)
	--e2:SetCountLimit(1,m)
	e2:SetCondition(cm.descon)
	e2:SetOperation(cm.desop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function cm.confilter(c)
	return cm.Crooked_Cook(c) and c:IsFaceup()
end
function cm.actcon(e)
	return Duel.IsExistingMatchingCard(cm.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.thfilter(c)
	return cm.Crooked_Cook(c) and c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	Duel.RegisterEffect(e1,tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()+1 and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.actcon2(e,tp,eg,ep,ev,re,r,rp)
	--[[if re then Debug.Message("01") end
	if re and re:GetHandler()==e:GetHandler() then Debug.Message("02") end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then Debug.Message("03") end]]
	return re and re:GetHandler()==e:GetHandler() and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.actfilter(c,tp)
	return c:IsType(TYPE_SPELL) and cm.Crooked_Cook_Soup(c) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	--[[if Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE,0,1,nil) then Debug.Message("04") end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then Debug.Message("05") end]]
	if chk==0 then return Duel.IsExistingMatchingCard(cm.actfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.actfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		--Duel.RaiseEvent(tc,7438201,te,0,tep,tep,Duel.GetCurrentChain())
		Duel.RaiseEvent(tc,7438201,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--[[--poschange
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(POS_FACEUP_ATTACK)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)]]
	--must attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_MUST_ATTACK)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--client
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	e3:SetDescription(aux.Stringid(m,5))
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,1-tp)
end
