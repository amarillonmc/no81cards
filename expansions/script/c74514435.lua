--人偶·欧若拉
function c74514435.initial_effect(c)
	aux.EnableDualAttribute(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(74514435,0))
	e1:SetCategory(CATEGORY_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMING_SSET+TIMING_SUMMON+TIMING_SPSUMMON+TIMING_MAIN_END)
	e1:SetCondition(c74514435.sucon1)
	e1:SetCost(c74514435.sucost1)
	e1:SetTarget(c74514435.sutg)
	e1:SetOperation(c74514435.suop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(c74514435.sucon2)
	e2:SetCost(c74514435.sucost2)
	c:RegisterEffect(e2)
end
function c74514435.sucon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and not Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74514435.sucost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c74514435.sucon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsDualState() and aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,74590055)
end
function c74514435.sucost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Recover(tp,1000,REASON_COST)
end
function c74514435.filter(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function c74514435.sutg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c74514435.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c74514435.suop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.HintSelection(dg)
	if Duel.Destroy(dg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local g=Duel.SelectMatchingCard(tp,c74514435.filter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if tc:IsSummonable(true,nil) and (not tc:IsMSetable(true,nil)
				or Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) then
				Duel.Summon(tp,tc,true,nil)
			else Duel.MSet(tp,tc,true,nil) end
		end
	end
end
