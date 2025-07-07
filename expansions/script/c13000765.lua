--颂咏吾名
local cm,m,o=GetID()
function c13000765.initial_effect(c)
aux.EnablePendulumAttribute(c) 
local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_PZONE) 
	e0:SetCountLimit(1) 
	e0:SetTarget(cm.target)
	e0:SetOperation(cm.eqop)
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE) 
	e1:SetCode(EVENT_TO_HAND)
	e1:SetCondition(cm.drcon1)
	e1:SetOperation(cm.drop1)
	c:RegisterEffect(e1) 

end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and not c:IsReason(REASON_DRAW)
end
function cm.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.drop1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
   if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function cm.filter1(c,e,tp)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
getmetatable(e:GetHandler()).announce_filter={TYPE_SPELL,OPCODE_ISTYPE,TYPE_TRAP,OPCODE_ISTYPE,OPCODE_OR}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(ac)
	tc:RegisterEffect(e1)
end



























