--H.P.T.-000
local m=12899004
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.atktg)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.ckfilter(c)
	return  c:IsSetCard(0x5a71) and c:IsFaceup()
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1= Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,1))
	else op=Duel.SelectOption(tp,aux.Stringid(m,2))+1 end
	e:SetLabel(op)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,cm.ckfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(tc:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			local e0=Effect.CreateEffect(c)
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetCode(EFFECT_SET_ATTACK_FINAL)
			e0:SetValue(0)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e0)
			local e1=e0:Clone()
			e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e1)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
			e6:SetValue(1)
			e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e6)
			local e7=e6:Clone()
			e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
			tc:RegisterEffect(e7)
		end
	end   
end

function cm.filter(c)
	return ((not c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.filter2(c)
	return ((c:IsSetCard(0x5a71)) and c:IsFaceup())
end
function cm.handcon(e)
	return not Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end