local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedureLevelFree(c,nil,s.xyzcheck,2,2)
	c:EnableReviveLimit()
	--Effect 1: Standby Phase Detach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)
	--Effect 2: Confirm & Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Global Check for Summon Counts
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.xyzcheck(g)
	return g:GetClassCount(Card.GetLevel)==1
end
--Global check operation (Based on Nibiru reference)
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		Duel.RegisterFlagEffect(tc:GetSummonPlayer(),id,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end

--Effect 1 Operation (Based on Tiras reference)
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end

--Effect 2 Condition
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local turn_p=Duel.GetTurnPlayer()
	return Duel.GetFlagEffect(turn_p,id)>=3
end

--Effect 2 Cost (Based on Zombie Carrier reference for IsAbleToDeckAsCost)
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	if chk==0 then 
		if ct==0 then return true end
		return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,ct,nil)
	end
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,ct,ct,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
	end
end

--Effect 2 Target (Based on Galaxy Hundred reference)
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_EXTRA,0,1,nil) 
			and c:IsType(TYPE_XYZ) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
end

function s.xyzfilter(c,e,tp,mc)
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end

--Effect 2 Operation (Based on Galaxy Hundred and Exosister Malfa references)
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g>0 then
		Duel.ConfirmCards(tp,g)
		if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e) 
			and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then
			
			local sg=g:Filter(s.xyzfilter,nil,e,tp,c)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=sg:Select(tp,1,1,nil):GetFirst()
				if sc then
					local mg=c:GetOverlayGroup()
					if mg:GetCount()~=0 then
						Duel.Overlay(sc,mg)
					end
					sc:SetMaterial(Group.FromCards(c))
					Duel.Overlay(sc,Group.FromCards(c))
					Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
					sc:CompleteProcedure()
				end
			end
		end
		Duel.ShuffleExtra(1-tp)
	end
end