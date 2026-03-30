--方舟骑士团-蕾缪安
local m=29025824
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(cm.syncheck1),nil,nil,cm.sfilter,1,99)
	c:EnableReviveLimit()   
	--cannot release
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_RELEASE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetTarget(cm.etg)
	c:RegisterEffect(e1)
	--reduce battle damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(cm.damval2)
	c:RegisterEffect(e3)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.descost)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.sfilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
end
function cm.syncheck1(c)
	return c:IsRace(RACE_FAIRY)
end
function cm.cocheck(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:IsControler(tp)
end
function cm.etg(e,c)
	local lg=c:GetColumnGroup()
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(1-e:GetHandlerPlayer()) and lg and lg:IsExists(cm.cocheck,1,nil,e:GetHandlerPlayer())
end
function cm.descost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanAddCounter(0x17af,1) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	c:AddCounter(0x17af,3)
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then
		if e:IsCostChecked() then
			return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil)
		else
			return e:GetHandler():GetCounter(0x17af)>0
				and Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) 
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,e:GetHandler():GetCounter(0x17af),nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(Card.IsRelateToEffect,nil,e)
	local ct=c:GetCounter(0x17af)
	if c:IsFaceup() and ct>0 then
		c:RemoveCounter(tp,0x17af,ct,REASON_EFFECT)
		Duel.RaiseEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,ct)
		Duel.RaiseSingleEvent(c,EVENT_REMOVE_COUNTER+0x17af,e,REASON_EFFECT,tp,tp,ct)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function cm.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE)~=0 then
		local tc=Duel.GetAttacker()
		local tc2=Duel.GetAttackTarget()
		if (tc and tc:IsControler(1-e:GetHandlerPlayer()) and cm.etg(e,tc) and not tc:IsImmuneToEffect(e)) or (tc2 and tc2:IsControler(1-e:GetHandlerPlayer()) and cm.etg(e,tc2) and not tc2:IsImmuneToEffect(e)) then
			return val*2
		end
	end
	return val
end