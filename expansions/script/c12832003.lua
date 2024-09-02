--迷失之蝶
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,12832001,12832002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.actcost)
	e1:SetTarget(s.acttg)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.lpcon)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end
function s.acfilter(c,ec)
	return (c:IsFaceup() and c:IsCode(12832002) and c:IsAbleToGraveAsCost()) 
		or (c:IsFaceupEx() and c:IsCode(12832007) and c:IsAbleToExtraAsCost()
		and ec:GetFlagEffect(12832007)~=0)
end
function s.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.acfilter,tp,LOCATION_SZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetHandler())
	if g:GetFirst():IsCode(12832007) then
		Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_COST)
	else
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetOperation(s.disop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if re:IsHasCategory(CATEGORY_RECOVER) then
		Duel.Hint(HINT_CARD,0,id)
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,s.repop)
	end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	return
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	return a and a:IsRelateToBattle() and (a:IsCode(12832001) or aux.IsCodeListed(a,12832001)) and (not d or d:IsPosition(POS_FACEUP_ATTACK))
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_CARD,0,id)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-a:GetAttack())
end