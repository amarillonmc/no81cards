--山茶·花信
function c16372011.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16372011)
	e1:SetCost(c16372011.costoath)
	e1:SetTarget(c16372011.sptg)
	e1:SetOperation(c16372011.spop)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e11)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372011+100)
	e2:SetCondition(c16372011.setscon)
	e2:SetCost(c16372011.costoath)
	e2:SetTarget(c16372011.setstg)
	e2:SetOperation(c16372011.setsop)
	c:RegisterEffect(e2)
	--can not be effect target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetCondition(c16372011.spellcon)
	e3:SetTarget(c16372011.etlimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(16372011,ACTIVITY_SPSUMMON,c16372011.counterfilter)
end
function c16372011.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372011.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372011,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372011.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372011.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372011.filter(c,e,tp)
	return c:IsSetCard(0xdc1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c16372011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16372011.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c16372011.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16372011.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		if c:IsRelateToEffect(e) and (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(16372011,0)) then
			local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
			Duel.BreakEffect()
			Duel.MoveToField(c,tp,p,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			c:RegisterEffect(e1)
		end
	end
end
function c16372011.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372011.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372011.setsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil and Duel.MoveToField(c,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
	end
end
function c16372011.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372011.etlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0xdc1)
end