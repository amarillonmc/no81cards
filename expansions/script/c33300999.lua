--天界主宰 终月蚀世尊主
local cm, m = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ff1,4,false)
	c:EnableReviveLimit()
	aux.AddContactFusionProcedure(c,cm.ff2,LOCATION_EXTRA,0,Duel.Remove,POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(16 * m)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCost(cm.cos3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(16 * m + 1)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.cos4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
function cm.ff1(c,fc,sub,mg,sg)
	return c.CelestialPillars and c:IsFusionType(TYPE_MONSTER)
		and not (sg and sg:IsExists(Card.IsFusionCode, 1, c, c:GetFusionCode()))
end
function cm.ff2(c,fc)
	return c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
--e3
function cm.cos3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local p = Duel.GetTurnPlayer()
	if Duel.GetDrawCount(p) > 0 then
		e:SetLabel(1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,p)
	else
		e:SetLabel(0)
	end
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local p = Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,p,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,p,LOCATION_DECK)
	Duel.SetChainLimit(aux.FALSE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel() ~= 1 then return end
	local p = Duel.GetTurnPlayer()
	local g = Duel.GetFieldGroup(p, LOCATION_DECK, 0)
	Duel.ConfirmCards(tp, g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	g = g:Select(tp, 1, 2, nil)
	if #g == 0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1 - p, g)
end
--e4
function cm.cos4op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function cm.cos4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,0,REASON_COST+REASON_TEMPORARY) == 0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetLabelObject(c)
	e1:SetCountLimit(1)
	e1:SetOperation(cm.cos4op1)
	c:RegisterEffect(e1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end