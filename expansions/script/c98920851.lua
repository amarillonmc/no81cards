--传说魔兽 加泽特
function c98920851.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(98920851)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98920851.spcon)
	e1:SetTarget(c98920851.sptg)
	e1:SetOperation(c98920851.spop)
	c:RegisterEffect(e1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920851,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c98920851.eqcon1)
	e1:SetTarget(c98920851.target)
	e1:SetOperation(c98920851.operation)
	c:RegisterEffect(e1)
end
function c98920851.spfilter(c,tp)
	return c:IsReleasable(REASON_SPSUMMON) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c98920851.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c98920851.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
end
function c98920851.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c98920851.spfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c98920851.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g:GetOwner()==1-e:GetHandlerPlayer() then c:RegisterFlagEffect(98920851,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) end
	Duel.Release(g,REASON_SPSUMMON)
	local atk=g:GetAttack()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
end
function c98920851.eqcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(98920851)>0
end
function c98920851.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,e:GetHandler():GetAttack())
end
function c98920851.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,e:GetHandler():GetAttack(),REASON_EFFECT)
end