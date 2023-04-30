--救世的英雄 凯文
function c32131334.initial_effect(c)
	aux.AddCodeList(c,32131333)
	aux.AddMaterialCodeList(c,32131333)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131333) 
	c:RegisterEffect(e0)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,32131333),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--Destroy 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32131334) 
	e1:SetCondition(c32131334.descon)
	e1:SetTarget(c32131334.destg) 
	e1:SetOperation(c32131334.desop)  
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,23131334) 
	e2:SetTarget(c32131334.sptg) 
	e2:SetOperation(c32131334.spop) 
	c:RegisterEffect(e2)   
end 
c32131334.SetCard_HR_flame13=true 
c32131334.HR_Flame_CodeList=32131333  
function c32131334.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131334.descon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131334.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131334.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c32131334.desop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	local dg=g:Select(tp,1,1,nil) 
	Duel.Destroy(dg,REASON_EFFECT) 
	end 
end 
function c32131334.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_HR_flame13	 
end 
function c32131334.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131334.spfil,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD) 
end 
function c32131334.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c32131334.spfil,tp,LOCATION_GRAVE,0,e:GetHandler(),e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 







