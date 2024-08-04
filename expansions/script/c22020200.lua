--人理之基 玛修·基列莱特
function c22020200.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0xff1),1)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c22020200.effcon)
	e1:SetTarget(c22020200.imtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c22020200.effcon1)
	e3:SetTarget(c22020200.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--cannot select battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCondition(c22020200.effcon1)
	e4:SetValue(c22020200.atlimit)
	c:RegisterEffect(e4)
	if not c22020200.global_flag then
		c22020200.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c22020200.regop)
		Duel.RegisterEffect(ge1,0)
		c22020200.global_flag=true
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_SUMMON_SUCCESS)
		ge2:SetOperation(c22020200.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
c22020200.effect_with_light=true
c22020200.effect_with_dark=true
function c22020200.cfilter(c)
	return c:IsFaceup() and c.effect_with_light and c:IsSetCard(0x6ff1) and c:IsType(TYPE_SYNCHRO)
end
function c22020200.cfilter1(c)
	return c:IsFaceup() and c.effect_with_dark and c:IsSetCard(0x6ff1) and c:IsType(TYPE_SYNCHRO)
end
function c22020200.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020200.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) or Duel.GetFlagEffect(tp,22020000)>0
end
function c22020200.effcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22020200.cfilter1,tp,LOCATION_MZONE,0,1,e:GetHandler()) or Duel.GetFlagEffect(tp,22023750)>0
end
function c22020200.imtg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c22020200.tgtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end
function c22020200.atlimit(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function c22020200.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsCode(22020000) then
			Duel.RegisterFlagEffect(tp,22020000,0,0,0)
		elseif tc:IsCode(22023750) then
			Duel.RegisterFlagEffect(tp,22023750,0,0,0)
		end
	end
end