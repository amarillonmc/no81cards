--狂风精灵 微风
function c51928001.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,51928001+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51928001.spcon)
	e1:SetOperation(c51928001.spop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(51928001,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,51928001)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c51928001.settg)
	e2:SetOperation(c51928001.setop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51928001,ACTIVITY_SPSUMMON,c51928001.counterfilter)
end
function c51928001.counterfilter(c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end
---------------------------------
function c51928001.filter(c)
	return c:IsType(TYPE_TUNER) and c:IsFaceup()
end
function c51928001.spcon(e,c)
	if c==nil then return true end
	return Duel.GetCustomActivityCount(51928001,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c51928001.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c51928001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51928001.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51928001.splimit(e,c)
	return not (c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_THUNDER)) and c:IsLocation(LOCATION_EXTRA)
end



---------------------------------------
function c51928001.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c51928001.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
	return Duel.IsExistingMatchingCard(c51928001.cfilter,tp,LOCATION_MZONE,0,1,nil)
	end
end
function c51928001.posfilter(c)
	return c:IsAbleToGrave()
end
function c51928001.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c51928001.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.SelectMatchingCard(tp,c51928001.posfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		Duel.HintSelection(g)
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end



