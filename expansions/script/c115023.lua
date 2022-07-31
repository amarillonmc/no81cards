--方舟骑士-蜜莓
c115023.named_with_Arknight=1
function c115023.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(115023,2))
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetRange(LOCATION_HAND) 
	e1:SetCountLimit(1,115023)
	e1:SetCost(c115023.idcost) 
	e1:SetTarget(c115023.idtg) 
	e1:SetOperation(c115023.idop) 
	c:RegisterEffect(e1) 
	--XDestroy 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,115024)
	e2:SetTarget(c115023.xdtg)
	e2:SetOperation(c115023.xdop)
	c:RegisterEffect(e2) 
	--SpecialSummon P 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION) 
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1,115022) 
	e3:SetCondition(c115023.pspcon)
	e3:SetTarget(c115023.psptg) 
	e3:SetOperation(c115023.pspop) 
	c:RegisterEffect(e3)
end
function c115023.idcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end 
function c115023.idfil(c) 
	return c:IsFaceup() and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) 
end 
function c115023.idtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c115023.idfil,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c115023.idop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c115023.idfil,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,2,nil)  
	local tc=sg:GetFirst() 
	while tc do 
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(115023,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c115023.efilter) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	end 
	end 
end 
function c115023.efilter(e,te)
	if te:GetHandlerPlayer()==e:GetHandlerPlayer() or not te:IsActivated() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end
function c115023.xdtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not e:GetHandler():IsLocation(LOCATION_EXTRA)) or Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0) end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)   
end 
function c115023.xdop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and ((Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not c:IsLocation(LOCATION_EXTRA)) or Duel.GetLocationCountFromEx(tp,tp,nil,e:GetHandler())>0) then  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end 
end 
function c115023.pspcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
end   
function c115023.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local sc=Duel.GetFirstMatchingCard(nil,tp,LOCATION_PZONE,0,e:GetHandler()) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetTargetCard(sc) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sc,1,0,0) 
end 
function c115023.pspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))  
end 
function c115023.pspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then 
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	if Duel.IsExistingMatchingCard(c115023.pspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(115023,0)) then 
	local sg=Duel.SelectMatchingCard(tp,c115023.pspfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	end 
	end 
	end 
end 





