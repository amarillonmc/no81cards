function c10111172.initial_effect(c)
	aux.AddCodeList(c,10111169)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c10111170.val)
	c:RegisterEffect(e1)
	--defup
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,10111172)
	e3:SetCost(c10111172.spcost)
	e3:SetTarget(c10111172.sptg)
	e3:SetOperation(c10111172.spop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c10111172.actcon)
	e4:SetTarget(c10111172.rmtarget)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
end
function c10111170.val(e,c)
	return Duel.GetMatchingGroupCount(c10111170.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())*100
end
function c10111172.cfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsDiscardable()
end
function c10111172.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10111172.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c10111172.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c10111172.thfilter(c)
	return aux.IsCodeOrListed(c,10111169) and c:IsAbleToHand()
end
function c10111172.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c10111172.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c10111172.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0
		and Duel.IsExistingMatchingCard(c10111172.thfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c10111172.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c10111172.cfilter1(c)
	return c:IsCode(10111169) and c:IsFaceup()
end
function c10111172.actcon(e)
	return Duel.IsExistingMatchingCard(c10111172.cfilter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c10111172.rmtarget(e,c)
	return c:GetOriginalType()&(TYPE_MONSTER+TYPE_SPELL)~=0 and c:GetOwner()~=e:GetHandlerPlayer()
end