--不灭之诚
function c22020740.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,22020720),1,1)
	c:EnableReviveLimit()
	--summon success
	--summon success
	local e100=Effect.CreateEffect(c)
	e100:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e100:SetCode(EVENT_SPSUMMON_SUCCESS)
	e100:SetOperation(c22020740.sumsuc)
	e100:SetCountLimit(1,22020740+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e100)
	--attack cost
	local e103=Effect.CreateEffect(c)
	e103:SetType(EFFECT_TYPE_SINGLE)
	e103:SetCode(EFFECT_ATTACK_COST)
	e103:SetCountLimit(1)
	e103:SetOperation(c22020740.atop)
	c:RegisterEffect(e103)
	--atk update
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c22020740.atkval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22020740.condition)
	e2:SetValue(c22020740.efilter)
	c:RegisterEffect(e2)
	--disable and atk down
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(c22020740.adcon)
	e3:SetTarget(c22020740.adtg)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_SET_ATTACK_FINAL)
	e5:SetValue(0)
	c:RegisterEffect(e5)
	--Summon
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c22020740.discon)
	e7:SetOperation(c22020740.rpop)
	c:RegisterEffect(e7)
end
function c22020740.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c22020740.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("我即是——新选组！")
	Duel.RegisterEffect(e1,tp)
end
function c22020740.atop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	Debug.Message("诚字大旗不灭......挥刀，前进。挥刀......！前进......！我便是！新选组！")
	Duel.RegisterEffect(e1,tp)
end
function c22020740.atkval(e,c)
	local lps=Duel.GetLP(c:GetControler())
	local lpo=Duel.GetLP(1-c:GetControler())
	if lps>=lpo then return 0
	else return lpo-lps end
end
function c22020740.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c22020740.adcon(e)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:GetBattleTarget()
		and (Duel.GetCurrentPhase()==PHASE_DAMAGE or Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL)
end
function c22020740.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function c22020740.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c22020740.rpfilter(c,e,tp)
	return c:IsCode(22020720) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22020740.rpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoGrave(c,REASON_EFFECT) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
			local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c22020740.rpfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
			if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(22020740,0)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
	end
end