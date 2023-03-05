--微小的和平
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cos1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	if not cm.glo then
		cm.op2()
		for i,cod in pairs({EVENT_PHASE_START+PHASE_DRAW,EVENT_TO_HAND,EVENT_DAMAGE}) do
			local e=Effect.CreateEffect(c)
			e:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e:SetCode(cod)
			e:SetOperation(cm["op"..i+1])
			Duel.RegisterEffect(e,0)
		end
	end
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK):IsExists(Card.IsControler,1,nil,1-tp)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetOperation(cm.op1op1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.op1op2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.op1op1(e,tp,eg,ep,ev,re,r,rp)
	if not eg:Filter(Card.IsPreviousLocation,nil,LOCATION_DECK):IsExists(Card.IsControler,1,nil,1-tp) then return end
	Duel.Damage(1-tp,200,REASON_EFFECT)
	Debug.Message(cm.glo[2-tp])
end
function cm.op1op2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(cm.glo[2-tp])
	if Duel.Damage(1-tp,cm.glo[2-tp]*200,REASON_EFFECT)>0 and (cm.glo[4-tp]//1000)>0 and Duel.IsPlayerCanDraw(tp,cm.glo[4-tp]//1000) then 
		Duel.BreakEffect()
		Duel.Draw(tp,cm.glo[4-tp]//1000,REASON_EFFECT)
	end
end
--e2
function cm.op2()
	cm.glo = {0,0,0,0}
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	cm.glo[ep+1] = cm.glo[ep+1] + eg:FilterCount(Card.IsControler,nil,ep)
end
--e4
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	cm.glo[ep+3] = cm.glo[ep+3] + ev
end