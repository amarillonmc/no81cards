--远古造物 狄更逊水母
Duel.LoadScript("c9910700.lua")
function c9910701.initial_effect(c)
	--flag
	QutryYgzw.AddTgFlag(c)
	--to deck top
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c9910701.tttg)
	e1:SetOperation(c9910701.ttop)
	c:RegisterEffect(e1)
end
function c9910701.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0xc950)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
end
function c9910701.ttop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(9910701,0))
	local g=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,nil,0xc950)
	local tc=g:GetFirst()
	if tc then
		Duel.ShuffleDeck(tp)
		Duel.MoveSequence(tc,0)
		Duel.ConfirmDecktop(tp,1)
		if Duel.IsPlayerCanSummon(tp) and Duel.IsPlayerCanAdditionalSummon(tp)
			and Duel.GetFlagEffect(tp,9910701)==0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(9910701,2))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
			e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
			e1:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			Duel.RegisterFlagEffect(tp,9910701,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
