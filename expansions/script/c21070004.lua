--==歼灭模式启动==
local s,id,o=GetID()
function c21070004.initial_effect(c)
	aux.AddCodeList(c,21070001)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21070004,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c21070004.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21070004,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,21070004)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c21070004.condition1)
	e2:SetTarget(c21070004.drtg)
	e2:SetOperation(c21070004.drop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c21070004.atfilter)
	e4:SetValue(c21070004.efilter)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c21070004.setcon1)
	e3:SetTarget(c21070004.settg)
	e3:SetTargetRange(1,0)
	c:RegisterEffect(e3)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetTarget(aux.TargetBoolFunction(Card.IsCode,21070001))
	e7:SetValue(100)
	c:RegisterEffect(e7)
	local e71=Effect.CreateEffect(c)
	e71:SetType(EFFECT_TYPE_FIELD)
	e71:SetCode(EFFECT_UPDATE_ATTACK)
	e71:SetRange(LOCATION_SZONE)
	e71:SetTargetRange(LOCATION_MZONE,0)
	e71:SetTarget(not(aux.TargetBoolFunction(Card.IsCode,21070001)))
	e71:SetValue(-700)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_EXTRA_ATTACK)
	e8:SetRange(LOCATION_SZONE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c21070004.atfilter)
	e8:SetValue(2)
	c:RegisterEffect(e8,tp)
	if not c21070004.global_check then
		c21070004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c21070004.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c21070004.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,21070004,RESET_PHASE+PHASE_END,0,1)
	end
end
function c21070004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c21070004.con)
	e1:SetValue(c21070004.aclimit)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetValue(2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(3)
	Duel.RegisterEffect(e3,tp)
	Duel.RegisterFlagEffect(tp,21070004,0,0,1)
	
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetTarget(c21070004.splimit)
	e6:SetTargetRange(1,0)
	Duel.RegisterEffect(e6,tp)
	
	
end

function c21070004.con(e)
	local ph=Duel.GetCurrentPhase()
	return not ph~=PHASE_END 
end
function c21070004.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c21070004.atfilter(e,c)
	return c:IsCode(21070001)
end
function c21070004.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) 
end
function c21070004.setcon1(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),21070004)>0
end
function c21070004.settg(e,c)
	return c:IsLocation(LOCATION_HAND)
end
function c21070004.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA)
end




function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
end
function s.cfilter(c,e,tp)
	return c:IsCode(21070001) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
