--地缚伪神官
function c98921074.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98921074,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98921074)
	e1:SetTarget(c98921074.settg)
	e1:SetOperation(c98921074.setop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98921074,1))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98931074)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(c98921074.spcon1)
	e2:SetTarget(c98921074.sumtg)
	e2:SetOperation(c98921074.sumop)
	c:RegisterEffect(e2)
end
function c98921074.setfilter(c)
	return c:IsCode(44710391) and c:IsSSetable()
end
function c98921074.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921074.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c98921074.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c98921074.thfilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER) and c:IsSetCard(0x21) and c:IsAbleToHand()
end
function c98921074.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c98921074.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SSet(tp,g:GetFirst())~=0 then
		   local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c98921074.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		   if #g>0 then
			  Duel.BreakEffect()
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			  local tag=g:Select(tp,1,1,nil)
			  Duel.SendtoHand(tag,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,tag)
			  Duel.ShuffleDeck(tp)
		   end
		end
	end
		local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetValue(c98921074.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98921074.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSummonType(SUMMON_TYPE_SPECIAL) and rc:IsLocation(LOCATION_MZONE) and not rc:IsSetCard(0x21)
end
function c98921074.sumfilter(c)
	if not c:IsSetCard(0x1021) then return false end
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98921074,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c98921074.sumcon1)
	e0:SetOperation(c98921074.sumop1)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)	
	local res=c:IsSummonable(true,nil)
	e0:Reset()
	return res
end
function c98921074.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c98921074.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c98921074.sumcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98921074.rmfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(c98921074.rmfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c98921074.sumop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c98921074.rmfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c98921074.rmfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	c:SetMaterial(nil)
end
function c98921074.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98921074.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c98921074.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c98921074.sumfilter,tp,LOCATION_HAND,0,1,1,nil,c):GetFirst()
	if tc then
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(98921074,0))
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_SUMMON_PROC)
		e0:SetCondition(c98921074.sumcon1)
		e0:SetOperation(c98921074.sumop1)
		e0:SetValue(SUMMON_TYPE_ADVANCE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e0)	
		Duel.Summon(tp,tc,true,nil,1)
	end
end