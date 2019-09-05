--紫阳散华(注：狸子DIY)
function c77770036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,77770036)
	e1:SetTarget(c77770036.target)
	e1:SetOperation(c77770036.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c77770036.tdcost)
	e2:SetTarget(c77770036.tdtg)
	e2:SetOperation(c77770036.tdop)
	c:RegisterEffect(e2)
end
function c77770036.spfilter(c,e,tp)
	return c:IsCode(77770037) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c77770036.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,777700361,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c77770036.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,777700361,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then return end
	local token=Duel.CreateToken(tp,777700361)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 then
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c77770036.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(77770036,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			if sg:GetCount()>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
			local e1=Effect.CreateEffect(e:GetHandler())
	       e1:SetType(EFFECT_TYPE_FIELD)
	       e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	       e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	       e1:SetTargetRange(1,0)
	       e1:SetTarget(c77770036.splimit)
	       e1:SetReset(RESET_PHASE+PHASE_END,2)
	       Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c77770036.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end
function c77770036.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c77770036.tdfilter(c)
	return c:IsCode(77770034) and c:IsAbleToDeck()
end
function c77770036.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c77770036.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77770036.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c77770036.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77770036.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	if tc:IsLocation(LOCATION_EXTRA) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end