local m=15000330
local cm=_G["c"..m]
cm.name="内核收容 深渊"
function cm.initial_effect(c)
	--Activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)  
	--change effect type  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(15000330)  
	e2:SetRange(LOCATION_FZONE)  
	e2:SetTargetRange(1,0)  
	c:RegisterEffect(e2)
	--setatk 
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_SET_ATTACK)  
	e3:SetRange(LOCATION_FZONE)  
	e3:SetTargetRange(LOCATION_MZONE,0)  
	e3:SetTarget(aux.TargetBoolFunction(cm.atkfilter))  
	e3:SetValue(0)  
	c:RegisterEffect(e3)
	--special summon  
	local e4=Effect.CreateEffect(c)	
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e4:SetType(EFFECT_TYPE_IGNITION)  
	e4:SetRange(LOCATION_FZONE)  
	e4:SetCountLimit(1,m)  
	e4:SetTarget(cm.sptg)  
	e4:SetOperation(cm.spop)  
	c:RegisterEffect(e4)
end
function cm.atkfilter(c,e,tp)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end 
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0xf39) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp) 
	if g:GetCount()>0 then  
		local tc=g:GetFirst()
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) then 
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)   
		end  
	end  
end