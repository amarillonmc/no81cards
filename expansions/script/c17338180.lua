--·菜月昴·肃清王·
local s,id,o=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	aux.AddCodeList(c,17337630,17338170,17337400)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_CANNOT_ACTIVATE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,0)
	e0:SetValue(s.aclimit)
	c:RegisterEffect(e0)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.sscon)
	e2:SetTarget(s.sstg)
	e2:SetOperation(s.ssop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_COIN+CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.coincon)
	e3:SetTarget(s.cointg)
	e3:SetOperation(s.coinop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(1153)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.setcon)
	e4:SetTarget(s.settg)
	e4:SetOperation(s.setop)
	c:RegisterEffect(e4)
end
function s.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return not (rc:IsSetCard(0x3f50) or re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x5f50))
end
function s.sscon(e,tp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)==0
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.panfilter(c)
	return c:IsCode(17338170) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.panfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
function s.coincon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function s.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function s.coinop(e,tp,eg,ep,ev,re,r,rp)
	local res=Duel.TossCoin(tp,1)
	if res==1 and Duel.IsChainDisablable(ev) then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	else
		Duel.Recover(tp,1000,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(s.subaru_pick,tp,LOCATION_DECK,0,nil)
		if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			Duel.BreakEffect()
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			else
				Duel.SendtoGrave(tc,REASON_EFFECT)
			end
		end
	end
end
function s.subaru_pick(c)
	return aux.IsCodeListed(c,17337400) and not c:IsCode(id) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_LINK and e:GetHandler():GetReasonCard():IsSetCard(0x5f50)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsCode(17337630) and c:IsSSetable() end,tp,LOCATION_DECK,0,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(17337630) and c:IsSSetable() end,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end