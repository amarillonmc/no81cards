--救援之云雾 桑葚
function c76029006.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,76029006)  
	e1:SetCondition(c76029006.tgcon)
	e1:SetCost(c76029006.tgcost)
	e1:SetTarget(c76029006.tgtg)
	e1:SetOperation(c76029006.tgop)
	c:RegisterEffect(e1) 
	--SpecialSummon  
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,06029006) 
	e2:SetCost(c76029006.spcost)
	e2:SetTarget(c76029006.sptg)
	e2:SetOperation(c76029006.spop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(76029006,ACTIVITY_SPSUMMON,c76029006.counterfilter)
end
function c76029006.counterfilter(c)
	return c:IsRace(RACE_SPELLCASTER) 
end
function c76029006.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c76029006.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c76029006.tgfil(c)
	return c:IsDisabled() 
end
function c76029006.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c76029006.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,0,LOCATION_ONFIELD)
end
function c76029006.spfil(c,e,tp,lv)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_SPELLCASTER) and c:IsLevelBelow(lv)
end
function c76029006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c76029006.tgfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029006,1))
	Debug.Message("这里很危险！大家请快撤退，博士，请跟紧我！")
	local x=Duel.SendtoGrave(g,REASON_EFFECT)
	Duel.Recover(tp,x*200,REASON_EFFECT) 
	if Duel.IsExistingMatchingCard(c76029006.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,x) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(76029006,0)) then 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029006,2))
	Debug.Message("各位请多加小心！")
	local sg=Duel.SelectMatchingCard(tp,c76029006.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,x)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	end
end 
function c76029006.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(76029006,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c76029006.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c76029006.splimit(e,c)
	return not c:IsRace(RACE_SPELLCASTER)
end
function c76029006.ckfil(c,tp)
	return c:IsControler(tp) and c:IsRace(RACE_SPELLCASTER)
end
function c76029006.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c76029006.ckfil,1,nil,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c76029006.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(76029006,3))
	Debug.Message("救援小队桑葚，已就位！")
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end







