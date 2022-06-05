--钢铁律命“利剑”阿尔弗拉克
function c60001144.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,c60001144.mfilter,c60001144.xyzcheck,4,4)
	--ds and sp 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e0:SetCode(EVENT_CHAIN_SOLVING) 
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA) 
	e0:SetCondition(c60001144.dscon) 
	e0:SetOperation(c60001144.dsop) 
	c:RegisterEffect(e0) 
	--sp ss 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c60001144.ssscon)
	e1:SetOperation(c60001144.sssop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c60001144.reptg)
	e2:SetValue(c60001144.repval)
	e2:SetOperation(c60001144.repop)
	c:RegisterEffect(e2)
end
function c60001144.mfilter(c)
	return c:IsStatus(STATUS_NO_LEVEL)
end 
function c60001144.xyzcheck(g)
	return true 
end
function c60001144.dscon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rp==tp and Duel.IsChainNegatable(ev) and rc and rc:IsRace(RACE_MACHINE) and rc:IsType(TYPE_LINK) and rc:IsOnField() and rc:IsCanOverlay() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false) and Duel.GetFlagEffect(tp,60001144)==0 
end 
function c60001144.xovfil(c) 
	return c:IsRace(RACE_MACHINE) and c:IsCanOverlay() 
end 
function c60001144.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()   
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(60001144,0)) then  
	Duel.RegisterFlagEffect(tp,60001144,RESET_PHASE+PHASE_END,0,1)
	Duel.NegateEffect(ev)
	Duel.Overlay(c,rc)
	Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) 
	if Duel.IsExistingMatchingCard(c60001144.xovfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001144,1)) then 
	local tc=Duel.SelectMatchingCard(tp,c60001144.xovfil,tp,LOCATION_DECK,0,1,1,nil):GetFirst() 
	Duel.Overlay(c,tc) 
	end 
	end 
end 
function c60001144.ssscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c60001144.sssop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_CARD,0,60001144)
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c60001144.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)  
end
function c60001144.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c60001144.repfilter(c,e,tp)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and c~=e:GetHandler()  
		and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c60001144.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001144.xovfil,tp,LOCATION_GRAVE,0,1,nil) and eg:IsExists(c60001144.repfilter,1,nil,e,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c60001144.repval(e,c)
	return c60001144.repfilter(c,e,e:GetHandlerPlayer())
end
function c60001144.repop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.SelectMatchingCard(tp,c60001144.xovfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Overlay(c,g)
end






