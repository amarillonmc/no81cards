--天灾信使·狙击干员-普罗旺斯
function c79029106.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,c79029106.ovfilter,aux.Stringid(79029106,0))
	c:EnableReviveLimit()   
	--attack up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23232295,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c79029106.atkcost)
	e1:SetOperation(c79029106.atkop)
	c:RegisterEffect(e1) 
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_NEGATE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c79029106.discon)
	e5:SetCost(c79029106.discost)
	e5:SetTarget(c79029106.distg)
	e5:SetOperation(c79029106.disop)
	c:RegisterEffect(e5)
	--damage and Overlay 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79029106.dotg)
	e2:SetOperation(c79029106.doop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e3:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end
function c79029106.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsRank(8)
end
function c79029106.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029106.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
		e1:SetValue(c:GetAttack()*2)
		c:RegisterEffect(e1)
	end
	Debug.Message("弩箭装填完毕！随时都可以！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029106,2))
end
function c79029106.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79029106.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c79029106.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c79029106.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.Destroy(eg,REASON_EFFECT)
	Debug.Message("荒野有它自己的准则！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029106,3))
end
function c79029106.dofil(c,e,tp)
	return c:IsControler(tp) and c:GetReasonPlayer()~=tp and c:IsPreviousLocation(LOCATION_HAND)
end
function c79029106.dotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029106.dofil,1,nil,e,tp) end
	local x=eg:FilterCount(c79029106.dofil,nil,e,tp)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(x*1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,x*1000)
end
function c79029106.doop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,79029106)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Debug.Message("先从警告射击开始~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029106,4))
	if Duel.SelectYesNo(tp,aux.Stringid(79029106,1)) then
	local g=eg:Filter(c79029106.dofil,nil,e,tp):Select(tp,1,1,nil)
	Duel.Overlay(e:GetHandler(),g)
end
end