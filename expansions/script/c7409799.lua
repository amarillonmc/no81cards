--污手党执行者
function c7409799.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7409799,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7409799)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7409799.condition)
	e1:SetCost(c7409799.spcost)
	e1:SetTarget(c7409799.sptg)
	e1:SetOperation(c7409799.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7409799,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCost(c7409799.drcost)
	e2:SetTarget(c7409799.drtg)
	e2:SetOperation(c7409799.drop)
	c:RegisterEffect(e2)
end
c7409799.Grimy_Goons=true
function c7409799.Grimy_Goons_filter(c)
	return c.Grimy_Goons
end
function c7409799.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()~=tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c7409799.cffilter(c)
	return c.Grimy_Goons and not c:IsPublic() and not c:IsCode(7409799)
end
function c7409799.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7409799.cffilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c7409799.cffilter,tp,LOCATION_HAND,0,1,1,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(7409799,3))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	g:GetFirst():RegisterEffect(e1)
end
function c7409799.filter(c,tc)
	return c:IsCanBeBattleTarget(tc) 
end
function c7409799.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c7409799.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7409799.filter,tp,0,LOCATION_MZONE,1,nil,e:GetHandler()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c7409799.filter,tp,0,LOCATION_MZONE,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7409799.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_ATTACK) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK)==0 then return end
	if tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsCanBeBattleTarget(c) and tc:IsControler(1-tp)
		and tc:IsLocation(LOCATION_MZONE) then
		Duel.CalculateDamage(c,tc)
	end
end
function c7409799.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c7409799.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c7409799.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==1 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(7409799,3))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
		end
	end
end
