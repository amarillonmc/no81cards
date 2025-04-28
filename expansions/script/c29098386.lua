--方舟骑士团-歌蕾蒂娅
c29098386.named_with_Arknight=1
function c29098386.initial_effect(c)
	--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29098386,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e3:SetCountLimit(1,29098386)
	e3:SetCost(c29098386.cost)
	e3:SetCondition(c29098386.con)
	e3:SetTarget(c29098386.sptg)
	e3:SetOperation(c29098386.spop)
	c:RegisterEffect(e3)
	--control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29098387,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,29098387)
	e1:SetCost(c29098386.cost)
	e1:SetCondition(c29098386.descon)
	e1:SetTarget(c29098386.destg)
	e1:SetOperation(c29098386.desop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(29098386,ACTIVITY_CHAIN,c29098386.chainfilter)
end
--e4
function c29098386.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c29098386.hodfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c29098386.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tg=Duel.SelectMatchingCard(tp,c29098386.hodfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
		if tc:IsAbleToHand() and (not tc:IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(29098386,3),aux.Stringid(29098386,4))==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		elseif tc:IsAbleToDeck() then
			Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
end
--cost
function c29098386.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	return (rc:IsSetCard(0x87af) and rc:IsAttribute(ATTRIBUTE_WATER)) or not re:IsActiveType(TYPE_MONSTER) or not rc:IsAttribute(ATTRIBUTE_WATER)
end
function c29098386.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(29098386,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c29098386.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29098386.aclimit(e,re,tp)
	return not re:GetHandler():IsSetCard(0x87af) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
--e1
function c29098386.descon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c29098386.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsControlerCanBeChanged,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end   
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c29098386.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectMatchingCard(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.GetControl(g:GetFirst(),tp,PHASE_END,1)
	end
end
--e2
function c29098386.target(e,c)
	return c:IsRace(RACE_FISH)
end
--e3
function c29098386.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function c29098386.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c29098386.cfilter,1,nil,1-tp) and not eg:IsContains(e:GetHandler())
end
function c29098386.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c29098386.hodfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:IsAbleToDeck() or c:IsAbleToHand())
end
function c29098386.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
			if c:IsSummonLocation(LOCATION_GRAVE) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
				e1:SetValue(LOCATION_REMOVED)
				e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
				c:RegisterEffect(e1,true)
			end
			local g=Duel.GetMatchingGroup(c29098386.hodfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(29098386,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local dg=g:Select(tp,1,1,nil)
				if dg:GetFirst():IsAbleToHand() and (not dg:GetFirst():IsAbleToDeck() or Duel.SelectOption(tp,aux.Stringid(29098386,3),aux.Stringid(29098386,4))==0) then
					Duel.SendtoHand(dg,nil,REASON_EFFECT)
				elseif dg:GetFirst():IsAbleToDeck() then   
					Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
				end
			end
		end
	end
end

















