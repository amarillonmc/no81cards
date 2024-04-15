--生命修复
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,RACE_MACHINE) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end

end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(Card.IsRace,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil,RACE_MACHINE) or Duel.GetLocationCount(tp,LOCATION_SZONE)==0 then return end
	local tc=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,RACE_MACHINE):Select(tp,1,1,nil):GetFirst()
	if not tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end