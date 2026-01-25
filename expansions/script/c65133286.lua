--幻叙霸皇 红发香克斯
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	--Unaffected
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.immval)
	c:RegisterEffect(e1)
	--Chain Trigger
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	--e2:SetCondition(s.chcon)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
	--Spsummon from Hand (Effect 3)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.spcon_add)
	e3:SetTarget(s.sptg_add)
	e3:SetOperation(s.spop_add)
	c:RegisterEffect(e3)
end
function s.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x838) or se:GetHandler()==e:GetHandler()
end
function s.immval(e,te)
	if te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()==1-e:GetHandlerPlayer() then
		if c:GetOriginalLevel()>0 and c:GetOriginalLevel()<sc:GetLevel() then return true end
		if c:GetOriginalRank()>0 and c:GetOriginalRank()<sc:GetRank() then return true end
		if c:GetLink()>0 and c:GetLink()<sc:GetLink() then return true end
		if c:GetBaseAttack()>=0 and c:GetBaseAttack()<sc:GetAttack() then return true end
		if not c:IsType(TYPE_LINK) and c:GetBaseDefense()>=0 and c:GetBaseDefense()<sc:GetDefense() then return true end
	end
	return false
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-tp
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetFlagEffect(tp,id+1)==0
	local b2=c:IsLocation(LOCATION_MZONE) and Duel.GetFlagEffect(tp,id+2)==0
	local b3=c:IsLocation(LOCATION_MZONE) and Duel.GetFlagEffect(tp,id+3)==0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,1,nil,tp)
	if not b1 and not b2 and not b3 then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,1)},
		{b2,aux.Stringid(id,2)},
		{b3,aux.Stringid(id,3)},
		{true,aux.Stringid(id,4)})
	Duel.RegisterFlagEffect(tp,id+op,RESET_PHASE+PHASE_END,0,1)
	if op==1 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	elseif op==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(s.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	elseif op==3 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
		if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			local og=Duel.GetOperatedGroup()
			local fid=c:GetFieldID()
			for tc in aux.Next(og) do
				tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			end
			og:KeepAlive()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(fid)
			e1:SetLabelObject(og)
			e1:SetCountLimit(1)
			e1:SetOperation(s.retop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local fid=e:GetLabel()
	local sg=g:Filter(s.retfilter,nil,fid)
	if #sg>0 then
		for tc in aux.Next(sg) do
			Duel.ReturnToField(tc)
		end
	end
	g:DeleteGroup()
end
function s.retfilter(c,fid)
	return c:GetFlagEffectLabel(id)==fid
end
function s.spcon_add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c) and not c:IsPreviousLocation(LOCATION_DECK)
end
function s.sptg_add(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop_add(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		--Gain Effect
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,5))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
		e1:SetTarget(s.destg)
		e1:SetOperation(s.desop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function s.desfilter(c,sc)
	if c:GetOriginalLevel()>0 and c:GetOriginalLevel()<sc:GetLevel() then return true end
	if c:GetOriginalRank()>0 and c:GetOriginalRank()<sc:GetRank() then return true end
	if c:GetLink()>0 and c:GetLink()<sc:GetLink() then return true end
	if c:GetBaseAttack()>=0 and c:GetBaseAttack()<sc:GetAttack() then return true end
	if not c:IsType(TYPE_LINK) and c:GetBaseDefense()>=0 and c:GetBaseDefense()<sc:GetDefense() then return true end
	return false
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),e:GetHandler()) end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler(),e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToChain() or not c:IsFaceup() then return end
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end