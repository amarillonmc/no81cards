--Kemurikusa - 保存之『橙』
local m=33709008
local cm=_G["c"..m]
function cm.initial_effect(c)
   --
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1)
	e0:SetCondition(cm.condition)
	e0:SetOperation(cm.operation)
	c:RegisterEffect(e0)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,m)==0 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(m,1)) and Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
		Duel.RaiseEvent(e:GetHandler(),33709003,re,r,rp,ep,ev)
	end
end
function cm.check(c)
	local code=c:GetOriginalCode()
	return code>=33709004 and code<=33709009 and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.check,tp,LOCATION_DECK,0,1,1,nil)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	tg:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.spcon)
	e1:SetLabelObject(tg)
	e1:SetOperation(cm.spop)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
	   e1:SetCondition(cm.spcon2)
	   e1:SetLabel(Duel.GetTurnCount())
	end
	Duel.RegisterEffect(e1,tp)
end
function cm.spfilter(c)
	local code=c:GetOriginalCode()
	return code>=33709004 and code<=33709009 and c:IsAbleToHand()
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)>0 and tc:IsAbleToHand() then
		sg:AddCard(tc)
	end
	sg:Merge(g)
	return Duel.GetTurnCount()>e:GetLabel() and Duel.GetTurnPlayer()==tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local sg=Group.CreateGroup()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(m)>0 and tc:IsAbleToHand() then
		sg:AddCard(tc)
	end
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local rg=sg:Select(tp,1,1,nil)
		Duel.SendtoHand(rg,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
	e:Reset()
end
