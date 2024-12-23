--军团的暗杀者·意识降临
function c51847106.initial_effect(c)
	--fusion material
	aux.AddFusionProcFunFun(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xa67),c51847106.matfilter,2,true)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetValue(c51847106.mlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,51847106)
	e5:SetCondition(c51847106.spcon)
	e5:SetCost(c51847106.spcost)
	e5:SetOperation(c51847106.spop)
	c:RegisterEffect(e5)
	--change effect type
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(51847106)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BATTLE_START)
	--e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	--e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(c51847106.atkcon)
	e7:SetOperation(c51847106.atkop)
	c:RegisterEffect(e7)
	--actlimit
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_CANNOT_ACTIVATE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(0,1)
	e8:SetValue(1)
	e8:SetCondition(c51847106.actcon)
	c:RegisterEffect(e8)
end
function c51847106.matfilter(c)
	return c:IsFusionSetCard(0xa67) and c:IsFusionType(TYPE_XYZ)
end
function c51847106.mlimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
function c51847106.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c51847106.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_COST)
end
function c51847106.spop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c51847106.condition)
	e1:SetOperation(c51847106.operation)
	if Duel.GetCurrentPhase()<=PHASE_STANDBY then
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	Duel.RegisterEffect(e1,tp)
end
function c51847106.spfilter(c,e,tp)
	return c:IsCode(51847106) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c51847106.cpfilter(c)
	return (((c:GetType()==TYPE_SPELL or c:IsType(TYPE_QUICKPLAY)) and c:CheckActivateEffect(true,true,false)~=nil) or (c:GetType()==TYPE_TRAP or c:CheckActivateEffect(false,true,false)~=nil)) and c:IsAbleToRemove()
end
function c51847106.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c51847106.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c51847106.cpfilter,tp,0,LOCATION_GRAVE,1,nil)
end
function c51847106.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,51847106)
	local tc=Duel.SelectMatchingCard(tp,c51847106.cpfilter,tp,0,LOCATION_GRAVE,1,1,nil):GetFirst()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
	if tc:GetType()==TYPE_SPELL or tc:IsType(TYPE_QUICKPLAY) then
		local te=tc:CheckActivateEffect(true,true,false)
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	else
		local te=tc:CheckActivateEffect(false,true,false)
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
	--spsummon
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c51847106.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #sg>0 then
		Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():CompleteProcedure()
	end
end
function c51847106.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and e:GetHandler():IsRelateToBattle()
end
function c51847106.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(3400)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_ONFIELD)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e3)
end
function c51847106.actcon(e)
	return Duel.GetAttacker()==e:GetLabelObject()
end
