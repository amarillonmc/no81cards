--银流秘术H·马克斯维尔熵增结界
local m=33701603
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Removed Summon
	--local e2=Effect.CreateEffect(c)
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetRange(LOCATION_GRAVE)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e2:SetCondition(aux.exccon)
	--e2:SetCost(aux.bfgcost)
	--e2:SetTarget(cm.target2)
	--e2:SetOperation(cm.activate2)
	--c:RegisterEffect(e2)
end
cm.toss_coin=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
   if chk==0 then return g:GetCount()>0 end
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_DISABLE,nil,0,tp,1)
   Duel.SetOperationInfo(0,CATEGORY_TOGRAVE+CATEGORY_DISABLE,g1,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin1=Duel.TossCoin(tp,1)
	if coin1==1 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		local tc1=g:GetFirst()
		if #g>0 and Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and not tc1:IsOnField() then
		Duel.BreakEffect()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(0,0x7f)
		e1:SetTarget(cm.distg)
		e1:SetLabelObject(tc1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon)
		e2:SetOperation(cm.disop)
		e2:SetLabelObject(tc1)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(0,LOCATION_MZONE)
		e3:SetTarget(cm.distg)
		e3:SetLabelObject(tc1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		end
	elseif coin1==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg2=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,0,1,1,nil)
		local tc2=sg2:GetFirst()
		if #sg2>0 and Duel.SendtoGrave(tc2,REASON_EFFECT)~=0 and not tc2:IsOnField() then
		Duel.BreakEffect()
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(0x7f,0)
		e1:SetTarget(cm.distg1)
		e1:SetLabelObject(tc2)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(cm.discon1)
		e2:SetOperation(cm.disop1)
		e2:SetLabelObject(tc2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(cm.distg1)
		e3:SetLabelObject(tc2)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		end
	end
end
function cm.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) and rp~=tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cm.distg1(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function cm.discon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule()) and rp==tp
end
function cm.disop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
--Removed Summon
