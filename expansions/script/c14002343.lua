--宇宙王女 夜刀浦罗
local m=14002343
local cm=_G["c"..m]
cm.named_with_Urara=1
function cm.initial_effect(c)
	-- Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(2,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--Repeat
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.chcon1)
	e2:SetOperation(cm.chop1)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.chcon2)
	e3:SetOperation(cm.chop2)
	c:RegisterEffect(e3)
end
function cm.Hastur(c)
	local m_code=_G["c"..c:GetCode()]
	return m_code and m_code.named_with_Hastur
end
function cm.hafilter(c)
	return (cm.Hastur(c) and c:IsFaceup()) or c:IsType(TYPE_TOKEN)
end
function cm.chcon1(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	if not ce or not ce:CheckCountLimit(tp) then return false end
	if ep~=tp or not re:IsActiveType(TYPE_MONSTER) then return false end
	local rc=re:GetHandler()
	if not rc or not cm.Hastur(rc) then return false end
	local ct=Duel.GetMatchingGroupCount(cm.hafilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return ct>=5
end
function cm.chop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(m,0)) then
		local ce=e:GetLabelObject()
		ce:UseCountLimit(tp, 1)
		Duel.Hint(HINT_CARD,0,m)
		Duel.RegisterFlagEffect(0,m+ev,RESET_CHAIN,0,1)
	end
end
function cm.chcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,m+ev)>0
end
function cm.chop2(e,tp,eg,ep,ev,re,r,rp)
	local old_op=re:GetOperation()
	if old_op then
		Duel.ChangeChainOperation(ev,function(e_new,tp_new,eg_new,ep_new,ev_new,re_new,r_new,rp_new)
			old_op(e_new,tp_new,eg_new,ep_new,ev_new,re_new,r_new,rp_new)
			old_op(e_new,tp_new,eg_new,ep_new,ev_new,re_new,r_new,rp_new)
		end)
	end
end
function cm.tgfilter(c)
	return cm.Hastur(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end