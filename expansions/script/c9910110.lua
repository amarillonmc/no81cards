--战车道少女·武部沙织
dofile("expansions/script/c9910100.lua")
function c9910110.initial_effect(c)
	--special summon
	QutryZcd.SelfSpsummonEffect(c,0,false,c9910110.exchk2,false,c9910110.beftd2,true,nil)
end
function c9910110.tofifilter(c)
	return c:IsSetCard(0x9958) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c9910110.exchk2(e,tp)
	return Duel.IsExistingMatchingCard(c9910110.tofifilter,tp,LOCATION_DECK,0,1,nil)
end
function c9910110.beftd2(e,tp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9910110.tofifilter,tp,LOCATION_DECK,0,1,1,nil)
	local fc=g:GetFirst()
	if not fc or not Duel.MoveToField(fc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	fc:RegisterEffect(e1)
	Duel.ShuffleDeck(tp)
	return true
end
