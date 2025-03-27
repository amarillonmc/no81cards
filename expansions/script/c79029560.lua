--CiNo.89 电脑兽 混沌网络神
function c79029560.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,4)
	c:EnableReviveLimit() 
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c79029560.rmcost)
	e1:SetTarget(c79029560.rmtg)
	e1:SetOperation(c79029560.rmop)
	c:RegisterEffect(e1)
	--Remove
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79029560.rmtg1)
	e2:SetOperation(c79029560.rmop1)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(c79029560.val)
	e3:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--swap lp
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetOperation(c79029560.slop)
	c:RegisterEffect(e5)
end
aux.xyz_number[79029560]=89
function c79029560.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c79029560.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function c79029560.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,nil)
	local sg=g:RandomSelect(tp,1)
	local tc=sg:GetFirst()
	if tc:IsType(TYPE_XYZ) then
	local lv=tc:GetRank()
	else local lv=tc:GetLevel() 
	Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	local a=Duel.GetDecktopGroup(tp,lv)
	Duel.SendtoGrave(a,REASON_EFFECT)
end
end
function c79029560.rmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local x=eg:GetCount()
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,x,1-tp,LOCATION_DECK)
end
function c79029560.rmop1(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	Duel.Hint(HINT_CARD,0,79029560)
	local x=eg:GetCount()
	local g=Duel.GetDecktopGroup(1-tp,x)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT+REASON_RULE)
end
function c79029560.slop(e,tp,eg,ep,ev,re,r,rp)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	if lp1>=lp2 then return end
	Duel.SetLP(tp,lp2)
	Duel.SetLP(1-tp,lp1)
end
function c79029560.val(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*100
end









