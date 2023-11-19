--最后的遗荣
function c60002423.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1)	  
	--remove 
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(60002423,3))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN)   
	e1:SetHintTiming(0,TIMING_END_PHASE) 
	e1:SetRange(LOCATION_FZONE) 
	e1:SetCountLimit(1)
	e1:SetTarget(c60002423.rmtg) 
	e1:SetOperation(c60002423.rmop) 
	c:RegisterEffect(e1) 
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(60002423,4))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)   
	e2:SetHintTiming(0,TIMING_END_PHASE) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1)
	e2:SetCondition(c60002423.spcon)
	e2:SetTarget(c60002423.sptg) 
	e2:SetOperation(c60002423.spop) 
	c:RegisterEffect(e2) 
end 
function c60002423.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	local b1=tc and tc:IsAbleToRemove() 
	local b2=tc and tc:IsAbleToRemove(POS_FACEDOWN)
	if chk==0 then return b1 or b2 end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,tp,LOCATION_DECK)
end  
function c60002423.rmop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst() 
	if tc then 
		local b1=tc and tc:IsAbleToRemove() 
		local b2=tc and tc:IsAbleToRemove(POS_FACEDOWN)
		local op=2 
		if b1 or b2 then 
			local op=2
			if b1 and b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002423,1),aux.Stringid(60002423,2)) 
			elseif b1 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002423,1)) 
			elseif b2 then 
				op=Duel.SelectOption(tp,aux.Stringid(60002423,2))+1  
			end 
			if op==0 then  
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) 
			elseif op==1 then 
				Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) 
			end  
		end 
	end 
end 
function c60002423.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>0 and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_REMOVED,0,nil)==Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
end 
function c60002423.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60002423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c60002423.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED) 
end
function c60002423.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60002423.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end


