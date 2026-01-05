--溶星鱼 焰鳍鱼龙
local s,id=GetID()

s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end

local OME_ID=40020321

function s.initial_effect(c)
	aux.EnablePendulumAttribute(c)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_FISH))
	e1:SetValue(500)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.pencon)
	e2:SetTarget(s.pentg)
	e2:SetOperation(s.penop)
	c:RegisterEffect(e2)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function s.omefilter(c)
	return c:IsCode(OME_ID) and not c:IsForbidden()
	   
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local pzone_avail = Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		local has_target = Duel.IsExistingMatchingCard(s.omefilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
		local mzone_avail = Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local can_sp = e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		return pzone_avail and has_target and mzone_avail and can_sp
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,s.omefilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
			if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
