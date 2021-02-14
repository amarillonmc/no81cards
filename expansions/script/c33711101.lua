--赤子之心
function c33711101.initial_effect(c)
	c:SetUniqueOnField(1,0,33711101)   
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(function(e,tp) return Duel.GetTurnPlayer()==tp end)
	e2:SetTarget(c33711101.retg)
	e2:SetOperation(c33711101.reop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c33711101.damcon1)
	e3:SetOperation(c33711101.damop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(c33711101.damcon2)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
	e5:SetCondition(c33711101.clcon)
	e5:SetTargetRange(1,0)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_ADJUST)
	e6:SetCondition(c33711101.chcon)
	e6:SetOperation(c33711101.chop)
	c:RegisterEffect(e6)
	if not c33711101.global_check then
		c33711101.global_check=true
		LPdam={}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c33711101.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33711101.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetControler(),133711101)>1 then return end
		Duel.RegisterFlagEffect(tc:GetControler(),133711101,RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c33711101.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local code=33711100+Duel.GetTurnCount()
	if chk==0 then return Duel.GetFlagEffect(tp,code)==0 and Duel.GetTurnCount()>1 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,nil,tp,0)
end
function c33711101.reop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local num=0
	if LPdam[Duel.GetTurnCount()-1] then
		num=LPdam[Duel.GetTurnCount()-1]
	end
	if Duel.GetFlagEffect(1-tp,133711101)>0 then
		Duel.Recover(tp,(4000+num)*2,REASON_EFFECT)
	else
		Duel.Recover(tp,4000+num,REASON_EFFECT)
	end
end
function c33711101.damcon1(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function c33711101.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_BATTLE)==0
end
function c33711101.damop(e,tp,eg,ep,ev,re,r,rp)
	if (ep~=tp and eg:GetFirst():IsControler(tp)) or (ep~=tp and bit.band(r,REASON_BATTLE)==0 and re:GetHandler():IsControler(tp)) then
		Duel.RegisterFlagEffect(tp,33711101+Duel.GetTurnCount(),RESET_PHASE+PHASE_END,0,3)
	end
	if (ep==tp and eg:GetFirst():IsControler(1-tp)) or (ep==tp and bit.band(r,REASON_BATTLE)==0 and re:GetHandler():IsControler(1-tp)) then
		if LPdam[Duel.GetTurnCount()] then
			LPdam[Duel.GetTurnCount()]=LPdam[Duel.GetTurnCount()]+ev
		else
			LPdam[Duel.GetTurnCount()]=ev
		end
	end
end
function c33711101.clcon(e,tp)
	return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():GetFlagEffect(33711101)==0 and Duel.GetTurnPlayer()~=e:GetHandler():GetControler()
end
function c33711101.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)==0
end
function c33711101.chop(e,tp)
	if Duel.GetTurnPlayer()~=e:GetHandler():GetControler() and Duel.SelectYesNo(tp,aux.Stringid(33711101,2)) then
		Duel.SendtoGrave(e:GetHandler(),REASON_COST)
		local ex1=Effect.CreateEffect(e:GetHandler())
		ex1:SetType(EFFECT_TYPE_FIELD)
		ex1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ex1:SetRange(LOCATION_GRAVE)
		ex1:SetCode(EFFECT_CANNOT_LOSE_KOISHI)
		ex1:SetTargetRange(1,0)
		ex1:SetValue(1)
		e:GetHandler():RegisterEffect(ex1,true)
		Duel.SetLP(tp,4000)
		ex1:Reset()
	else
		e:GetHandler():RegisterFlagEffect(33711101,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end