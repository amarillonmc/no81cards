--判决牢狱的囚犯 10杠琴子
function c19209539.initial_effect(c)
	aux.AddCodeList(c,19209511)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--pendulum effect
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,19209539)
	e1:SetCondition(c19209539.pscon)
	e1:SetCost(c19209539.pscost)
	e1:SetTarget(c19209539.pstg)
	e1:SetOperation(c19209539.psop)
	c:RegisterEffect(e1)
	--monster effect
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209540)
	e2:SetCondition(c19209539.spcon)
	e2:SetTarget(c19209539.sptg)
	e2:SetOperation(c19209539.spop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,19209541)
	e3:SetCondition(c19209539.descon)
	e3:SetTarget(c19209539.destg)
	e3:SetOperation(c19209539.desop)
	c:RegisterEffect(e3)
end
function c19209539.pscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,e:GetHandler(),19209511)
end
function c19209539.pscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c19209539.pstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_PZONE,0,e:GetHandler(),19209511):GetFirst()
	Duel.SetTargetCard(tc)
	local t={}
	local p=1
	for i=1,11 do
		if i~=tc:GetLeftScale() then
			t[p]=i
			p=p+1
		end
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(ac)
end
function c19209539.setfilter(c)
	return c:IsCode(19209548) and c:IsSSetable()
end
function c19209539.psop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LSCALE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RSCALE)
		tc:RegisterEffect(e2)
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c19209539.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209539,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			if sc then Duel.SSet(tp,sc) end
		end
	end
end
function c19209539.chkfilter(c)
	return c:IsCode(19209511) and c:IsFaceup()
end
function c19209539.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c19209539.chkfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil)
end
function c19209539.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c19209539.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c19209539.descon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c19209539.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3b50)
end
function c19209539.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c19209539.desfilter,tp,LOCATION_EXTRA,0,1,nil) end
	local g=Duel.GetMatchingGroup(c19209539.desfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c19209539.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c19209539.desfilter,tp,LOCATION_EXTRA,0,1,3,nil)
	if #g==0 then return end
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,ct,nil) and Duel.SelectYesNo(tp,aux.Stringid(19209539,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,ct,ct,nil)
		Duel.HintSelection(dg)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
