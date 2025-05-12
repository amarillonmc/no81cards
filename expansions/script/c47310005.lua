-- 面灵气 忧心的鬼婆面
Duel.LoadScript('c47310000.lua')
local s,id=GetID()

function s.effgain(c)
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.rmcon)
	e1:SetOperation(s.rmop)
	return e1
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and rc:IsAbleToRemove() and Hnk.efcon(e,tp,eg,ep,ev,re,r,rp)
		and e:GetHandler():GetFlagEffect(id)<=0
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,0)) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.remove(c)
    local e1=Hnk.become_target(c,id)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetTarget(s.rmtg2)
	e1:SetOperation(s.rmop2)
	c:RegisterEffect(e1)
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ntrfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.rmop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.initial_effect(c)
    Hnk.hnk_equip(c,id,s.effgain(c))
    Hnk.worries_eq(c)
	s.remove(c)
end
