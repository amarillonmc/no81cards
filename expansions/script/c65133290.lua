--幻叙历险者 成龙
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--oppo cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(s.discon1)
	e2:SetValue(s.aclimit)
	c:RegisterEffect(e2)
	--oppo cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.discon1)
	e3:SetTarget(s.atktg)
	c:RegisterEffect(e3)
	--self cannot activate
	local e4=e2:Clone()
	e4:SetTargetRange(1,0)
	e4:SetCondition(s.discon2)
	c:RegisterEffect(e4)
	--self cannot attack
	local e5=e3:Clone()
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(s.discon2)
	c:RegisterEffect(e5)
	--spsummon from GY
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e6:SetCondition(s.gycon)
	e6:SetTarget(s.gytg)
	e6:SetOperation(s.gyop)
	c:RegisterEffect(e6)
end
function s.spfilter(c)
	return c:IsSetCard(0x838) and not c:IsPublic()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,c)
	return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=g:Select(tp,1,1,nil)
	if tc then
		e:SetLabelObject(tc:GetFirst())
		return true
	else return false end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetLabelObject()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleHand(tp)
end
function s.discon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
end
function s.discon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsCode(id)
end
function s.atktg(e,c)
	return not c:IsCode(id)
end
function s.gycon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local defp=1-at:GetControler()
	return Duel.GetAttackTarget()==nil and at:GetAttack()>=Duel.GetLP(defp)
end
function s.chainlm(e,rp,tp)
	return not e:IsActiveType(TYPE_MONSTER)
end
function s.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(s.chainlm)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.gyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
