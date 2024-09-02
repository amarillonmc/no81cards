--檀杏·花信
function c16372002.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,16372002)
	e1:SetCost(c16372002.costoath)
	e1:SetTarget(c16372002.settg)
	e1:SetOperation(c16372002.setop)
	c:RegisterEffect(e1)
	--setself
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCountLimit(1,16372002+100)
	e2:SetCondition(c16372002.setscon)
	e2:SetCost(c16372002.costoath)
	e2:SetTarget(c16372002.setstg)
	e2:SetOperation(c16372002.setsop)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_PLANT))
	e3:SetCondition(c16372002.spellcon)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	local e31=e3:Clone()
	e31:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e31)
	local e32=e3:Clone()
	e32:SetTarget(c16372002.atkfilter)
	e32:SetValue(-500)
	c:RegisterEffect(e32)
	local e33=e32:Clone()
	e33:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e33)
	Duel.AddCustomActivityCounter(16372002,ACTIVITY_SPSUMMON,c16372002.counterfilter)
end
function c16372002.counterfilter(c)
	return c:IsRace(RACE_PLANT)
end
function c16372002.costoath(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16372002,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16372002.splimitoath)
	Duel.RegisterEffect(e1,tp)
end
function c16372002.splimitoath(e,c)
	return not c:IsRace(RACE_PLANT)
end
function c16372002.setfilter(c)
	return c:IsSetCard(0xdc1) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c16372002.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
		and Duel.IsExistingMatchingCard(c16372002.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c16372002.spfilter(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0xdc1) and c:GetType()==TYPE_SPELL+TYPE_CONTINUOUS and c:IsLevel(3)
		and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c16372002.setop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	local b2=Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
	local p=aux.SelectFromOptions(tp,{b1,aux.Stringid(16372000+1,5),tp},{b2,aux.Stringid(16372000+1,6),1-tp})
	if p~=nil then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c16372002.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
		if tc then
			if Duel.MoveToField(tc,tp,p,LOCATION_SZONE,POS_FACEUP,true) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
				tc:RegisterEffect(e1)
				local g=Duel.GetMatchingGroup(c16372002.spfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,e,tp)
				if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(16372002,0)) then
					Duel.BreakEffect()
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local sc=g:Select(tp,1,1,nil)
					Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end
function c16372002.setscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c16372002.setstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c16372002.setsop(e,tp,eg,ep,ev,re,r,rp)
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
function c16372002.spellcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_SPELL+TYPE_CONTINUOUS
end
function c16372002.atkfilter(e,c)
	return not c:IsRace(RACE_PLANT)
end