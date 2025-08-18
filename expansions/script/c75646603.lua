--逆熵科技 青花鱼号
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)  
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.deftg)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	--def all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)   
	e3:SetCondition(s.defcon)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	Duel.BreakEffect()
	local b2=Duel.GetFlagEffect(tp,75646600)~=0 and Duel.IsPlayerCanDraw(tp,2)
	local op=aux.SelectFromOptions(tp,
		{true,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)},
		{true,aux.Stringid(id,4)})
	if op==1 then
		local rg=Duel.GetMatchingGroup(Card.IsOriginalCodeRule,tp,0x7f,0,nil,75646600)
		if rg:GetCount()>0 then
			local rc=rg:GetFirst()
			while rc do
				if rc:GetFlagEffect(5646600)<15 then
					rc:RegisterFlagEffect(5646600,0,0,0)
				end
				rc:ResetFlagEffect(646600)
				rc:RegisterFlagEffect(646600,0,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(75646600,rc:GetFlagEffect(5646600)))	
				rc=rg:GetNext()
			end
		end
	elseif op==2 then
		Duel.Recover(tp,2000,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function s.damval(e,re,val,r,rp,rc)
	return math.floor(val/2)
end
function s.deftg(e,c)
	return aux.IsCodeListed(c,75646600)
end
function s.defcon(e)
	local f=Duel.GetFlagEffect(e:GetHandlerPlayer(),75646600)
	return f and f~=0
end