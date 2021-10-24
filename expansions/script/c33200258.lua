--机略纵横 周公瑾
function c33200258.initial_effect(c)
	c:SetUniqueOnField(1,1,33200258)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(3,33200250+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200258.setcon)
	e1:SetTarget(c33200258.settg)
	e1:SetOperation(c33200258.setop)
	c:RegisterEffect(e1)  
	--indestructable  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,33200250))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsCode,33200250))
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(c33200258.drtg)
	e4:SetOperation(c33200258.drop)
	c:RegisterEffect(e4)
end

--e1
function c33200258.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200258.setfilter,tp,LOCATION_DECK,0,1,nil,tp) 
		and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=1 end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c33200258.descon)
	e1:SetOperation(c33200258.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(33200258,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,3)
	c33200258[e:GetHandler()]=e1
end
function c33200258.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c33200258.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==3 then
		Duel.Destroy(c,REASON_RULE)
		c:ResetFlagEffect(33200258)
	end
end
function c33200258.setcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()~=tp
end
function c33200258.setfilter(c,tp)
   return c:IsSetCard(0x326) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and not Duel.IsExistingMatchingCard(c33200258.codefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,c:GetCode())
end 
function c33200258.codefilter(c,code)
   return c:IsCode(code) and c:IsFaceup()
end
function c33200258.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33200258,0))
	local g=Duel.SelectMatchingCard(tp,c33200258.setfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local c=e:GetHandler()
		if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_PHASE+PHASE_END)
			e2:SetRange(LOCATION_SZONE)
			e2:SetCountLimit(1)   
			e2:SetOperation(c33200258.thop)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CONTROL+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(33200258,2))
		end
	end
end
function c33200258.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,33200258)
	local c=e:GetHandler()
	if Duel.SendtoHand(c,1-tp,REASON_EFFECT)>=1 then
		Duel.ConfirmCards(tp,c)
		if Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(33200258,1)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(1-tp,aux.TRUE,tp,LOCATION_ONFIELD,0,1,1,nil)
			local tc=g:GetFirst()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end

--e4
function c33200258.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c33200258.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end