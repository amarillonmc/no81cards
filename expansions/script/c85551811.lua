--虚空魔术师之杖
function c85551811.initial_effect(c)
	aux.AddCodeList(c,46986414)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),3,2,c85551811.ovfilter,aux.Stringid(85551811,1))
	c:EnableReviveLimit()
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--xyz summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(45702014,2))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,85551811)
	e2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e2:SetTarget(c85551811.xyztg)
	e2:SetOperation(c85551811.xyzop)
	c:RegisterEffect(e2)
	--Activate in deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(85551811)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c85551811.atcon)
	c:RegisterEffect(e1)
	--
	if not c85551811.globle_check then
		c85551811.globle_check=true
		--Activate in deck
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ACTIVATE_COST)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetTargetRange(1,0)
		e1:SetCost(c85551811.costchk)
		e1:SetTarget(c85551811.actarget)
		e1:SetOperation(c85551811.costop)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		Duel.RegisterEffect(e2,1)
		local g=Duel.GetMatchingGroup(c85551811.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local te=tc:GetActivateEffect()
			local e2=te:Clone()
			e2:SetDescription(aux.Stringid(45702014,0))
			e2:SetProperty(te:GetProperty(),EFFECT_FLAG2_COF)
			e2:SetRange(LOCATION_DECK)
			tc:RegisterEffect(e2)
		end
	end
end
function c85551811.ovfilter(c)
	return c:IsLevelBelow(3) and aux.IsCodeListed(c,46986414) and c:IsFaceup()
end
function c85551811.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,85551811)==0 end
	Duel.RegisterFlagEffect(tp,85551811,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c85551811.xyzfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsXyzSummonable(nil)
end
function c85551811.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c85551811.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():IsAbleToExtra() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c85551811.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c85551811.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_EXTRA) and g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.GetMatchingGroup(c85551811.xyzfilter,tp,LOCATION_EXTRA,0,nil)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end
function c85551811.atcon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c85551811.filter(c)
	return aux.IsCodeListed(c,46986414) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c85551811.costchk(e,te_or_c,tp)
	return Duel.IsPlayerAffectedByEffect(tp,85551811) and Duel.GetFlagEffect(tp,85551812)==0 and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_EFFECT)
end
function c85551811.actarget(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(tc)
	return aux.IsCodeListed(tc,46986414) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_DECK)
end
function c85551811.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,85551811)
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_EFFECT)
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	Duel.RegisterFlagEffect(tp,85551812,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
