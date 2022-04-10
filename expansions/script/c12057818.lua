--教导的狱天神
function c12057818.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WYRM+RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_WYRM+RACE_SPELLCASTER),1)
	c:EnableReviveLimit()   
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetValue(RACE_WYRM)
	e0:SetRange(0xff)
	c:RegisterEffect(e0)
	--remove and damage 
	local e1=Effect.CreateEffect(c) 
	e1:SetDescription(aux.Stringid(12057818,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,12057818)
	e1:SetTarget(c12057818.radtg)
	e1:SetOperation(c12057818.radop) 
	c:RegisterEffect(e1)  
	--SpecialSummon
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(12057818,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22057818)
	e2:SetCondition(c12057818.spcon)
	e2:SetTarget(c12057818.sptg)  
	e2:SetOperation(c12057818.spop)
	c:RegisterEffect(e2)
	--remove 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12057818,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,32057818)
	e3:SetCondition(c12057818.rmcon)
	e3:SetTarget(c12057818.rmtg)
	e3:SetOperation(c12057818.rmop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e4)
end
function c12057818.radtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_GRAVE) 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1200)
end
function c12057818.radop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,3,nil) 
	if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then 
	Duel.Damage(1-tp,1200,REASON_EFFECT)
	end
end
function c12057818.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c12057818.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x145,0x16b)
end
function c12057818.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() and Duel.IsExistingMatchingCard(c12057818.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetMZoneCount(tp,e:GetHandler())>0 end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function c12057818.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,0,REASON_EFFECT)~=0 then 
	local g=Duel.GetMatchingGroup(c12057818.spfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp) 
	if g:GetCount()<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP) 
	local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	local tc=mg:GetFirst()
	while tc do 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
	tc=mg:GetNext() 
	end
	local cg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if cg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(12057818,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=cg:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
	end
end
function c12057818.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and rp==1-tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c12057818.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,1-tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c12057818.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,0,1,nil) then 
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	Duel.ConfirmCards(tp,g1)
	local sg1=g1:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN):RandomSelect(tp,1)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g2)
	local sg2=g1:Filter(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN):RandomSelect(tp,1)  
	sg1:Merge(sg2) 
	Duel.Remove(sg1,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleHand(1-tp)
	Duel.ShuffleExtra(1-tp)  
	end 
end




