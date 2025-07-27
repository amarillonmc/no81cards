--皇庭学院的学员
local m=21196005
local cm=_G["c"..m]
function cm.initial_effect(c)
	if not imperial_court then
		imperial_court=true
		Duel.LoadScript("c21196001.lua")
		in_count.card = c
		local ce1=Effect.CreateEffect(c)
		ce1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ce1:SetCode(EVENT_PHASE+PHASE_END)
		ce1:SetCountLimit(1)
		ce1:SetOperation(function(e)
			for tp = 0,1 do
				if not Duel.IsPlayerAffectedByEffect(tp,21196000) then
					in_count.reset(tp)
				end
			end
		end)
		Duel.RegisterEffect(ce1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)	
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return in_count[tp] < 8 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	in_count.add(tp,3)
end
function cm.q(c)
	return c:IsType(TYPE_SPELL) and c:IsFaceup()
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.q,tp,12,0,1,nil)
end
function cm.w(c)
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x5919) and c.settype_amp
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.w,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,1)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.w,tp,1,0,1,1,nil)
	if #g>0 then 
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
	end
end