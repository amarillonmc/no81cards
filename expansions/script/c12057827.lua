--龙源的弃徒
function c12057827.initial_effect(c) 
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c12057827.ffilter,2,true)
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
	--rmpos 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12057827,3))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12057827)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12057827.rpcon)
	e1:SetTarget(c12057827.rptg)
	e1:SetOperation(c12057827.rpop)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12057827,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,22057827) 
	e2:SetTarget(c12057827.sptg)
	e2:SetOperation(c12057827.spop)
	c:RegisterEffect(e2) 
end 
function c12057827.ffilter(c)
	return c:IsPosition(POS_FACEDOWN_DEFENSE) and c:IsOnField() 
end
function c12057827.cfilter(c)
	local np=c:GetPosition()
	local pp=c:GetPreviousPosition()
	return ((np<3 and pp>3) or (pp<3 and np>3))
end
function c12057827.rpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12057827.cfilter,1,nil)   
end 
function c12057827.rmfil(c) 
	return c:IsAbleToRemove() and Duel.IsExistingMatchingCard(Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) 
end  
function c12057827.rptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057827.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,LOCATION_MZONE)
end 
function c12057827.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057827.rmfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,tp) 
	if g:GetCount()<=0 then return end   
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	if Duel.Remove(tc,0,REASON_EFFECT) then 
	local sc=Duel.SelectMatchingCard(tp,Card.IsCanChangePosition,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst() 
	local op=3 
	local ad=0 
	local dd=0 
	if sc:IsPosition(POS_FACEUP_DEFENSE+POS_FACEDOWN_ATTACK) then 
	op=Duel.SelectOption(tp,aux.Stringid(12057827,1),aux.Stringid(12057827,2)) 
	if op==0 then 
	ad=POS_FACEDOWN_DEFENSE 
	du=POS_FACEDOWN_DEFENSE 
	else 
	ad=POS_FACEUP_ATTACK 
	du=POS_FACEUP_ATTACK   
	end 
	end 
	if op==3 then 
	ad=POS_FACEDOWN_ATTACK 
	du=POS_FACEUP_DEFENSE 
	end 
	Duel.ChangePosition(sc,POS_FACEDOWN_DEFENSE,ad,du,POS_FACEUP_ATTACK)
	end 
end 
function c12057827.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end 
function c12057827.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12057827.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_GRAVE+LOCATION_REMOVED)  
end 
function c12057827.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057827.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_GRAVE+LOCATION_REMOVED,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)  
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetCode(EFFECT_CHANGE_LEVEL) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(2) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e2,true) 
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_DIRECT_ATTACK) 
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)  
		tc:RegisterEffect(e3,true) 
		local lv=Duel.AnnounceLevel(tp,2,3)  
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_SINGLE) 
		e2:SetCode(EFFECT_CHANGE_LEVEL) 
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(lv) 
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
		c:RegisterEffect(e2)	 
	end  
end 





