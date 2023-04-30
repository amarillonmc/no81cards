--逐火十三英桀 华
function c32131320.initial_effect(c)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_DESTROYED) 
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP) 
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,32131320) 
	e1:SetCondition(c32131320.hspcon) 
	e1:SetTarget(c32131320.hsptg) 
	e1:SetOperation(c32131320.hspop)  
	c:RegisterEffect(e1) 

	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1) 
	e2:SetCondition(function(e) 
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) end)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(function(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c.SetCard_HR_flame13 end) 
	c:RegisterEffect(e3) 
end 
c32131320.SetCard_HR_flame13=true 
function c32131320.sckfil(c,tp) 
	return c:IsPreviousControler(tp)
end 
function c32131320.hspcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:IsExists(c32131320.sckfil,1,nil,tp)   
end  
function c32131320.hsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function c32131320.hspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 



