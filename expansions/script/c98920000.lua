--奴隶象
function c98920000.initial_effect(c)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c98920000.sptg1)
	e1:SetOperation(c98920000.spop1)
	c:RegisterEffect(e1)	
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)  
	  --damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c98920000.damop)
	c:RegisterEffect(e3)
	--effect gain
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920000,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCondition(c98920000.spcon)
	e4:SetOperation(c98920000.spop)
	e4:SetValue(SUMMON_TYPE_SPECIAL)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetTargetRange(LOCATION_EXTRA,0)
	e5:SetTarget(c98920000.eftg)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
---
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(98920000,1))
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c98920000.syncon)
	e6:SetOperation(c98920000.synop)
	e6:SetValue(SUMMON_TYPE_SPECIAL)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e7:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e7:SetTargetRange(LOCATION_EXTRA,0)
	e7:SetTarget(c98920000.eftg1)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7)
end
function c98920000.spfilter(c,e,tp)
	return c:IsSetCard(0x19) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c98920000.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920000.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c98920000.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98920000.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)local tc=g:GetFirst()
	if tc then
			Duel.SpecialSummon(tc,SUMMON_VALUE_GLADIATOR,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_DISABLE,0,0)
	end
end
function c98920000.cfilter(c)
	return c:IsPreviousLocation(LOCATION_EXTRA) and c:IsSetCard(0x19)
end
function c98920000.damop(e,tp,eg,ep,ev,re,r,rp)
	if eg:FilterCount(c98920000.cfilter,nil,tp)>0 then
	  Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c98920000.eftg(e,c)
	return c:IsCode(48156348,90957527)
end
function c98920000.filter0(c,ft)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x19) and (c:IsAbleToExtraAsCost() or c:IsAbleToDeck())
end
function c98920000.filter1(c)
	return c:IsCode(98920000) and c:IsAbleToRemoveAsCost()
end
function c98920000.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c98920000.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c98920000.filter0,tp,LOCATION_MZONE,0,1,nil)
end
function c98920000.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98920000.filter0,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c98920000.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)   
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c98920000.syncon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c98920000.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c98920000.filter0,tp,LOCATION_MZONE,0,2,nil)
end
function c98920000.synop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98920000.filter0,tp,LOCATION_MZONE,0,2,2,nil,ft)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c98920000.filter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c98920000.eftg1(e,c)
	return c:IsCode(33652635,27346636,3779662)
end