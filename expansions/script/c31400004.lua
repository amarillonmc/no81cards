--超热血教练
function c31400004.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c31400004.filter,1,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c31400004.stg)
	e1:SetCost(c31400004.scost)
	e1:SetOperation(c31400004.scop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c31400004.attg)
	e2:SetCondition(c31400004.atcon)
	e2:SetValue(c31400004.val)
	c:RegisterEffect(e2)
end
function c31400004.filter(c)
  return c:IsRace(RACE_WARRIOR) and c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c31400004.scosfilter(c)
  return c31400004.filter(c) and c:IsAbleToGraveAsCost()
end
function c31400004.sfilter(c)
  return c31400004.filter(c) and c:IsSummonable(true,nil)
end
function c31400004.stg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31400004.sfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c31400004.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31400004.scosfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c31400004.filter,tp,LOCATION_DECK,0,1,1,nil,lv)
	Duel.SendtoGrave(g,REASON_COST)
end
function c31400004.scop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c31400004.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c31400004.atcon(e)
	return e:GetHandler():GetSequence()>4
end
function c31400004.attg(e,c)
	return c31400004.filter(c)
end

function c31400004.val(e,c)
	return Duel.GetMatchingGroupCount(c31400004.filter,c:GetControler(),LOCATION_MZONE,nil,nil)*1000
end
