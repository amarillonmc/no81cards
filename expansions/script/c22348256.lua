--猩 红 庭 院 的 舞 女
local m=22348256
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.EnableDualAttribute(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348256,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(aux.IsDualState)
	e1:SetOperation(c22348256.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22348256,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c22348256.condition)
	e3:SetOperation(c22348256.spop)
	c:RegisterEffect(e3)
	--change race
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CHANGE_RACE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(aux.IsDualState)
	e4:SetValue(RACE_ZOMBIE)
	c:RegisterEffect(e4)
	--atkup
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(500)
	c:RegisterEffect(e5)
	--atkup
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_LEVEL)
	e6:SetValue(2)
	c:RegisterEffect(e6)
end
function c22348256.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return aux.dsercon(e) and c:IsDualState()
end
function c22348256.filter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22348256.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetCountLimit(1)
	e1:SetOperation(c22348256.spop0)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE_START)
	Duel.RegisterEffect(e1,tp)
end
function c22348256.spop0(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,22348256)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and not Duel.IsExistingMatchingCard(c22348256.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22348256.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
	end
end


