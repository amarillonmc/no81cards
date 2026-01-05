--加菲尔
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337550,17337670,17337400)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f50) or aux.IsCodeListed(c,17337400) and c:IsType(TYPE_MONSTER)
end
function s.spfilter2(c)
	return c:IsFaceup() and c:IsCode(17337550,17337670)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		(Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) or 
		Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	if Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
	end
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.efilter)
	e1:SetValue(s.val)
	Duel.RegisterEffect(e1,tp)
end
function s.val(e,c)
	local val=c:GetLevel()+c:GetLink()+c:GetRank()
	return val*200
end
function s.efilter(e,c)
	return c:IsSetCard(0x3f50)
end