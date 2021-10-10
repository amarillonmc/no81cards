--共鸣钢战-Z敢达
function c82557965.initial_effect(c)
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82557965,0))
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c82557965.ntcon)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82557965,1))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetCountLimit(1,82557965)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c82557965.atktg)
	e3:SetOperation(c82557965.atkop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c82557965.psplimit(e,c,tp,sumtp,sumpos)
	return not c:IsRace(RACE_MACHINE) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82557965.ntfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x829)
end
function c82557965.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c82557965.ntfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c82557965.atkfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()
end
function c82557965.atkfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c82557965.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsRace(RACE_MACHINE) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c82557965.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g2=Duel.SelectTarget(tp,c82557965.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g2:GetFirst()
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,tc,1,0,0)
end
function c82557965.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetProperty(EFFECT_CANNOT_DISABLE)
		e2:SetValue(Duel.GetMatchingGroup(c82557965.atkfilter2,tp,LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)*100)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end