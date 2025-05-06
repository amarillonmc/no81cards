--纹章呼唤 封印之剑
function c75000861.initial_effect(c)
	c:SetUniqueOnField(1,0,75000861)
	--Activate
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_ACTIVATE) 
	e0:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e0) 
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(75000861,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1) 
	e1:SetTarget(c75000861.thtg)
	e1:SetOperation(c75000861.thop)
	c:RegisterEffect(e1)
	--SpecialSummon 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(75000861,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1) 
	e2:SetTarget(c75000861.sptg)
	e2:SetOperation(c75000861.spop)
	c:RegisterEffect(e2) 
	--synchro summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75000861,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,75000861)
	e3:SetCondition(c75000861.sccon)
	e3:SetTarget(c75000861.sctg)
	e3:SetOperation(c75000861.scop)
	c:RegisterEffect(e3)	
end
function c75000861.thfilter(c) 
	return c:IsSetCard(0xc751,0x3751) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c75000861.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000861.thfilter,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():GetFlagEffect(75000861)==0 end
	e:GetHandler():RegisterFlagEffect(75000861,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c75000861.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c75000861.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
end 
function c75000861.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0xc751)  
end 
function c75000861.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c75000861.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) and e:GetHandler():GetFlagEffect(75000861)==0 end
	e:GetHandler():RegisterFlagEffect(75000861,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c75000861.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c75000861.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--
function c75000861.scconfilter(c,tp)
	return c:IsFaceup()
end
function c75000861.sccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c75000861.scconfilter,1,nil,tp)
end
function c75000861.mfilter(c)
	return c:IsSetCard(0xc751) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c75000861.syncheck(g,tp,syncard)
	return g:IsExists(c75000861.mfilter,1,nil) and syncard:IsSynchroSummonable(nil,g,#g-1,#g-1) and aux.SynMixHandCheck(g,tp,syncard)
end
function c75000861.scfilter(c,tp,mg)
	return mg:CheckSubGroup(c75000861.syncheck,2,#mg,tp,c)
end
function c75000861.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetSynchroMaterial(tp)
		if mg:IsExists(Card.GetHandSynchro,1,nil) then
			local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
			if mg2:GetCount()>0 then mg:Merge(mg2) end
		end
		return Duel.IsExistingMatchingCard(c75000861.scfilter,tp,LOCATION_EXTRA,0,1,nil,tp,mg) and c:IsAbleToHand()
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c75000861.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetSynchroMaterial(tp)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(nil,tp,LOCATION_HAND,0,nil)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local g=Duel.GetMatchingGroup(c75000861.scfilter,tp,LOCATION_EXTRA,0,nil,tp,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local tg=mg:SelectSubGroup(tp,c75000861.syncheck,false,2,#mg,tp,sc)
		if Duel.SynchroSummon(tp,sc,nil,tg,#tg-1,#tg-1)~=0 then
			Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		end
	end
end
