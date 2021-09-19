function c45746836.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c45746836.lcheck)
	c:EnableReviveLimit()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c45746836.atkval)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c45746836.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,45746836)
	e3:SetTarget(c45746836.postg)
	e3:SetOperation(c45746836.posop)
	c:RegisterEffect(e3)

 --   local e4=Effect.CreateEffect(c)
  --  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
   -- e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  --  e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
  --  e4:SetCode(EVENT_LEAVE_FIELD)
--  e4:SetCountLimit(1,45746884)
  --  e4:SetCondition(c45746836.spcon)
  --  e4:SetTarget(c45746836.sptg)
  --  e4:SetOperation(c45746836.spop)
   -- c:RegisterEffect(e4)
end

function c45746836.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x88e)
end
--e1
function c45746836.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x88e) and c:GetLevel()>=0
end
function c45746836.atkval(e,c)
	local lg=c:GetLinkedGroup():Filter(c45746836.atkfilter,nil)
	return lg:GetSum(Card.GetLevel)*200
end
--e2
function c45746836.disable(e,c)
	return (bit.band(c:GetOriginalType(),TYPE_MONSTER)==TYPE_EFFECT or c:IsType(TYPE_EFFECT)) and c:IsPosition(POS_FACEUP_DEFENSE)
end
--e3
function c45746836.filter(c)
	return c:IsCanChangePosition()
end
function c45746836.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c45746836.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c45746836.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c45746836.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c45746836.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
--e4
--function c45746836.spcon(e,tp,eg,ep,ev,re,r,rp)
  --  local c=e:GetHandler()
  --  return c:IsPreviousPosition(POS_FACEUP)
	--  and c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp
--end
--function c45746836.spfilter(c,e,tp)
  --  return c:IsSetCard(0x88e) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
--end
--function c45746836.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
--  if chk==0 then return Duel.IsExistingMatchingCard(c45746836.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
 --   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
--end
--function c45746836.spop(e,tp,eg,ep,ev,re,r,rp)
  --  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
   -- local g=Duel.SelectMatchingCard(tp,c45746836.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
  --  if g:GetCount()>0 then
  --	  Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
  --  end
--end