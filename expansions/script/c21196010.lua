--群星的寓言
local m=21196010
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
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
cm.settype_amp=true
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if in_count[tp] >= 2 and Duel.IsExistingMatchingCard(cm.q,tp,1,0,2,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
	e:SetLabel(1)
	in_count.add(tp,-2)
	end
end
function cm.q(c)
	return c:IsAbleToHand() and c:IsType(1) and c:IsSetCard(0x5919)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.q,tp,1,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,x,tp,1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local x=1+e:GetLabel()
	Duel.Hint(3,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.q,tp,1,0,1,x,nil)
	if #g>0 then 
	Duel.SendtoHand(g,nil,REASON_EFFECT) 
	Duel.ConfirmCards(1-tp,g)
	end
	if x>1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(73478096,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5919))
	Duel.RegisterEffect(e1,tp)	
	end
end