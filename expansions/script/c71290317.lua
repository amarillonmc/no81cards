-- 献予你彷徨而虚缈的祈祷（For Kyrielight）
Duel.LoadScript("c71290308.lua")
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,71290308)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
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

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(s.handcond)
	c:RegisterEffect(e3)
end
function s.negreg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(id+10000000,RESET_PHASE+PHASE_END,0,1)
end
function s.handcond(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,71290309)>0
end
function s.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_FAIRY) and c:GetDefense()>c:GetAttack()
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>1
	end
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local num=math.floor(Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)/2)
	Duel.ConfirmDecktop(1-tp,num)
	local g=Duel.GetDecktopGroup(1-tp,num):Filter(Card.IsRace,nil,RACE_FAIRY)
	if #g~=0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		local sg=Duel.GetOperatedGroup()
		for tc in aux.Next(sg) do
			if tc and tc:IsType(TYPE_MONSTER) and tc:GetDefense()>tc:GetAttack() then
				local c=e:GetHandler()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e1:SetTarget(s.distg)
				e1:SetLabelObject(tc)
				e1:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e1,tp)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_CHAIN_SOLVING)
				e2:SetCondition(s.discon)
				e2:SetOperation(s.disop)
				e2:SetLabelObject(tc)
				e2:SetReset(RESET_PHASE+PHASE_END,2)
				Duel.RegisterEffect(e2,tp)
			end
		end
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
function s.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule()) and (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end