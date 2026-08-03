-- 如闪耀之夜
Duel.LoadScript("c71290308.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,71290308)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.negreg)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(s.negreg)
	e2:SetCondition(s.thcon)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.handcond)
	c:RegisterEffect(e4)
end
function s.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id+10000000,RESET_PHASE+PHASE_END,0,1)
end
function s.handcond(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,71290309)>0
end
function s.handtg(e,c)
	return aux.IsCodeListed(c,71290308)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		if Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) then
			return true
		end
		return Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)==0
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=g:GetFirst()
		if tc and tc:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			Duel.GetControl(tc,tp)
		end
	else
		local g=Duel.GetDecktopGroup(1-tp,2)
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end

	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.negnextop)
	Duel.RegisterEffect(e1,tp)

	e:GetHandler():ResetFlagEffect(id+10000000)
	Lilith.allback(e,eg,ep,ev,re,r,rp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id+10000000)~=0
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	s.op1(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():ResetFlagEffect(id+10000000)
	Duel.RegisterFlagEffect(tp,71290308,0,0,1)
	Duel.RegisterFlagEffect(tp,id,0,0,1)
end
function s.negnextop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	local rc=re:GetHandler()
	if not (rc:IsType(TYPE_SPELL) or rc:IsType(TYPE_TRAP)) then return end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.Hint(HINT_CARD,0,id)
		Duel.NegateEffect(ev)
		e:Reset()
	end
end