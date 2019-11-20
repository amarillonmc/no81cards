--AST 迎击
function c33400427.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400427,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,33400427)
	e2:SetCondition(c33400427.spcon)
	e2:SetTarget(c33400427.sptg)
	e2:SetOperation(c33400427.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
   --synchro effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33400427,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e4:SetCountLimit(1,33400427+10000)
	e4:SetTarget(c33400427.sctg)
	e4:SetOperation(c33400427.scop)
	c:RegisterEffect(e4)
	--xyz effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33400427,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e5:SetCountLimit(1,33400427+10000)
	e5:SetTarget(c33400427.xyztg)
	e5:SetOperation(c33400427.xyzop)
	c:RegisterEffect(e5)
end
function c33400427.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400427.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400427.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==1-tp and (c:IsSetCard(0x341) or (Duel.IsExistingMatchingCard(c33400427.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
	Duel.IsExistingMatchingCard(c33400427.cccfilter2,tp,LOCATION_MZONE,0,1,nil) ))
end
function c33400427.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(c33400427.cfilter,1,nil,tp)
end
function c33400427.spfilter(c,e,tp)
	return c:IsSetCard(0x9343) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c33400427.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33400427.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c33400427.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33400427.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if  Duel.IsExistingMatchingCard(c33400427.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) and not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x341)and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0x341)   
		or (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
			(Duel.IsExistingMatchingCard(c33400427.cccfilter1,tp,LOCATION_ONFIELD,0,1,nil) or 
			Duel.IsExistingMatchingCard(c33400427.cccfilter2,tp,LOCATION_MZONE,0,1,nil))) 
		then
			if Duel.SelectYesNo(tp,aux.Stringid(33400427,3)) then 
				  local g2=Duel.SelectMatchingCard(tp,c33400427.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				  Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
			end			
		end
	end
end

function c33400427.spcfilter(c)
	return c:IsSetCard(0x341) and c:IsFaceup()
end
function c33400427.cccfilter1(c)
	return c:IsCode(33400428) and c:IsFaceup()
end
function c33400427.cccfilter2(c)
	return c:IsCode(33400425) and c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c33400427.scfilter(c)
	return c:IsSetCard(0xc343) and c:IsSynchroSummonable(nil)
end
function c33400427.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400427.scfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400427.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33400427.scfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if   Duel.SynchroSummon(tp,sg:GetFirst(),nil) and  not Duel.IsExistingMatchingCard(c33400427.spcfilter,tp,LOCATION_MZONE,0,1,nil) then
				if  Duel.IsExistingMatchingCard(c33400427.spcfilter,tp,0,LOCATION_MZONE,1,nil)   
				or
				  (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
					(Duel.IsExistingMatchingCard(c33400427.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
					Duel.IsExistingMatchingCard(c33400427.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
					)
				  )
				then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetValue(aux.tgoval)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sg:GetFirst():RegisterEffect(e2)			
				end 
		end
	end
end
function c33400427.xyzfilter(c)
	return c:IsSetCard(0x9343) and c:IsXyzSummonable(nil)
end
function c33400427.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33400427.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33400427.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33400427.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)	
		 if Duel.XyzSummon(tp,tg:GetFirst(),nil) and  not Duel.IsExistingMatchingCard(c33400427.spcfilter,tp,LOCATION_MZONE,0,1,nil) then
				if  Duel.IsExistingMatchingCard(c33400427.spcfilter,tp,0,LOCATION_MZONE,1,nil)   
				or
				  (  Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and 
					(Duel.IsExistingMatchingCard(c33400427.cccfilter1,tp,LOCATION_SZONE,0,1,nil) or 
					Duel.IsExistingMatchingCard(c33400427.cccfilter2,tp,LOCATION_MZONE,0,1,nil) 
					)
				  )
				then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
				e2:SetValue(aux.tgoval)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tg:GetFirst():RegisterEffect(e2)			
				end 
		   end
	end
end

 