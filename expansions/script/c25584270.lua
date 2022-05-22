--威风妖怪·苍龙
function c25584270.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xd0),2,2)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_BATTLE_CONFIRM)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c25584270.spcon)
	e1:SetOperation(c25584270.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c25584270.splimit)
	e0:SetLabelObject(e1)
	c:RegisterEffect(e0)
	--pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25584270,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(c25584270.pencon)
	e2:SetTarget(c25584270.pentg)
	e2:SetOperation(c25584270.penop)
	c:RegisterEffect(e2)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.indoval)
	c:RegisterEffect(e5)
	--pendulum
	local pe1=Effect.CreateEffect(c)
	pe1:SetDescription(aux.Stringid(25584270,2))
	pe1:SetType(EFFECT_TYPE_QUICK_O)
	pe1:SetCode(EVENT_FREE_CHAIN)
	pe1:SetRange(LOCATION_PZONE)
	pe1:SetHintTiming(TIMING_END_PHASE,TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	pe1:SetCountLimit(1)
	pe1:SetTarget(c25584270.pentg2)
	pe1:SetOperation(c25584270.penop2)
	c:RegisterEffect(pe1)
	--cannot be target
	local pe3=Effect.CreateEffect(c)
	pe3:SetType(EFFECT_TYPE_FIELD)
	pe3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	pe3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	pe3:SetRange(LOCATION_PZONE)
	pe3:SetTargetRange(LOCATION_ONFIELD,0)
	pe3:SetTarget(c25584270.target)
	pe3:SetValue(aux.indoval)
	c:RegisterEffect(pe3)
	--indes
	local pe4=pe3:Clone()
	pe4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	pe4:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	pe4:SetValue(aux.tgoval)
	c:RegisterEffect(pe4)
end
function c25584270.splimit(e,se,sp,st)
	return se==e:GetLabelObject() or st&SUMMON_TYPE_LINK==SUMMON_TYPE_LINK 
end
function c25584270.target(e,c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c25584270.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	return a and d and a:IsFaceup() and a:IsRelateToBattle() and a:IsSetCard(0xd0) and a:IsLevelBelow(4) and a:IsAbleToHandAsCost()
		and d:IsRelateToBattle() and (d:IsAbleToHandAsCost() or d:IsAbleToExtraAsCost())
end
function c25584270.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("222")
	local c=e:GetHandler()
	local a,d=Duel.GetBattleMonster(tp)
	local g=Group.CreateGroup()
	if a and d then
		g=Group.FromCards(a,d)
	end
	if Duel.GetFlagEffect(tp,25584270)~=0 or g:GetCount()<2 or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) or Duel.GetLocationCountFromEx(tp,tp,g,c)==0 then return end
	Duel.RegisterFlagEffect(tp,25584270,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
	if not Duel.SelectYesNo(tp,aux.Stringid(25584270,0)) then return end
	if a:IsRelateToBattle() and d:IsRelateToBattle() then
		local g=Group.FromCards(a,d)
		c:SetMaterial(g)
		Duel.SendtoHand(g,nil,REASON_COST)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
function c25584270.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c25584270.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c25584270.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c25584270.check(e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(c25584270.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if #g==0 then return false end
	local pcon=aux.PendCondition()
	return pcon(e,lpz,g)
end
function c25584270.penfilter(c)
	return c:IsSetCard(0xd0) and c:IsType(TYPE_PENDULUM)
end
function c25584270.pentg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==2 and c25584270.check(e,tp)
	end
end
function c25584270.penop2(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(c25584270.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if #g==0 then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	local pop=aux.PendOperation()
	pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
end
