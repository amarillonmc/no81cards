-- 关灯的瞬间
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.yume_nikki) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71400001,0)
		yume.import_flag=false
	end
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(yume.YumeCon)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsCode(71400082) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function s.retfilter(c)
	return c:IsCode(71400079) and c:IsExtraDeckMonster()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function s.rmfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c~=tc and c:IsAbleToRemove(POS_FACEDOWN)
end
function s.rmfilter2(c)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.TossDice(tp,1)
	if d==1 then
		local g1=Duel.GetMatchingGroup(s.retfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g1>0 then
			local ct=Duel.SendtoDeck(g1,nil,SEQ_DECKTOP,REASON_EFFECT)
			if ct==0 or g1:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)==0 then
				return
			end
		end
		if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
			return
		end
		local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if #g2>0 and Duel.GetLocationCountFromEx(tp,tp,nil,nil)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g2:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc and Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
				Duel.SpecialSummonComplete()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local ct=0
				local rg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.rmfilter),tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,0,99,tc)
				if #rg>0 then
					Duel.BreakEffect()
					ct=Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
				end
				if ct==0 or rg:FilterCount(s.rmfilter2,nil)==0 then
					return
				end
				local h1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
				local h2=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
				if #h1>0 and #h2>0 and h1:IsExists(Card.IsAbleToRemove,1,nil,tp,POS_FACEDOWN)
					and h2:IsExists(Card.IsAbleToRemove,1,nil,1-tp,POS_FACEDOWN) then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local hg=h1:Select(tp,1,1,nil)
					Duel.Remove(hg,POS_FACEDOWN,REASON_EFFECT,tp)
					Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
					local hg2=h2:Select(1-tp,1,1,nil)
					Duel.Remove(hg2,POS_FACEDOWN,REASON_EFFECT,1-tp)
				end
			end
		end
	elseif d>=2 and d<=5 then
		if c:IsRelateToChain() and c:IsCanTurnSet() then
			c:CancelToGrave()
			Duel.ChangePosition(c,POS_FACEDOWN)
			Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		end
	end
end
