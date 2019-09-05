--深界生物 毯毯鼠
local m=33330011
local cm=_G["c"..m]
cm.counter=0x1556   --指 示 物
cm.count=1  --放 置 数 量
function cm.initial_effect(c)
	c:EnableReviveLimit()
	c:EnableCounterPermit(cm.counter)
	--Link Summon
	aux.AddLinkProcedure(c,cm.mfilter,1,1)
	--Destroy & Counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(cm.destg)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	--Negate Attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.atkcost)
	e2:SetCondition(cm.atkcon)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
--Link Summon
function cm.mfilter(c)
	return not c:IsCode(m) and c:IsLinkSetCard(0x556)
end
--Destroy & Counter
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chk==0 then return tc and e:GetHandler():IsCanAddCounter(cm.counter,1) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,e:GetHandler(),1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tc and Duel.Destroy(tc,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) and e:GetHandler():IsFaceup() then
	   e:GetHandler():AddCounter(cm.counter,1)
	end
end
--Negate Attack
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,cm.counter,1,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,cm.counter,1,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end