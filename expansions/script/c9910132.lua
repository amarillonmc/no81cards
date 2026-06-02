--战车道少女·农娜
function c9910132.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910132)
	e1:SetCost(c9910132.spcost)
	e1:SetTarget(c9910132.sptg)
	e1:SetOperation(c9910132.spop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910133)
	e2:SetCondition(c9910132.descon)
	e2:SetTarget(c9910132.destg)
	e2:SetOperation(c9910132.desop)
	c:RegisterEffect(e2)
end
function c9910132.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910132.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910132.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local check=Duel.IsPlayerAffectedByEffect(tp,9910113) and c:IsCanOverlay()
		and Duel.IsExistingMatchingCard(c9910132.xfilter,tp,LOCATION_MZONE,0,1,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (c:IsAbleToDeck() or check) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910132.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x9958) and tc:IsType(TYPE_MONSTER) then
		if not c:IsRelateToEffect(e) then return end
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local lv=aux.SelectFromOptions(tp,{true,aux.Stringid(9910132,0),4},{true,aux.Stringid(9910132,1),5})
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(lv)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not tc:IsForbidden() then
				Duel.DisableShuffleCheck()
				Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local e2=Effect.CreateEffect(c)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				tc:RegisterEffect(e2)
			end
		else
			e1:Reset()
		end
	else
		local flag=false
		local off=1
		local ops={}
		local opval={}
		local b1=c:IsAbleToDeck()
		local check=Duel.IsPlayerAffectedByEffect(tp,9910113) and c:IsCanOverlay()
		local xg=Duel.GetMatchingGroup(c9910132.xfilter,tp,LOCATION_MZONE,0,nil)
		if c:IsAbleToDeck() then
			ops[off]=aux.Stringid(9910100,1)
			opval[off-1]=1
			off=off+1
		end
		if check and #xg>0 then
			ops[off]=aux.Stringid(9910100,2)
			opval[off-1]=2
			off=off+1
		end
		if off==1 then return end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			if flag then Duel.BreakEffect() end
			flag=Duel.SendtoDeck(c,nil,0,REASON_EFFECT)>0
		elseif opval[op]==2 then
			if flag then Duel.BreakEffect() end
			Duel.Hint(HINT_CARD,0,9910113)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local sg=xg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			if sg:GetFirst():IsImmuneToEffect(e) then return end
			Duel.Overlay(sg:GetFirst(),Group.FromCards(c))
			flag=true
		end
	end
end
function c9910132.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c9910132.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9910132.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
