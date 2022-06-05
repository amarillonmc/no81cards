--远古造物 三叠蟾
require("expansions/script/c9910700")
function c9910736.initial_effect(c)
	--special summon
	Ygzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	Ygzw.AddTgFlag(c)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910736)
	e1:SetCost(c9910736.sumcost)
	e1:SetTarget(c9910736.sumtg)
	e1:SetOperation(c9910736.sumop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910737)
	e2:SetCondition(c9910736.setcon)
	e2:SetTarget(c9910736.settg)
	e2:SetOperation(c9910736.setop)
	c:RegisterEffect(e2)
end
function c9910736.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910736.sumfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsSummonable(true,nil)
end
function c9910736.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c9910736.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910736.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910736.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c9910736.efilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		tc:RegisterEffect(e1)
	end
end
function c9910736.efilter(e,re)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_AQUA)
		and e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
function c9910736.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910736.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Ygzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910736.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Ygzw.Set(c,e,tp) end
end
