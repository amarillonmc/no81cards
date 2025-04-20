--季沧海
local cm,m,o=GetID()
function cm.initial_effect(c)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon1)
	c:RegisterEffect(e1)
	local ce1=e1:Clone()
	ce1:SetRange(LOCATION_DECK)
	ce1:SetCountLimit(1,m)
	ce1:SetCondition(cm.spcon2)
	c:RegisterEffect(ce1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW+CATEGORY_LEAVE_GRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,m+10000000)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)

	
	local ce2=Effect.CreateEffect(c)
	ce2:SetType(EFFECT_TYPE_SINGLE)
	ce2:SetCode(EFFECT_UPDATE_ATTACK)
	ce2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ce2:SetRange(LOCATION_MZONE)
	ce2:SetCondition(cm.tttcon)
	ce2:SetValue(1000)
	c:RegisterEffect(ce2)
	local ce3=ce2:Clone()
	ce3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ce3)
	local ce4=Effect.CreateEffect(c)
	ce4:SetType(EFFECT_TYPE_SINGLE)
	ce4:SetCode(EFFECT_PIERCE)
	ce4:SetValue(DOUBLE_DAMAGE)
	ce4:SetCondition(cm.tttcon)
	c:RegisterEffect(ce4)
	--search
	local ce5=Effect.CreateEffect(c)
	ce5:SetDescription(aux.Stringid(23410107,2))
	ce5:SetCategory(CATEGORY_DESTROY)
	ce5:SetType(EFFECT_TYPE_QUICK_O)
	ce5:SetCode(EVENT_FREE_CHAIN)
	ce5:SetRange(LOCATION_MZONE)
	ce5:SetCountLimit(1)
	ce5:SetCost(cm.dcost)
	ce5:SetCondition(cm.tttcon)
	ce5:SetTarget(cm.dtg)
	ce5:SetOperation(cm.dop)
	c:RegisterEffect(ce5)
end
function cm.indtg(e,c)
	local tc=e:GetHandler()
	return c==tc or c==tc:GetBattleTarget()
end
function cm.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m)
		and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.fil(c)
	return c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and (Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,0,1,nil) or Duel.IsExistingMatchingCard(cm.fil,tp,LOCATION_MZONE,0,1,nil)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function cm.tttcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),m)
end
function cm.dcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function cm.dtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function cm.dop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
	end
end