--龙源的离子盾
function c12057841.initial_effect(c)
	--Activate 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCountLimit(1,12057841) 
	e1:SetCost(c12057841.accost) 
	e1:SetTarget(c12057841.actg) 
	e1:SetOperation(c12057841.acop) 
	c:RegisterEffect(e1) 
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22057841) 
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c12057841.reptg)
	e2:SetValue(c12057841.repval)
	e2:SetOperation(c12057841.repop)
	c:RegisterEffect(e2) 
	if not c12057841.global_check then
		c12057841.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c12057841.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	Duel.AddCustomActivityCounter(12057841,ACTIVITY_SPSUMMON,c12057841.counterfilter)
end
function c12057841.counterfilter(c)
	return not c:IsLocation(LOCATION_EXTRA) 
end 
function c12057841.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,12057841,RESET_PHASE+PHASE_END,0,1)
end
function c12057841.accost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.GetCustomActivityCount(12057841,tp,ACTIVITY_SPSUMMON)==0 and Duel.GetFlagEffect(tp,12057841)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12057841.splimit)
	Duel.RegisterEffect(e1,tp) 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end 
function c12057841.splimit(e,c)
	return c:IsLocation(LOCATION_EXTRA) 
end 
function c12057841.srfil(c,e,tp)  
	return (c:IsAbleToGrave() or (c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0)) and ((c:IsLevelBelow(4) and c:IsRace(RACE_DRAGON)) or (c:IsDefenseBelow(1900) and c:IsRace(RACE_MACHINE)))  
end 
function c12057841.actg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c12057841.srfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end 
function c12057841.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c12057841.srfil,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:GetCount()>0 then 
	local tc=g:Select(tp,1,1,nil):GetFirst() 
	local op=3  
	local b1=tc:IsAbleToGrave() 
	local b2=tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	if b1 and b2 then  
	op=Duel.SelectOption(tp,aux.Stringid(12057841,0),aux.Stringid(12057841,1)) 
	elseif b1 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057841,0)) 
	elseif b2 then 
	op=Duel.SelectOption(tp,aux.Stringid(12057841,1))+1 
	end 
	if op==0 then 
	Duel.SendtoGrave(tc,REASON_EFFECT)
	elseif op==1 then 
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) 
	end 
	end 
end 
function c12057841.repfilter(c,tp)
	return c:IsOnField() and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE) 
end 
function c12057841.rmfil(c) 
	return (c:IsAttack(2800) or c:IsDefense(2800)) and c:IsAbleToRemove()  
end 
function c12057841.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and eg:IsExists(c12057841.repfilter,1,nil,tp) and Duel.IsExistingMatchingCard(c12057841.rmfil,tp,LOCATION_DECK,0,1,nil) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12057841.repval(e,c)
	return c12057841.repfilter(c,e:GetHandlerPlayer())
end
function c12057841.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_EFFECT) 
	local g=Duel.SelectMatchingCard(tp,c12057841.rmfil,tp,LOCATION_DECK,0,1,1,nil)  
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end






