-- 流浪的家庭教师·斯芙拉玛尔
local s,id=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x624)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(800)
	c:RegisterEffect(e1)
	local e1b=e1:Clone()
	e1b:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e1b)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end
function s.atkcon(e)
	return e:GetHandler():GetCounter(0x624)>0
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(tp) and e:GetHandler():GetCounter(0x624)>0
end
function s.spellfil(c)
	return c.isSpellboost
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetCounter(0x624)
	local g=Duel.GetMatchingGroup(s.spellfil,tp,LOCATION_HAND,0,nil)
	if #g>0 then
		for tc in aux.Next(g) do
			for i=1,ct do
				if not tc:IsPublic() then
					local e11=Effect.CreateEffect(e:GetHandler())
					e11:SetType(EFFECT_TYPE_SINGLE)
					e11:SetCode(EFFECT_PUBLIC)
					e11:SetReset(RESET_EVENT+RESETS_STANDARD)
					e:GetHandler():RegisterEffect(e11)
				end
				tc:RegisterFlagEffect(60001538,RESET_EVENT+RESET_LEAVE+RESET_TODECK+RESET_TOGRAVE+RESET_REMOVE,0,1)
			end
		end
	end
end