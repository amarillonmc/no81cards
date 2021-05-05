--苍岚霸龙 荣光灾漩
function c40009129.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),7,2,c40009129.ovfilter,aux.Stringid(40009129,0),2,c40009129.xyzop)
	c:EnableReviveLimit()	
end
function c40009129.cfilter(c)
	return c:IsSetCard(0x7f1d) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c40009129.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6f1d)
end
function c40009129.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009129.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFlagEffect(tp,28346136)==0 end
	Duel.DiscardHand(tp,c40009129.cfilter,1,1,REASON_COST,nil)
	Duel.RegisterFlagEffect(tp,28346136,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end