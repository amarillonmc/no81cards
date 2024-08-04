--漆黑摄理
function c49811237.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c49811237.spcost)
	e1:SetTarget(c49811237.sptg)
	e1:SetOperation(c49811237.spop)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e11:SetRange(LOCATION_SZONE)
	e11:SetTargetRange(LOCATION_MZONE,0)
	e11:SetTarget(c49811237.eftg1)
	e11:SetLabelObject(e1)
	c:RegisterEffect(e11)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c49811237.atkval)
	local e22=Effect.CreateEffect(c)
	e22:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e22:SetRange(LOCATION_SZONE)
	e22:SetTargetRange(LOCATION_MZONE,0)
	e22:SetTarget(c49811237.eftg2)
	e22:SetLabelObject(e2)
	c:RegisterEffect(e22)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	local e33=Effect.CreateEffect(c)
	e33:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e33:SetRange(LOCATION_SZONE)
	e33:SetTargetRange(LOCATION_MZONE,0)
	e33:SetTarget(c49811237.eftg3)
	e33:SetLabelObject(e3)
	c:RegisterEffect(e33)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0xff,0xff)
	e4:SetTarget(c49811237.rmtg)
	e4:SetValue(LOCATION_REMOVED)
	local e44=Effect.CreateEffect(c)
	e44:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e44:SetRange(LOCATION_SZONE)
	e44:SetTargetRange(LOCATION_MZONE,0)
	e44:SetTarget(c49811237.eftg4)
	e44:SetLabelObject(e4)
	c:RegisterEffect(e44)
	local e40=Effect.CreateEffect(c)
	e40:SetType(EFFECT_TYPE_FIELD)
	e40:SetCode(81674782)
	e40:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e40:SetRange(LOCATION_MZONE)
	e40:SetTargetRange(0xff,0xff)
	e40:SetTarget(aux.TRUE)
	local e41=Effect.CreateEffect(c)
	e41:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e41:SetRange(LOCATION_SZONE)
	e41:SetTargetRange(LOCATION_MZONE,0)
	e41:SetTarget(c49811237.eftg4)
	e41:SetLabelObject(e40)
	c:RegisterEffect(e41)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c49811237.actcon)
	e5:SetValue(c49811237.aclimit)
	c:RegisterEffect(e1)
	local e55=Effect.CreateEffect(c)
	e55:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e55:SetRange(LOCATION_SZONE)
	e55:SetTargetRange(LOCATION_MZONE,0)
	e55:SetTarget(c49811237.eftg5)
	e55:SetLabelObject(e5)
	c:RegisterEffect(e55)
end
function c49811237.eftg1(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(2)
end
function c49811237.eftg2(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(4)
end
function c49811237.eftg3(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(6)
end
function c49811237.eftg4(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(8)
end
function c49811237.eftg5(e,c)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevelAbove(10)
end
function c49811237.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c49811237.spfilter(c,e,tp,lv,def)
	return c:IsRace(RACE_FIEND) and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsLevel(lv+2) and c:IsDefense(def+300)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c49811237.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local def=c:GetDefense()
	if chk==0 then return c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c49811237.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,lv,def) end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c49811237.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	local def=c:GetDefense()
	if c:IsRelateToEffect(e) and Duel.Release(c,REASON_EFFECT)~=0
		and c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c49811237.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv,def)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c49811237.atkval(e,c)
	return c:GetLevel()*200
end
function c49811237.rmtg(e,c)
	return c:GetOriginalType()&TYPE_SPELL~=0 or c:GetOriginalType()&TYPE_TRAP~=0
end
function c49811237.actcon(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c49811237.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end