local m=53722008
local cm=_G["c"..m]
cm.name="大祭环 大生杀环"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,11,2,nil,nil,99)
--  local e1=Effect.CreateEffect(c)
--  e1:SetDescription(aux.Stringid(m,1))
--  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
--  e1:SetCode(EVENT_FREE_CHAIN)
--  e1:SetRange(LOCATION_MZONE)
--  e1:SetCondition(cm.descon)
--  e1:SetOperation(cm.desop)
--  c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.effop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.recon)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,aux.FALSE)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end
--function cm.descon(e,tp,eg,ep,ev,re,r,rp)
--  local tp=e:GetHandler():GetControler()
--  local ph=Duel.GetCurrentPhase()
--  return Duel.GetCurrentChain()==0 and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
--end
--function cm.desop(e,tp,eg,ep,ev,re,r,rp)
--  Duel.Hint(HINT_CARD,0,m)
--  Duel.Destroy(e:GetHandler(),REASON_EFFECT)
--end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	for tc in aux.Next(mg) do
		local code=tc:GetOriginalCode()
		if code>53722000 and code<53722008 and c:GetFlagEffect(code)==0 and ((not g) or (not g:IsExists(cm.tgfil,1,nil,tp))) then
			c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
			c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,code-53722000))
		end
	end
end
function cm.filter(c)
	return c:IsSetCard(0x3531) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local rt=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_DECK,0,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,e:GetLabel(),tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,e:GetLabel()*800)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if #g<ct then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,ct,ct,nil)
	if #sg>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
