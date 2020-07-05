local m=82206044
local cm=_G["c"..m]
cm.name="植占师24-巨炮"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)  
	c:EnableReviveLimit() 
	--immune  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_IMMUNE_EFFECT)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(cm.imcon)  
	e1:SetValue(cm.efilter)  
	c:RegisterEffect(e1)   
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_MATERIAL_CHECK)  
	e2:SetValue(cm.valcheck)  
	e2:SetLabelObject(e1)  
	c:RegisterEffect(e2)  
	--destroy
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)  
	e3:SetType(EFFECT_TYPE_IGNITION)  
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetCountLimit(1)  
	e3:SetRange(LOCATION_MZONE)   
	e3:SetTarget(cm.des2tg)  
	e3:SetOperation(cm.des2op)  
	c:RegisterEffect(e3)  
end
function cm.valcheck(e,c)  
	local g=c:GetMaterial()  
	if g:IsExists(Card.IsSetCard,1,nil,0x129d) then  
		e:GetLabelObject():SetLabel(1)  
	else  
		e:GetLabelObject():SetLabel(0)  
	end  
end  
function cm.imcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1  
end  
function cm.efilter(e,te)  
	return not te:GetOwner():IsSetCard(0x29d)  
end  
function cm.des2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc~=c end  
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,0,1,c) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,0,1,99,c)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)  
end  
function cm.des2op(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)  
	local ct=Duel.Destroy(g,REASON_EFFECT)  
	if ct>0 and c:IsRelateToEffect(e) then 
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(ct*1200)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)  
		e2:SetType(EFFECT_TYPE_SINGLE)  
		e2:SetCode(EFFECT_EXTRA_ATTACK)  
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e2:SetValue(1)  
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e2) 
		local e3=Effect.CreateEffect(c)  
		e3:SetType(EFFECT_TYPE_SINGLE)  
		e3:SetCode(EFFECT_PIERCE)  
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e3)   
	end  
end  