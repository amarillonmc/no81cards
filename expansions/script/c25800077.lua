
function c25800077.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,c25800077.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	c:EnableReviveLimit()

	aux.EnableChangeCode(c,25800080,LOCATION_MZONE+LOCATION_GRAVE)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25800077,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c25800077.rmcon)
	e2:SetTarget(c25800077.remtg)
	e2:SetOperation(c25800077.remop)
	c:RegisterEffect(e2)

end
function c25800077.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsSetCard(0x211)
end
function c25800077.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c25800077.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function c25800077.remop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,2,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end