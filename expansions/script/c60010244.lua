--双极盛怒
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60002134)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(aux.nbtg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.cfilter1(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_MZONE)) or c:IsLocation(LOCATION_GRAVE))
		and (c:IsLevelAbove(5) or c:IsRankAbove(5)) and c:IsAbleToDeck()
end
function cm.cfilter2(c)
	return ((c:IsFaceup() and c:IsLocation(LOCATION_SZONE)) or c:IsLocation(LOCATION_GRAVE))
		and c:IsCode(60002134) and c:IsAbleToDeck()
end
function cm.cfilter3(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.bkfil(c)
	return c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_EXTRA)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return  (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_SZONE+LOCATION_GRAVE,0,2,nil)
		and (Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+1,e,tp)
		or Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+2,e,tp)
		or Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+3,e,tp))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not (Duel.IsExistingMatchingCard(cm.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_SZONE+LOCATION_GRAVE,0,2,nil)
		and (Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+1,e,tp)
		or Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+2,e,tp)
		or Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_EXTRA,0,1,nil,m+3,e,tp))) then return end
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) and Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_REMOVED) and not tc:IsReason(REASON_REDIRECT) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(0,1)
		e1:SetValue(cm.aclimit)
		e1:SetLabelObject(tc)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,cm.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_SZONE+LOCATION_GRAVE,0,2,2,nil)
		g1:Merge(g2)
		if Duel.SendtoDeck(g1,nil,2,REASON_EFFECT):Filter(cm.bkfil,nil)==#g1 then
			local ga=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_EXTRA,0,nil,m+1,e,tp)
			local gb=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_EXTRA,0,nil,m+2,e,tp)
			local gc=Duel.GetMatchingGroup(cm.cfilter3,tp,LOCATION_EXTRA,0,nil,m+3,e,tp)
			ga:Merge(gb):Merge(gc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)   
			local sc=ga:Select(tp,1,1,nil):GetFirst()
			if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(500)
				sc:RegisterEffect(e1)
				Card.RegisterFlagEffect(sc,60002134,RESET_EVENT+RESETS_STANDARD,0,1) --card 
				Duel.RegisterFlagEffect(tp,60002134,RESET_PHASE+PHASE_END,0,1) --ply t turn
				Duel.RegisterFlagEffect(tp,60002135,RESET_PHASE+PHASE_END,0,1000) --ply fore
				if Duel.GetFlagEffect(tp,60002134)>=2 then 
					Duel.Draw(tp,1,REASON_EFFECT)
				end
				if Duel.GetFlagEffect(tp,60002134)>=4 then 
					Duel.Damage(1-tp,500,REASON_EFFECT)
					Duel.Recover(tp,500,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.aclimit(e,re,tp)
	local c=re:GetHandler()
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end