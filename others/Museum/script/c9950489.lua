--圆桌骑士=骑士王
function c9950489.initial_effect(c)
	 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950489,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c9950489.sptg)
	e1:SetOperation(c9950489.spop)
	c:RegisterEffect(e1)
 --atk def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c9950489.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
  --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950489,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9950489)
	e1:SetTarget(c9950489.destg)
	e1:SetOperation(c9950489.desop)
	c:RegisterEffect(e1)
--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950489.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950489.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950489,0))
end
function c9950489.filter1(c,tp,mc)
	local g=Group.FromCards(c)
	if mc then g:AddCard(mc) end
	return (c:IsLocation(LOCATION_HAND+LOCATION_DECK) or c:IsFaceup()) and c:IsSetCard(0xcba5,0x3ba6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and Duel.GetMZoneCount(tp,g)>0
end
function c9950489.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9950489.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950489.filter1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_GRAVE) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9950489.value(e,c)
	return Duel.GetMatchingGroupCount(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_MONSTER)*300
end
function c9950489.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950489.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end