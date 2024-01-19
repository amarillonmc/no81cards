--桃绯崛起
function c9910512.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910512+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c9910512.target)
	e1:SetOperation(c9910512.activate)
	c:RegisterEffect(e1)
end
function c9910512.spfilter(c,e,tp)
	return c:IsSetCard(0xa950) and c:IsLevel(4) and c:GetType()&0x81==0x81 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9910512.filter(c,e,tp)
	local b1=c:GetAttack()<c:GetBaseAttack() and Duel.IsExistingMatchingCard(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,nil)
	local b2=c:GetAttack()>c:GetBaseAttack() and Duel.IsExistingMatchingCard(c9910512.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	return c:IsFaceup() and (b1 or b2)
end
function c9910512.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910512.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c9910512.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910512.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
end
function c9910512.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local batk=tc:GetBaseAttack()
		if atk<batk then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,Card.IsCanTurnSet,tp,0,LOCATION_MZONE,1,2,nil)
			if g:GetCount()>0 then
				Duel.HintSelection(g)
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		elseif atk>batk then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-1000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=Duel.SelectMatchingCard(tp,c9910512.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
			if sc then
				Duel.SpecialSummon(sc,SUMMON_VALUE_NOUVELLEZ,tp,tp,true,false,POS_FACEUP)
			end
		end
	end
end
