 local m=82204266
local cm=_G["c"..m]
cm.name="法力翡翠"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)  
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--dr 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetRange(LOCATION_SZONE)  
	e2:SetCountLimit(1,m)  
	e2:SetCondition(cm.drcon)  
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)  
	c:RegisterEffect(e2) 
	--remove  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_REMOVE)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e3:SetCountLimit(1,m)  
	e3:SetTarget(cm.rmtg)  
	e3:SetOperation(cm.rmop)  
	c:RegisterEffect(e3)  
end
function cm.cfilter(c,tp)  
	return c:IsFaceup() and c:IsSetCard(0x5299) and c:IsControler(tp)  
end  
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.cfilter,1,nil,tp)  
end  
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(1)  
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end  
function cm.drop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Draw(p,d,REASON_EFFECT)  
end  
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end  
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)  
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then  
		tc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)  
		e1:SetCode(EVENT_PHASE+PHASE_END)  
		e1:SetReset(RESET_PHASE+PHASE_END)  
		e1:SetLabelObject(tc)  
		e1:SetCountLimit(1)  
		e1:SetCondition(cm.retcon)  
		e1:SetOperation(cm.retop)  
		Duel.RegisterEffect(e1,tp)  
	end  
end  

function cm.retcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetLabelObject():GetFlagEffect(m)~=0  
end  
function cm.retop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.ReturnToField(e:GetLabelObject())  
end 