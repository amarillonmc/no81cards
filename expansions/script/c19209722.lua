--乐士奏音 《天使之歌》
function c19209722.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c19209722.target)
	e1:SetOperation(c19209722.activate)
	c:RegisterEffect(e1)
end
function c19209722.tffilter(c,tp)
	return c:IsCode(19209696) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c19209722.cfilter(c,tp)
	return c:IsCode(19209720) and c:IsFaceup() and c:IsAbleToDeckAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c19209722.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xb53) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c19209722.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c19209722.tffilter,tp,LOCATION_DECK,0,1,nil,tp)
	local b2=false
	local ct=Duel.GetChainInfo(0,CHAININFO_CHAIN_COUNT)
	if Duel.IsExistingMatchingCard(c19209722.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingMatchingCard(c19209722.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,0) and ct and ct>=1 then
		local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER)
		if p~=tp and te:IsActiveType(TYPE_MONSTER) and te:GetActivateLocation()==LOCATION_MZONE then b2=true end
	end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(19209722,0)},
		{b2,aux.Stringid(19209722,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(0)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c19209722.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SSET)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function c19209722.setfilter(c)
	return c:IsSetCard(0xb53) and c:IsType(TYPE_QUICKPLAY+TYPE_TRAP) and c:IsSSetable() and c:IsFaceupEx() and aux.NecroValleyFilter()(c)
end
function c19209722.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c19209722.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	elseif op==2 then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c19209722.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,1):GetFirst()
		local g=Duel.GetMatchingGroup(c19209722.setfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(19209722,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
			local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,2)
			Duel.SSet(tp,sg)
			for dc in aux.Next(sg) do
				if dc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(19209722,3))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					dc:RegisterEffect(e1)
				end
				if dc:IsType(TYPE_TRAP) then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(19209722,3))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					dc:RegisterEffect(e1)
				end
			end
		end
	end
end
