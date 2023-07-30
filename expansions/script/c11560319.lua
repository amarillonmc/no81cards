--勒比卢新星 麦哲
function c11560319.initial_effect(c)
	c:EnableReviveLimit()
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--xx
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11560319)
	e1:SetTarget(c11560319.xxtg) 
	e1:SetOperation(c11560319.xxop) 
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560319)
	e2:SetTarget(c11560319.rsptg)
	e2:SetOperation(c11560319.rspop)
	c:RegisterEffect(e2)
end
c11560319.SetCard_XdMcy=true 
function c11560319.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11560319.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_REMOVE)  
	e1:SetOperation(c11560319.xdaop)  
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end  
function c11560319.xdaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,11560319)
	local x=eg:GetCount() 
	Duel.Damage(1-tp,x*200,REASON_EFFECT) 
	Duel.BreakEffect() 
	Duel.Damage(1-tp,200,REASON_EFFECT)
end 
function c11560319.rspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_XdMcy and not c:IsCode(11560319)  
end 
function c11560319.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560319.rspfil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end 
function c11560319.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11560319.rspfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 




