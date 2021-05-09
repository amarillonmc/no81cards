--骁将疾驱 张文远
function c33200025.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),2)
	c:EnableReviveLimit()
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200025,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c33200025.batg)
	e1:SetOperation(c33200025.baop)
	c:RegisterEffect(e1)	
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--SendtoGrave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetCondition(c33200025.rmcon)
	e3:SetTarget(c33200025.rmtg)
	e3:SetOperation(c33200025.rmop)
	c:RegisterEffect(e3)
	--cover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33200025,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMING_MAIN_END)
	e4:SetCountLimit(1,33200025)
	e4:SetCondition(c33200025.setcon)
	e4:SetTarget(c33200025.settg)
	e4:SetOperation(c33200025.setop)
	c:RegisterEffect(e4)
	--spsm
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_SZONE)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e5:SetCountLimit(1,33200025)
	e5:SetTarget(c33200025.sptg)
	e5:SetOperation(c33200025.spop)
	c:RegisterEffect(e5)
end

--e1
function c33200025.batg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return c:IsAttackable()
		and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end
function c33200025.baop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackable() and c:IsControler(tp) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		local tc=g:GetFirst()
		if tc:IsControler(1-tp) and tc:IsRelateToEffect(e) then
			Duel.CalculateDamage(c,tc)
		end
	end
end

--e3
function c33200025.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	e:SetLabelObject(bc)
	return c==Duel.GetAttacker() and bc and c:IsStatus(STATUS_OPPO_BATTLE) and bc:IsOnField() 
	and bc:IsRelateToBattle()
end
function c33200025.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetLabelObject():IsAbleToGrave() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetLabelObject(),1,0,0)
end
function c33200025.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.SendtoGrave(bc,REASON_EFFECT)
	end
end

--e4
function c33200025.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c33200025.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanTurnSet() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c33200025.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	Duel.ConfirmCards(1-tp,c)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e2:SetValue(TYPE_TRAP)
	c:RegisterEffect(e2)
end
function c33200025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
end