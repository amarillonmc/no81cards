--人 偶 房
local m=22348158
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,22348157)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348158,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c22348158.tstg)
	e1:SetOperation(c22348158.tsop)
	c:RegisterEffect(e1)
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e2:SetValue(c22348158.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c22348158.atkfilter(c)
	return c:IsFaceup() and c:IsCode(22348157)
end
function c22348158.val(e,c)
	return Duel.GetMatchingGroupCount(c22348158.atkfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)*200
end
function c22348158.tsfilter(c)
	return c:IsCode(22348157) and not c:IsForbidden()
end
function c22348158.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCode(22348157) and c:GetOriginalType()&TYPE_MONSTER>0 and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c22348158.tstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c22348158.tsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,22348158)==0
	local b2=Duel.IsExistingMatchingCard(c22348158.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,22349158)==0
	if chk==0 then return b1 or b2 end
end
function c22348158.tsop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c22348158.tsfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetFlagEffect(tp,22348158)==0
	local b2=Duel.IsExistingMatchingCard(c22348158.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,22349158)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(22348158,0),aux.Stringid(22348158,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(22348158,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(22348158,1))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22348158.tsfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		Duel.RegisterFlagEffect(tp,22348158,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348158.spfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,22349158,RESET_PHASE+PHASE_END,0,1)
	end
end