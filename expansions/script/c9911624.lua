--神械图腾 泄愤者
function c9911624.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--confirm
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,9911624)
	e4:SetTarget(c9911624.contg)
	e4:SetOperation(c9911624.conop)
	c:RegisterEffect(e4)
end
function c9911624.contg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function c9911624.tgfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0 and c:IsLevel(lv,math.floor(lv/2)) and c:IsAbleToGrave()
end
function c9911624.filter(c)
	return c:IsSetCard(0xc958,0xc954) and c:IsType(TYPE_MONSTER)
end
function c9911624.conop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c9911624.tgfilter,tp,LOCATION_DECK,0,1,nil,tc:GetLevel())
		and Duel.SelectYesNo(tp,aux.Stringid(9911624,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tg=Duel.SelectMatchingCard(tp,c9911624.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel())
		Duel.SendtoGrave(tg,REASON_EFFECT)
	end
	if (tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0) and tc:IsSSetable(true)
		and Duel.SelectYesNo(tp,aux.Stringid(9911624,1)) then
		Duel.DisableShuffleCheck()
		Duel.SSet(tp,tc)
	end
	if Duel.IsExistingMatchingCard(c9911624.filter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(9911624,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		Duel.HintSelection(rg)
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
	end
end
