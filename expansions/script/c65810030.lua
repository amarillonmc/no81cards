--盛夏回忆·天牛
function c65810030.initial_effect(c)
	--无效效果（手坑）
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65810030)
	e1:SetCondition(c65810030.discon)
	e1:SetCost(c65810030.discost)
	e1:SetTarget(c65810030.distg)
	e1:SetOperation(c65810030.disop)
	c:RegisterEffect(e1)
	--攻宣无效
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c65810030.condition3)
	e3:SetCost(c65810030.cost3)
	e3:SetOperation(c65810030.activate3)
	c:RegisterEffect(e3)
end


function c65810030.discon(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainDisablable(ev) then return false end
	local te,p=Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return te and te:GetHandler():IsRace(RACE_INSECT) and p==tp and rp==1-tp
end
function c65810030.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c65810030.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c65810030.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.NegateEffect(ev)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65810030.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c65810030.splimit(e,c)
	return not c:IsRace(RACE_INSECT)
end

function c65810030.condition3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function c65810030.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c65810030.activate3(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
