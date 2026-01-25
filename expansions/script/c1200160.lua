--元素百科全书保管员
function c1200160.initial_effect(c)
	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1200160,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1200160.cltg)
	e1:SetOperation(c1200160.clop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1200160,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c1200160.sptg)
	e3:SetOperation(c1200160.spop)
	c:RegisterEffect(e3)

	
end
c1200160.div_table={1,4,5,2,3,6}
function c1200160.cltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	-- Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c1200160.clop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local ct=Duel.TossDice(tp,1)
		if ct>=1 and ct<=6 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(ct)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end

function c1200160.spfilter(c,ec,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5240) and c:GetLevel()%7~=0 and ec:GetLevel()%7~=0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1200195,0,TYPES_TOKEN_MONSTER,0,0,
			(c1200160.div_table[ec:GetLevel()%7]*c:GetLevel())% 7,RACE_SPELLCASTER,ATTRIBUTE_DARK)
end
function c1200160.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ec:IsFaceup()
		and Duel.IsExistingMatchingCard(c1200160.spfilter,tp,LOCATION_EXTRA,0,1,nil,ec,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1200160.relfilter(c)
	return c:IsSetCard(0x5240) and c:IsFaceup() and c:IsReleasableByEffect()
end
function c1200160.adfilter(c,f)
	return math.max(f(c),0)
end
function c1200160.spfilter2(c,e,tp,lv,ec)
	return (c:GetLevel()-lv)%7==0 and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5240)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1200160.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,c1200160.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,c,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Debug.Message(tc:GetLevel())
	local lv=(c1200160.div_table[c:GetLevel()%7]*tc:GetLevel())%7
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,1200195,0,TYPES_TOKEN_MONSTER,0,0,lv,RACE_SPELLCASTER,ATTRIBUTE_DARK) then
		
		local tk=Duel.CreateToken(tp,1200195)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetValue(lv)
		tk:RegisterEffect(e1,true)
		Duel.SpecialSummonStep(tk,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
		
		Duel.BreakEffect()
		--release
		local g=Duel.GetMatchingGroup(c1200160.relfilter,tp,LOCATION_MZONE,0,nil)
		local lv2=g:GetSum(c1200160.adfilter,Card.GetLevel)
		if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT)~=0 then
			local og=Duel.GetOperatedGroup()
			if og:GetCount()==0 then return end
			--检查能否特招
			local sg=Duel.GetMatchingGroup(c1200160.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,lv2,nil)
			if sg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sc=sg:Select(tp,1,1,nil):GetFirst()

				--特招并注册效果
				if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(1200160,1))
					e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
					e1:SetType(EFFECT_TYPE_IGNITION)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetCountLimit(1)
					e1:SetRange(LOCATION_MZONE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetTarget(c1200160.sptg)
					e1:SetOperation(c1200160.spop)
					sc:RegisterEffect(e1)
					
					sc:RegisterFlagEffect(1200161,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1200160,2))
					--自肃
					local e0=Effect.CreateEffect(e:GetHandler())
					e0:SetType(EFFECT_TYPE_FIELD)
					e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e0:SetTargetRange(1,0)
					e0:SetLabel(sc:GetAttribute())
					e0:SetTarget(c1200160.splimit)
					e0:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e0,tp)
					
				end
			end
		end		
	end
end
function c1200160.splimit(e,c)
	return c:IsAttribute(e:GetLabel()) and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x5240) 
end