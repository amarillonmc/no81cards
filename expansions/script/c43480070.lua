--被遗忘的研究实验室
function c43480070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,43480070+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--pl 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE) 
	e1:SetCountLimit(1,43480071)
	e1:SetTarget(c43480070.pltg)
	e1:SetOperation(c43480070.plop)
	c:RegisterEffect(e1)
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTargetRange(LOCATION_SZONE,0) 
	e2:SetTarget(function(e,c) 
	return c:GetOriginalType()&TYPE_PENDULUM~=0 end)
	e2:SetValue(c43480070.matval)
	c:RegisterEffect(e2)
	--Special Summon 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,43480072)
	e3:SetCondition(c43480070.spcon)
	e3:SetTarget(c43480070.sptg)
	e3:SetOperation(c43480070.spop) 
	c:RegisterEffect(e3)
end
function c43480070.plfilter(c)
	return c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c43480070.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c43480070.plfilter,tp,LOCATION_DECK,0,1,nil) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function c43480070.plop(e,tp,eg,ep,ev,re,r,rp) 
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c43480070.plfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) 
	end
end 
function c43480070.matval(e,lc,mg,c,tp)
	if not lc:IsSetCard(0x3f13) then return false,nil end
	return true,not mg or mg:GetCount()>0  
end
function c43480070.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 
end
function c43480070.spfilter(c,e,tp)
	if not (c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then return false end 
	if c:IsLocation(LOCATION_EXTRA) then  
		return c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
	else 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	end 
end
function c43480070.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c43480070.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c43480070.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c43480070.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
	end
end 

