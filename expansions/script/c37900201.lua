--「刀仕祢宜」·朱雀院红叶
local s,id=GetID()
function s.initial_effect(c)
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetOperation(s.eqop1)
	c:RegisterEffect(e7)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.hcon1)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.hcon2)
	e5:SetValue(aux.imval1)
	c:RegisterEffect(e5)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.hcon2)
	e1:SetValue(true)
	c:RegisterEffect(e1)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.hcon3)
	e4:SetValue(s.efilter)
	c:RegisterEffect(e4)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,1))
	e0:SetCategory(CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BATTLE_DAMAGE)
	e0:SetCondition(s.recon)
	e0:SetTarget(s.retg)
	e0:SetOperation(s.reop)
	c:RegisterEffect(e0) 
end
function s.setfilter(c)
	return c:IsAbleToRemove()
end
function s.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
	
end
function s.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<5 then return false end
		local g=Duel.GetDecktopGroup(1-tp,5)
		return g:IsExists(s.setfilter,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function s.reop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<5 then return false end
	Duel.ConfirmDecktop(1-tp,5)
	local g=Duel.GetDecktopGroup(1-tp,5) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.RevealSelectDeckSequence(true)
	local th=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.RevealSelectDeckSequence(false)
	Duel.Remove(th,POS_FACEDOWN,REASON_EFFECT)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function s.efilter(e,te)
	return te:GetHandlerPlayer()~=e:GetHandlerPlayer()
end
function s.hcon1(e,tp,eg,ep,ev,re,r,rp)
	local mlp = Duel.GetLP(e:GetHandlerPlayer())
	local ylp = Duel.GetLP(1-e:GetHandlerPlayer())
	return mlp>ylp
end
function s.hcon2(e,tp,eg,ep,ev,re,r,rp)
	local mlp = Duel.GetLP(e:GetHandlerPlayer())
	local ylp = Duel.GetLP(1-e:GetHandlerPlayer())
	return mlp==ylp
end
function s.hcon3(e,tp,eg,ep,ev,re,r,rp)
	local mlp = Duel.GetLP(e:GetHandlerPlayer())
	local ylp = Duel.GetLP(1-e:GetHandlerPlayer())
	return mlp<ylp
end
function s.eqop1(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,37900203)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	token:CancelToGrave()
	local e1=Effect.CreateEffect(token)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_EQUIP+TYPE_SPELL)
	--e1:SetReset(RESET_EVENT+0x1fc0000)
	token:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(token)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	token:RegisterEffect(e2,true)
	token:CancelToGrave()  
	local c = e:GetHandler()
	if Duel.Equip(tp,token,c,false) then 
		local e3=Effect.CreateEffect(token)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		token:RegisterEffect(e3)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_EQUIP)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(s.atkval)
		token:RegisterEffect(e1)
	end
	
end
function s.atkval(e)
	local mlp = Duel.GetLP(e:GetHandlerPlayer())
	local ylp = Duel.GetLP(1-e:GetHandlerPlayer())
	if mlp>ylp then
		return mlp-ylp
	end
	return ylp-mlp
end