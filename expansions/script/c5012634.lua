--安娜·金斯福德
local cm,m,o=GetID()
local s,id,o=GetID()
s.MoJin=true
function cm.initial_effect(c)
	--aux.AddSynchroProcedure(c,s.sfliter,aux.NonTuner(nil),1)
	aux.AddSynchroProcedure(c,cm.fil1,cm.fil2,2)
	c:EnableReviveLimit()
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCost(cm.rmcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
function s.sfliter(c)
	return c.MoJin==true 
end
function cm.fil1(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) and c.Mojin==true
end
function cm.fil2(c)
	return c:IsFaceup() --and not c:IsType(TYPE_TUNER)
end
function cm.rmfil(c)
	return c:IsFaceup() and c:IsStatus(STATUS_EFFECT_ENABLED)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+10000000)<Duel.GetFlagEffect(tp,m)+1 end
	Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(cm.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,cm.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if tc:IsLocation(LOCATION_PZONE) then
			Duel.SendtoDeck(tc,nil,2,REASON_RULE)
			Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_SZONE) then
			if Duel.ChangePosition(tc,POS_FACEDOWN)==0 then
				Duel.SendtoDeck(tc,nil,2,REASON_RULE)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
		else
			if Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)==0 then
				Duel.SendtoDeck(tc,nil,2,REASON_RULE)
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
			end
		end
	end
end
function cm.efilter(e,re)
	return re:GetHandler():IsLocation(LOCATION_ONFIELD)
end








