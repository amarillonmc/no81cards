--慧星壳·幻翼
function c79029576.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c79029576.efilter)
	e2:SetCondition(c79029576.imcon)
	c:RegisterEffect(e2)   
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	--damage val
	local e5=e3:Clone()
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e5)
	--SynchroSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	c:RegisterEffect(e1)
	--change
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029576)
	e2:SetCondition(c79029576.spcon)
	e2:SetCost(c79029576.spcost)
	e2:SetTarget(c79029576.sptg)
	e2:SetOperation(c79029576.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c79029576.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c79029576.fil(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c79029576.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c79029576.fil,1,nil)
end
function c79029576.cfilter(c,lg)
	return lg:IsContains(c) and c:IsType(TYPE_TUNER)
end
function c79029576.spcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c79029576.cfilter,1,nil,lg)
end
function c79029576.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_EXTRA,0,1,nil,TYPE_SYNCHRO) end
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_EXTRA,0,1,1,nil,TYPE_SYNCHRO) 
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c79029576.ssfil(c)
	return not c:IsStatus(STATUS_NO_LEVEL)
end
function c79029576.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029576.ssfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	local g=Duel.SelectMatchingCard(tp,c79029576.ssfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c79029576.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tc2=eg:GetFirst()
	local lv=e:GetLabel()
	local c=e:GetHandler()  
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(lv-tc2:GetLevel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(TYPE_SYNCHRO)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end

