--暗魔之黑锁炎舞阵
function c40009257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009257,1))
	e2:SetCategory(CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,40009258)
	e2:SetCondition(c40009257.thcon)
	e2:SetTarget(c40009257.destg)
	e2:SetOperation(c40009257.desop)
	c:RegisterEffect(e2)
	--activate Necrovalley
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009257,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,40009257)
	e4:SetCondition(c40009257.accon)
	e4:SetTarget(c40009257.rmtg)
	e4:SetOperation(c40009257.rmop)
	c:RegisterEffect(e4)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(c40009257.handcon)
	c:RegisterEffect(e3)	
end
function c40009257.cefilter(c)
	return c:IsFaceup() and (c:IsCode(40009154) or c:IsCode(40009249))
end
function c40009257.handcon(e)
	return Duel.IsExistingMatchingCard(c40009257.cefilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c40009257.accon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c40009257.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c40009257.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c40009257.cfilter(c,tp)
	return c:IsFaceup() and (c:IsSetCard(0xcf1d) or c:IsCode(95474755)) and c:GetSummonPlayer()==tp
end
function c40009257.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c40009257.cfilter,1,nil,tp)
end
function c40009257.filter(c)
	return c:IsFaceup() and c:IsCode(40009259)
end
function c40009257.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local draw=Duel.IsExistingMatchingCard(c40009257.filter,tp,LOCATION_ONFIELD,0,1,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and (not draw or Duel.IsPlayerCanDraw(tp,1)) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
	if draw then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c40009257.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	if Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c40009257.filter,tp,LOCATION_ONFIELD,0,1,nil) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end


