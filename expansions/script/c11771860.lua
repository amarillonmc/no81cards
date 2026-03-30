--随风而上的舞者
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.efftg)
	e2:SetOperation(s.effop)
	c:RegisterEffect(e2)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(id)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		tc:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetLabelObject(e1)
		e2:SetCondition(s.tdcon)
		e2:SetOperation(s.tdop)
		e2:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e2,tp)
		--我讨厌超量...
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetCode(EVENT_BE_PRE_MATERIAL)
		e3:SetLabelObject(e2)
		e3:SetOperation(s.reset)
		e3:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		tc:RegisterEffect(e3)
	end
end
function s.cfilter(c,tp,tc)
	return tc:IsHasEffect(id) and tc==c and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local tc=e1:GetLabelObject()
	return e1 and tc and eg:IsContains(tc)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	if not e1 then return end
	local tc=e1:GetLabelObject()
	if eg:IsExists(s.cfilter,1,nil,tp,tc) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		Duel.Hint(HINT_CARD,0,id)
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	e1:Reset()
	e:Reset()
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=e:GetLabelObject()
	local e1=e2:GetLabelObject()
	if r==REASON_XYZ and e1 then
		e2:Reset()
		e1:Reset()
		e:Reset()
	end
end