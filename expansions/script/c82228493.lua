local m=82228493
local cm=_G["c"..m]
cm.name="地之精灵王 莱茵哈特·混沌"
function cm.initial_effect(c)
	--link summon  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)  
	c:EnableReviveLimit()  
	--remove  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_REMOVE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(cm.rmcon)  
	e1:SetTarget(cm.rmtg)  
	e1:SetOperation(cm.rmop)  
	c:RegisterEffect(e1)  
	--atk up
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)  
	e2:SetCode(EVENT_REMOVE)  
	e2:SetCountLimit(1)  
	e2:SetCondition(cm.atkcon)   
	e2:SetTarget(cm.atktg)  
	e2:SetOperation(cm.atkop)  
	c:RegisterEffect(e2)  
end
function cm.cfilter(c,zone)  
	local seq=c:GetSequence()  
	if c:IsControler(1) then seq=seq+16 end  
	return bit.extract(zone,seq)~=0  
end  
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)  
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000  
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(cm.cfilter,1,nil,zone)  
end  
function cm.rmfilter(c)  
	return c:IsAbleToRemove()  
end  
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)  
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)  
end  
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.rmfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetTargetRange(1,0)  
	e1:SetValue(cm.actlimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)
end  
function cm.actlimit(e,re,rp)  
	local rc=re:GetHandler()  
	return re:IsActiveType(TYPE_MONSTER) and rc:IsLocation(LOCATION_REMOVED)
end  
function cm.atkfilter(c,e)  
	return c:IsFaceup() and c:IsPreviousLocation(LOCATION_GRAVE) and c:IsCanBeEffectTarget(e)
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return eg:IsExists(cm.atkfilter,1,nil,e)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return eg:IsContains(chkc) and cm.atkfilter(chkc,e) end  
	if chk==0 then return true end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)  
	local g=eg:FilterSelect(tp,cm.atkfilter,1,1,nil,e)  
	Duel.SetTargetCard(g)  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) and c:IsRelateToEffect(e) and c:IsFaceup() then  
		local atk=tc:GetAttack()  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_UPDATE_ATTACK)  
		e1:SetValue(atk)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end
