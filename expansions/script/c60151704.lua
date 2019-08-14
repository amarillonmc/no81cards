--天空的水晶部队 狡猾的女仆贼
function c60151704.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60151704,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60151704)
	e1:SetTarget(c60151704.target)
	e1:SetOperation(c60151704.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60151704,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,6011704)
	e3:SetTarget(c60151704.target2)
	e3:SetOperation(c60151704.operation2)
	c:RegisterEffect(e3)
end
function c60151704.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c60151704.operation(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if t:GetCount()==0 then return end
	Duel.ConfirmCards(tp,t)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_HAND,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local mt=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local st=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
		if tc:IsType(TYPE_MONSTER) then
			if tc:IsMSetable(true,nil) then
				if (tc:GetLevel()<=4 and mt>0) or (tc:GetLevel()>4 and tc:GetLevel()<=6 and mt>-1) or (tc:GetLevel()>6 and mt>-2) then
					Duel.MSet(1-tp,tc,true,nil)
				end
			elseif tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and mt>0 then
				Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			else
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		else
			if tc:IsSSetable(true) and (tc:IsType(TYPE_FIELD) or st>0) then
				Duel.SSet(tp,tc,1-tp)
				Duel.ConfirmCards(tp,tc)
			else
				Duel.SendtoHand(tc,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
	Duel.ShuffleHand(1-tp)
end
function c60151704.filter(c,e,tp)
	return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60151704.filter2(c,ft)
	if ft==0 then
		return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
			and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
	else
		return c:IsSetCard(0x3b26) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
			and ((c:IsLocation(LOCATION_MZONE) and c:IsFaceup()) or c:IsLocation(LOCATION_HAND))
	end
end
function c60151704.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingMatchingCard(c60151704.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,ft)
		and Duel.IsExistingTarget(c60151704.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c60151704.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	local g2=Duel.GetMatchingGroup(c60151704.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c60151704.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c60151704.filter2,tp,LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				if tc:IsRelateToEffect(e) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c60151704.filter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,ft)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Destroy(g,REASON_EFFECT)~=0 then
				if tc:IsRelateToEffect(e) then
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
