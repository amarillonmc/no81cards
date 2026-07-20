-- 唯一王者·别西卜
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)
	aux.AddSynchroProcedure(c,s.matfilter1,aux.NonTuner(nil),1)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.con1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e2b=e2:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2b)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.con3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)
end
function s.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsSynchroType(TYPE_SYNCHRO)
end
function s.get_count(tp)
	local base=Duel.GetFlagEffect(tp,60002148)
	local neg=Duel.GetFlagEffect(tp,60012250)
	return base-neg
end
function s.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()<=9 and c:IsAbleToRemove()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,0,LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	if s.get_count(tp)>=15 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,1-tp,LOCATION_HAND)
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local loc=LOCATION_EXTRA
	if s.get_count(tp)>=15 then loc=LOCATION_HAND+LOCATION_EXTRA end
	local g=Duel.GetMatchingGroup(nil,tp,0,loc,nil)
	Duel.ConfirmCards(tp,g)
	if #g:Filter(s.rmfilter,nil)>0 then
		Duel.Remove(g:Filter(s.rmfilter,nil),POS_FACEUP,REASON_EFFECT)
	end
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>=1
end
function s.atkval(e,c)
	return c:GetCounter(0x624)*400
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and eg:GetFirst()==e:GetHandler() and e:GetHandler():GetCounter(0x624)>=3
end
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,2800,REASON_EFFECT)
end