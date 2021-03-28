--地狱使者亲临
function c60159915.initial_effect(c)
	aux.AddCodeList(c,60159914)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60159915.target)
	e1:SetOperation(c60159915.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60159915,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(c60159915.descost)
	e2:SetTarget(c60159915.destg)
	e2:SetOperation(c60159915.activate)
	c:RegisterEffect(e2)
end
c60159915.fit_monster={60159914}
function c60159915.filter(c,e,tp,m)
	if not c:IsCode(60159914) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) 
		or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumGreater(Card.GetRitualLevel,10,c)
end
function c60159915.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		mg:RemoveCard(e:GetHandler())
		local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
		if ct1>ct2 then
			return Duel.IsExistingMatchingCard(c60159915.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		else
			return Duel.IsExistingMatchingCard(c60159915.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60159915.operation(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ct1=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if ct1>ct2 then
		local tg=Duel.SelectMatchingCard(tp,c60159915.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
		local tc=tg:GetFirst()
		if tc then
			if tc:IsLocation(LOCATION_GRAVE) then Duel.HintSelection(tg) end
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	else
		local tg=Duel.SelectMatchingCard(tp,c60159915.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg)
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			if tc.mat_filter then
				mg=mg:Filter(tc.mat_filter,nil)
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,10,tc)
			tc:SetMaterial(mat)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c60159915.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c60159915.filter2(c)
	return c:IsFaceup() and c:IsCode(60159914) and c:IsAbleToHand()
end
function c60159915.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c60159915.filter2,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c60159915.filter2,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c60159915.spfilter(c,e,tp)
	return c:IsCode(60159914) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)
end
function c60159915.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc2=Duel.GetFirstTarget()
	if tc2:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc2,nil,REASON_EFFECT)>0 then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(c60159915.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(60159915,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				local tc=sg:GetFirst()
				if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,true,POS_FACEUP) then
					local e3=Effect.CreateEffect(e:GetHandler())
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_IMMUNE_EFFECT)
					e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
					e3:SetRange(LOCATION_MZONE)
					e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+RESET_CHAIN)
					e3:SetValue(c60159915.efilter)
					tc:RegisterEffect(e3,true)
					Duel.SpecialSummonComplete()
				end
			end
		end
	end
end
function c60159915.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
