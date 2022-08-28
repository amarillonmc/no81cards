--方舟骑士-蜜莓
c115023.named_with_Arknight=1
function c115023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--SpecialSummon 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,115023)
	e1:SetCondition(c115023.spcon)
	e1:SetTarget(c115023.sptg)
	e1:SetOperation(c115023.spop)
	c:RegisterEffect(e1)  
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED) 
	e2:SetCountLimit(1,215023)
	e2:SetTarget(c115023.dsptg)
	e2:SetOperation(c115023.dspop)
	c:RegisterEffect(e2)  
end
function c115023.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function c115023.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler())
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c115023.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS) 
	e1:SetCode(EVENT_CHAIN_SOLVING) 
	e1:SetCondition(c115023.ngcon) 
	e1:SetOperation(c115023.ngop)  
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp)
	end 
end 
function c115023.ngckfil(c,tp) 
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_MONSTER) and c:IsOnField() and c:IsControler(tp)	
end 
function c115023.ngcon(e,tp,eg,ep,ev,re,r,rp) 
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c115023.ngckfil,1,nil,tp) and rp==1-tp  
end 
function c115023.ngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(115023,0)) then 
	Duel.Hint(HINT_CARD,0,115023)  
	Duel.NegateEffect(ev) 
	e:Reset() 
	end 
end 
function c115023.dspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))   
end 
function c115023.dsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c115023.dspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED) 
end
function c115023.dspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c115023.dspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)   
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	end 
end 









