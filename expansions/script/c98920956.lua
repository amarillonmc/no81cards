--冰水之角闪石精
function c98920956.initial_effect(c)
	--token
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920956,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98921956)
	e4:SetCost(c98920956.spcost0)
	e4:SetTarget(c98920956.sptg0)
	e4:SetOperation(c98920956.spop0)
	c:RegisterEffect(e4)	
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920956,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920956)
	e1:SetCost(c98920956.spcost)
	e1:SetTarget(c98920956.sptg)
	e1:SetOperation(c98920956.spop)
	c:RegisterEffect(e1)
	--spsummon 2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920956,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,87074381)
	e3:SetCondition(c98920956.spcon2)
	e3:SetTarget(c98920956.sptg2)
	e3:SetOperation(c98920956.spop2)
	c:RegisterEffect(e3)
end
function c98920956.spcost0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c98920956.sptg0(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,18494512,0x16c,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c98920956.spop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,18494512,0x16c,TYPES_TOKEN_MONSTER,0,0,3,RACE_AQUA,ATTRIBUTE_WATER)
			then
			local token=Duel.CreateToken(tp,18494512)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetRange(LOCATION_MZONE)
			e1:SetAbsoluteRange(tp,1,0)
			e1:SetTarget(c98920956.splimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
			Duel.SpecialSummonComplete()
	end
end
function c98920956.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_WATER) and c:IsLocation(LOCATION_EXTRA)
end
function c98920956.rfilter(c,e,tp)
	return c:IsSetCard(0x16c) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c98920956.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function c98920956.spfilter(c,e,tp,code)
	return c:IsSetCard(0x16c) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920956.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920956.rfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c98920956.rfilter,1,1,nil,e,tp)
	e:SetLabel(g:GetFirst():GetCode())
	Duel.Release(g,REASON_COST)
end
function c98920956.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920956.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920956.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920956.sfilter(c,tp)
	return c:IsLevelAbove(7) and c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_WATER)~=0
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c98920956.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920956.sfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c98920956.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920956.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end