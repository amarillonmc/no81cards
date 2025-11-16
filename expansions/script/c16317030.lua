--旋风战士 风翼抱拥
function c16317030.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,16317030)
	e1:SetCost(c16317030.cost)
	e1:SetTarget(c16317030.postg)
	e1:SetOperation(c16317030.posop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,16317030)
	e2:SetCondition(c16317030.con)
	e2:SetCost(c16317030.cost1)
	e2:SetTarget(c16317030.tg)
	e2:SetOperation(c16317030.op)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(16317030,ACTIVITY_SPSUMMON,c16317030.counterfilter)
end
function c16317030.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function c16317030.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16317030,tp,ACTIVITY_SPSUMMON)==0
		and e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16317030.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16317030.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16317030,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16317030.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16317030.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c16317030.con(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsSummonLocation,tp,LOCATION_MZONE,0,1,nil,LOCATION_EXTRA)
end
function c16317030.thfilter(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x5dc7) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c16317030.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetLevel())
end
function c16317030.spfilter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsSetCard(0x5dc7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16317030.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16317030.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16317030.thfilter1(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x5dc7) and c:IsAbleToHand()
end
function c16317030.spfilter1(c,e,tp)
	return c:IsLevelAbove(1) and c:IsSetCard(0x5dc7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c16317030.fselect(g,lv)
	return g:GetSum(Card.GetLevel)<=lv
end
function c16317030.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16317030.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		if Duel.SendtoHand(tc,nil,0x40)>0 and tc:IsLocation(0x2) then
			local lv=tc:GetLevel()
			local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
			if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
			local tg=Duel.GetMatchingGroup(c16317030.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
			if ft<=0 or #tg==0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=tg:SelectSubGroup(tp,c16317030.fselect,true,1,ft,lv)
			local sc=sg:GetFirst()
			while sc do
				Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				sc=sg:GetNext()
			end
			if Duel.SpecialSummonComplete()>0 then
				local g=Duel.GetMatchingGroup(c16317030.sumfilter,tp,LOCATION_HAND,0,nil)
				if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16317030,1)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
					local sc=g:Select(tp,1,1,nil):GetFirst()
					Duel.ShuffleHand(tp)
					Duel.Summon(tp,sc,true,nil,1)
				else
					Duel.ShuffleHand(tp)
				end
			end
		end	
	end
end
function c16317030.sumfilter(c)
	return c:IsSetCard(0x5dc7) and c:IsSummonable(true,nil,1)
end
function c16317030.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c16317030.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16317030.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c16317030.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c16317030.cfilter(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsSetCard(0x5dc7)
end
function c16317030.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c16317030.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)>0 then
			local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
			if Duel.IsExistingMatchingCard(c16317030.cfilter,tp,LOCATION_MZONE,0,1,nil)
				and sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(16317030,0)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local sg2=sg:Select(tp,1,1,nil)
				Duel.SendtoDeck(sg2,nil,2,0x40)
			end
		end
	end
end