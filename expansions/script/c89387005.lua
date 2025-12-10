--星辉士 托勒密
local m=89387005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x9c),2,2)
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.condition)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0xff,0)
	e4:SetCode(m)
	e4:SetTarget(cm.rmtg)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(cm.checkop)
		Duel.RegisterEffect(e2,0)
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp,g)
	return c:IsSetCard(0x9c) and not (g and g:IsExists(Card.IsCode,1,nil,c:GetCode())) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,sg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local sg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,sg)
		if g and g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetTargetRange(1,0)
	e3:SetTarget(cm.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9c)
end
function cm.rmtg(e,c)
	return c:IsCode(1050186,2273734,13851202,26057276,38667773,63274863,65056481,75878039,86466163,99668578,42822433,79210531,60700283)
end
function cm.regfilter(c,tc)
	return c:GetOriginalCode()==tc:GetOriginalCode()
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not cm.rmtg(re,rc) then return end
	if re:IsHasType(EFFECT_TYPE_SINGLE) and (re:GetCode()==EVENT_SUMMON_SUCCESS or re:GetCode()==EVENT_FLIP_SUMMON_SUCCESS or re:GetCode()==EVENT_SPSUMMON_SUCCESS) then
		Duel.RegisterFlagEffect(rp,rc:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
		local g=Duel.GetMatchingGroup(cm.regfilter,rp,0xff,0,nil,rc)
		for tc in aux.Next(g) do
			if tc:GetFlagEffect(m)>0 then return end
			local e1=re:Clone()
			e1:SetCode(EVENT_SUMMON_SUCCESS)
			e1:SetCondition(cm.regcondition)
			e1:SetCost(cm.regcost)
			e1:SetCountLimit(1,tc:GetOriginalCode()+100000000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(m,0,0,1)
		end
	end
end
function cm.regcondition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(m) and Duel.GetFlagEffect(tp,c:GetOriginalCode())>0
end
function cm.regcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,m)
	Duel.SetLP(tp,Duel.GetLP(tp)-500)
end
