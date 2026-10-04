--异能环合 卡厄斯
local s,id,o=GetID()
function c67201723.initial_effect(c)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(2,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)  
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)  
	Duel.AddCustomActivityCounter(id+1,ACTIVITY_CHAIN,s.chainfilter1) 
	Duel.AddCustomActivityCounter(id+2,ACTIVITY_CHAIN,s.chainfilter2) 
end
function s.chainfilter(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x567f) and re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_WATER))
end
function s.chainfilter1(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x567f) and re:GetHandler():IsAttribute(ATTRIBUTE_LIGHT))
end
function s.chainfilter2(re,tp,cid)
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x567f) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,tp,ACTIVITY_CHAIN)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and (Duel.GetCustomActivityCount(id+1,tp,ACTIVITY_CHAIN)>0 or Duel.GetCustomActivityCount(id+2,tp,ACTIVITY_CHAIN)>0) and Duel.SelectYesNo(tp,aux.Stringid(67201723,0)) then
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetCustomActivityCount(id+1,tp,ACTIVITY_CHAIN)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
			if tc:IsFaceup() then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(67201723,4))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
				e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3)  
			end
		end
		if Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.GetCustomActivityCount(id+2,tp,ACTIVITY_CHAIN)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local tc1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
			if tc1:IsFaceup() then
				--double battle damage
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCondition(c67201723.damcon)
				e2:SetCode(EFFECT_CHANGE_INVOLVING_BATTLE_DAMAGE)
				e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc1:RegisterEffect(e2)
			end
		end
	end
end
function c67201723.damcon(e)
	return e:GetHandler():GetBattleTarget():IsSetCard(0x567f)
end
