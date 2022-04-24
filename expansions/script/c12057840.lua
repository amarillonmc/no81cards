--龙源的尸骸怨念
function c12057840.initial_effect(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c12057840.ffilter,2,true)  
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_DRAGON)
	e0:SetRange(0xff)
	c:RegisterEffect(e0)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WARRIOR)
	e0:SetRange(0xff)
	c:RegisterEffect(e0) 
	--cannot direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12057840.atkval)
	c:RegisterEffect(e1) 
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetCondition(c12057840.immcon)
	e2:SetValue(c12057840.efilter)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)  
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCountLimit(1,12057840) 
	e3:SetTarget(c12057840.sptg) 
	e3:SetOperation(c12057840.spop) 
	c:RegisterEffect(e3) 
	--SpecialSummon
	local e4=Effect.CreateEffect(c) 
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e4:SetCode(EVENT_TO_GRAVE) 
	e4:SetProperty(EFFECT_FLAG_DELAY) 
	e4:SetCountLimit(1,22057840) 
	e4:SetTarget(c12057840.xsptg) 
	e4:SetOperation(c12057840.xspop) 
	c:RegisterEffect(e4) 
	local e5=e4:Clone()  
	e5:SetCode(EVENT_REMOVE) 
	c:RegisterEffect(e5) 
end
function c12057840.ffilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsOnField() 
end 
function c12057840.atkval(e,c) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*800  
end
function c12057840.immcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,POS_FACEDOWN_DEFENSE) 
end
function c12057840.efilter(e,te)
	local tc=te:GetHandler()
	return tc:IsAttackBelow(3000) and tc~=e:GetHandler() 
end 
function c12057840.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)  
end 
function c12057840.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE) 
	local b2=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) 
	if chk==0 then return (b1 or b2) and Duel.IsExistingMatchingCard(c12057840.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end 
function c12057840.cpfil(c) 
	return c:IsCanChangePosition() and not c:IsPosition(POS_FACEDOWN_DEFENSE)
end 
function c12057840.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057840.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)  
	Duel.ConfirmCards(1-tp,sg)
	if Duel.IsExistingMatchingCard(c12057840.cpfil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(12057840,0)) then 
	local tc=Duel.SelectMatchingCard(tp,c12057840.cpfil,tp,0,LOCATION_MZONE,1,1,nil):GetFirst() 
	Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end  
	end 
end 
function c12057840.xspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false,POS_FACEDOWN_DEFENSE) and c:IsType(TYPE_FUSION) and c:IsSetCard(0xac1,0xac2) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and not c:IsCode(12057840) 
end 
function c12057840.xsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():GetReasonPlayer()==1-tp and Duel.IsExistingMatchingCard(c12057840.xspfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function c12057840.xspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057840.xspfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEDOWN_DEFENSE)  
	Duel.ConfirmCards(1-tp,sg)
	end 
end 



