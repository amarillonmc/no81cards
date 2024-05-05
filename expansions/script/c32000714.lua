--抵抗巨炮 机炮连发

local s,id,o = GetID()
local zd = 0x3d4
function s.initial_effect(c)
	  c:SetUniqueOnField(1,0,id)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,zd),2)
	c:EnableReviveLimit()
	
	--SpSumWhenAdToHand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

  --SetSpellAndTrapWhenTurnEnd
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetTarget(s.e2tg)
	e2:SetCost(s.e2cost)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
	
	--cimmue neagea and disable
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	e3:SetValue(s.e3filter)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.e4filter)
	c:RegisterEffect(e4)
		
end

--e1

function s.e1destfilter(c)
	return c:IsSetCard(zd) and c:IsDestructable()
end

function s.e1spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_LINK)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e1spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0 end
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_HAND)
	
end

function s.e1con(e,tp,eg,ep,ev,re,r,rp,chk)
	return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK) and r==REASON_EFFECT
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.e1spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.e1spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	
	if not (Duel.IsExistingMatchingCard(s.e1desfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(tp,HINTMSG_TODECK)) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,s.e1desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Destroy(g2,nil,REASON_EFFECT)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g3=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local g4=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,tp,0,LOCATION_HAND,1,1,nil)
	Duel.SendtoDeck(g3+g4,nil,3,REASON_EFFECT)
	
end

--e2

function s.e2setfilter(c)
	return c:IsSetCard(zd) and c:IsType(TYPE_CONTINUOUS)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c = e:GetHandler()
  if chk == 0 then return Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 and Duel.IsExistingMatchingCard(s.e2setfilter,tp ,LOCATION_GRAVE,0,1,nil) end
end

function s.e2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
  if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp ,LOCATION_MZONE,0,2,nil) end
  
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g = Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCos,tp,LOCATION_MZONE,0,2,2,nil)
  Duel.SendtoGrave(g,nil,REASON_EFFECT+REASON_COST)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
  if not (Duel.GetLocationCount(tp,LOCATION_SZONE) > 0 and Duel.IsExistingMatchingCard(s.e2setfilter,tp ,LOCATION_GRAVE,0,1,nil)) then return end
 
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SSET)
  local tc = Duel.SelectMatchingCard(tp,e2setfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
  Duel.SSet(tp,tc)
  
end


--e3

function s.e3filter(e,re)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_EFFECT) and tc:IsAttackBlow(c:GetAttack()) and not re:IsControler(tp)
end

function s.e4filter(e,ct)
	local c=e:GetHandler()
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler() and te:IsActiveType(TYPE_EFFECT) and te:GetHandler():IsAttackBelow(c:GetAttack()) and not te:GetHandler():IsControler(c:GetOwner())
end