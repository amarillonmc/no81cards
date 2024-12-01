function c10111147.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c10111147.matfilter1,nil,nil,aux.NonTuner(nil),2,99)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10111147,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c10111147.drcost)
	e1:SetTarget(c10111147.drtg)
	e1:SetOperation(c10111147.drop)
	c:RegisterEffect(e1)
    	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c10111147.atkcon)
	e2:SetOperation(c10111147.atkop)
	c:RegisterEffect(e2)
    	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c10111147.tnval)
	c:RegisterEffect(e3)
end
function c10111147.matfilter1(c,syncard)
	return c:IsTuner(syncard) or c:IsSetCard(0xe6)
end
function c10111147.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
end
function c10111147.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10111147.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		Duel.BreakEffect()
		if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0xe6) then
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.SelectYesNo(tp,aux.Stringid(10111147,1))
				and Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP) then
				local e1=Effect.CreateEffect(e:GetHandler())
  	        	e1:SetType(EFFECT_TYPE_SINGLE)
	         	e1:SetCode(EFFECT_UPDATE_ATTACK)
	        	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	         	e1:SetValue(2000)
				tc:RegisterEffect(e1,true)
			end
			Duel.SpecialSummonComplete()
		end
		Duel.ShuffleHand(tp)
	end
end
function c10111147.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c10111147.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c10111147.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end
function c10111147.atkval(e,c)
	return c:GetBaseAttack()*2
end
function c10111147.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsAttribute(ATTRIBUTE_DARK)
end