--萨尔贡·近卫干员-燧石
function c79029316.initial_effect(c)
	c:SetUniqueOnField(1,0,79029316)	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79029316)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c79029316.sptg)
	e1:SetOperation(c79029316.spop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c79029316.tgcon)
	e3:SetTarget(c79029316.tgtg)
	e3:SetOperation(c79029316.tgop)
	c:RegisterEffect(e3)
end
function c79029316.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c79029316.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("哼，来得好！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029316,0))
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	c:SetCardTarget(tc)
	c:RegisterFlagEffect(79029316,RESET_EVENT+RESETS_STANDARD,0,0)
	--to hand 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(c79029316.desop)
	e2:SetLabelObject(c)
	tc:RegisterEffect(e2)   
	local xg=Group.FromCards(c,tc)   
	xg:KeepAlive()  
	--
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetLabelObject(xg)
		e1:SetValue(c79029316.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetLabelObject(xg)
		e1:SetValue(c79029316.imfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	--atk limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	e4:SetValue(c79029316.atlimit)
	tc:RegisterEffect(e4)
end
function c79029316.desop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(79029316)==0 then return end
	Debug.Message("呿，那种小喽啰，逃了就逃了吧，没必要追。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029316,2))
	Duel.Hint(HINT_CARD,0,79029316)
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
function c79029316.imfilter(e,te)
	local g=e:GetLabelObject()
	return not g:IsContains(te:GetOwner())
end
function c79029316.atlimit(e,c)
	return c~=e:GetOwner()
end
function c79029316.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c79029316.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c79029316.tgop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("这拳如何！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029316,1))
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end















