--桃绯武士 槙数马
function c9910515.initial_effect(c)
	c:EnableReviveLimit()
	--ritual summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910515,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9910515)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910515.atktg)
	e1:SetOperation(c9910515.atkop)
	c:RegisterEffect(e1)
	--set card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RELEASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,9910516)
	e2:SetOperation(c9910515.regop)
	c:RegisterEffect(e2)
	c9910515.tsukisome_release_effect=e2
end
function c9910515.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetAttack()>c:GetBaseAttack() and #g>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:SetLabel(c:GetAttack()-c:GetBaseAttack())
end
function c9910515.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local label=e:GetLabel()
	if label<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) then g:AddCard(c) end
	if #g>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(-label)
			tc:RegisterEffect(e1)
		end
	end
end
function c9910515.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_END then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_END,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_END)
	end
	e1:SetCondition(c9910515.setcon)
	e1:SetOperation(c9910515.setop)
	Duel.RegisterEffect(e1,tp)
end
function c9910515.setfilter(c,e,tp)
	if not c:IsSetCard(0xa950) or not c:IsFaceupEx() then return false end
	if c:IsType(TYPE_MONSTER) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
	else return c:IsSSetable() end
end
function c9910515.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c9910515.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
end
function c9910515.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910515)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910515.setfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsType(TYPE_MONSTER) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SSet(tp,tc)
		end
	end
end
