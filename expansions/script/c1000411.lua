--纯真无邪～空白少女
function c1000411.initial_effect(c)
	c:SetUniqueOnField(1,0,1000411)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,1000411)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c1000411.target)
	e2:SetCondition(c1000411.con)
	c:RegisterEffect(e2)
	--notxyz
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(c1000411.spcon)
	e7:SetTarget(c1000411.sptg)
	e7:SetOperation(c1000411.spop)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e8)
end
function c1000411.target(e,c)
	return c:IsLevelBelow(4) and c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c1000411.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xa201)
end
function c1000411.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c1000411.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end
function c1000411.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000411.tgfilter,1,nil,nil,1-tp) and Duel.IsExistingMatchingCard(c1000411.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c1000411.tgfilter(c,e,tp)
	return c:IsFaceup() and c:IsLevelBelow(4) and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function c1000411.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function c1000411.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c1000411.tgfilter,nil,e,1-tp)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e1:SetValue(1)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		tc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end