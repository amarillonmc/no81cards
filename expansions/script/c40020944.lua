local s,id=GetID()
s.named_with_Galaxian=1

function s.Galaxian(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Galaxian
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon1)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg1)
	e1:SetOperation(s.thop1)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.thcon2)
	c:RegisterEffect(e2)
	
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon2)
	e3:SetTarget(s.sptg2)
	e3:SetOperation(s.spop2)
	c:RegisterEffect(e3)
	
	local e4=e3:Clone()
	e4:SetCode(EVENT_REMOVE)
	e4:SetCondition(s.spcon2b)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCountLimit(1,id+2)
	e5:SetTarget(s.rittg)
	e5:SetOperation(s.ritop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end

function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,40020959)
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,40020959)
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	Duel.ConfirmCards(1-tp,e:GetHandler())
end

function s.rmfilter(c)
	return s.Galaxian(c) and c:IsAbleToRemove()
end

function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_HAND,0,1,1,c)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end

function s.spcon2b(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsFaceup()
end

function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function s.fselect(g,lv,tp)
	local sum=g:GetSum(Card.GetLevel)
	if sum<lv then return false end
	
	if sum-g:GetFirst():GetLevel()>=lv and #g>1 then
		for tc in aux.Next(g) do
			if sum-tc:GetLevel()>=lv then return false end
		end
	end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		if not g:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return false end
	end
	return true
end

function s.ritfilter(c,e,tp)
	if c:IsLocation(LOCATION_REMOVED) and not c:IsFaceup() then return false end
	if not (s.Galaxian(c) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)) then return false end
	
	local lv=c:GetLevel()
	local mg1=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,c,tp)
	local mg2=Duel.GetMatchingGroup(s.rmmatfilter,tp,LOCATION_GRAVE,0,c)
	local mg=mg1:Clone()
	mg:Merge(mg2)
	return mg:CheckSubGroup(s.fselect,1,#mg,lv,tp)
end

function s.relfilter(c,tp)
	return s.Galaxian(c) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
		and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()))
end

function s.rmmatfilter(c)
	return s.Galaxian(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(s.ritfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.ritfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_REMOVED,0,nil,e,tp)
	if #rg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc=rg:Select(tp,1,1,nil):GetFirst()
	if not rc then return end
	
	local lv=rc:GetLevel()
	local mg1=Duel.GetMatchingGroup(s.relfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,rc,tp)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmmatfilter),tp,LOCATION_GRAVE,0,rc)
	local mg=mg1:Clone()
	mg:Merge(mg2)
	if #mg==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=mg:SelectSubGroup(tp,s.fselect,false,1,#mg,lv,tp)
	if not sg or #sg==0 then return end
	
	local relg=sg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	local rmg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	
	if #relg>0 then
		Duel.Release(relg,REASON_RITUAL)
	end
	if #rmg>0 then
		Duel.Remove(rmg,POS_FACEUP,REASON_RITUAL)
	end
	
	if Duel.SpecialSummonStep(rc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP) then
		rc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end