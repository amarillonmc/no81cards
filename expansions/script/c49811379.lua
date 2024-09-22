--輝き陣列－開閉竜脈28
function c49811379.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--can not chain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_FZONE)
	e1:SetOperation(c49811379.chainop)
	c:RegisterEffect(e1)
	--xyz material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c49811379.xcon)
	e2:SetCost(c49811379.xcost)
	e2:SetTarget(c49811379.xtg)
	e2:SetOperation(c49811379.xop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811379,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c49811379.settg)
	e3:SetOperation(c49811379.setop)
	c:RegisterEffect(e3)
end
function c49811379.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if rc:IsRace(RACE_DRAGON) and loc&(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)~=0 then
		Duel.SetChainLimit(c49811379.chainlm)
	end
end
function c49811379.chainlm(e,rp,tp)
	return tp==rp
end
function c49811379.xfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c49811379.xcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c49811379.xfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c49811379.x1filter(c,g)
	return c:IsAbleToGrave() and g:IsExists(c49811379.x2filter,1,c)
end
function c49811379.x2filter(c)
	return c:IsAbleToRemove()
end
function c49811379.x3filter(c)
	return c:IsAbleToHand()
end
function c49811379.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c49811379.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetOverlayGroup(tp,1,1)
	if chk==0 and e:GetLabel()==100 then return g:IsExists(c49811379.x1filter,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=g:FilterSelect(tp,c49811379.x1filter,1,1,nil,g)
    Duel.SendtoGrave(sg,REASON_COST)
end
function c49811379.xop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetOverlayGroup(tp,1,1)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=g:FilterSelect(tp,c49811379.x2filter,1,1,nil):GetFirst()
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	Duel.BreakEffect()
	local g2=Duel.GetOverlayGroup(tp,1,1)
	if #g2>0 and Duel.SelectYesNo(tp,aux.Stringid(49811379,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc2=g2:FilterSelect(tp,c49811379.x3filter,1,1,nil):GetFirst()
		Duel.SendtoHand(tc2,nil,REASON_EFFECT)
	end
end
function c49811379.setfilter(c)
	return c:IsCode(83195035,5325424) and c:IsSSetable()
end
function c49811379.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811379.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c49811379.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(tp,c49811379.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if sc and Duel.SSet(tp,sc)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
	end
end