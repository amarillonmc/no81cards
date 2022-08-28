--恋慕屋敷 撕裂爱奴
function c9911057.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetOperation(aux.chainreg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetRange(LOCATION_PZONE)
	e2:SetOperation(c9911057.acop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,9911057)
	e3:SetCost(c9911057.spcost)
	e3:SetTarget(c9911057.sptg)
	e3:SetOperation(c9911057.spop)
	c:RegisterEffect(e3)
	--atkup
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9911057,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_DAMAGE_STEP)
	e4:SetRange(LOCATION_HAND)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCountLimit(1,9911058)
	e4:SetCondition(c9911057.atkcon)
	e4:SetCost(c9911057.atkcost)
	e4:SetOperation(c9911057.atkop)
	c:RegisterEffect(e4)
	--register to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c9911057.regop)
	c:RegisterEffect(e5)
	--pendulem
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(9911057,2))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_COUNTER)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetCountLimit(1,9911059)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c9911057.thcon)
	e6:SetTarget(c9911057.thtg)
	e6:SetOperation(c9911057.thop)
	c:RegisterEffect(e6)
	if not c9911057.global_check then
		c9911057.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c9911057.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911057.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) then return end
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if loc==LOCATION_MZONE and rc:GetFlagEffect(9911058)==0 then
		rc:RegisterFlagEffect(9911058,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c9911057.acop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsRelateToEffect(re) or not re:IsActiveType(TYPE_MONSTER) or tc:IsFacedown()
		or not tc:IsType(TYPE_EFFECT) then return end
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	if p~=tp and loc==LOCATION_MZONE and e:GetHandler():GetFlagEffect(1)>0 then
		tc:AddCounter(0x1954,2)
	end
end
function c9911057.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x1954,3,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x1954,3,REASON_COST)
end
function c9911057.spfilter(c,e,tp)
	return c:IsSetCard(0x9954) and c:IsLevel(6) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911057.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9911057.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c9911057.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9911057.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.SelectYesNo(tp,aux.Stringid(9911057,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT)
		end
	end
end
function c9911057.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if phase~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:IsControler(tp) and a:IsSetCard(0x9954) and a:IsRelateToBattle())
		or (d:IsControler(tp) and d:IsSetCard(0x9954) and d:IsRelateToBattle()))
end
function c9911057.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9911057.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or not d:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	if a:IsControler(tp) then
		e1:SetValue(d:GetAttack())
		a:RegisterEffect(e1)
	else
		e1:SetValue(a:GetAttack())
		d:RegisterEffect(e1)
	end
end
function c9911057.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(9911057,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function c9911057.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(9911057)>0
end
function c9911057.addfilter(c)
	return c:IsType(TYPE_EFFECT) and c:IsCanAddCounter(0x1954,1) and c:GetFlagEffect(9911058)>0
end
function c9911057.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c9911057.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c9911057.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND)
		and Duel.IsExistingMatchingCard(c9911057.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c9911057.addfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		for tc in aux.Next(g) do
			tc:AddCounter(0x1954,1)
		end
	end
end
