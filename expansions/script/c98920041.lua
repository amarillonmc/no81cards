--护木枪管处刑龙
function c98920041.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920041,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCost(c98920041.spcost)
	e1:SetTarget(c98920041.target)
	e1:SetOperation(c98920041.operation)
	c:RegisterEffect(e1)
--Damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920041,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c98920041.cost)
	e3:SetOperation(c98920041.damop)
	c:RegisterEffect(e3)
	if c98920041.counter==nil then
		c98920041.counter=true
		c98920041[0]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e4:SetOperation(c98920041.resetcount)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_DESTROYED)
		e5:SetOperation(c98920041.addcount)
		Duel.RegisterEffect(e5,0)
	end
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(aux.bdocon)
	e6:SetOperation(c98920041.bdop)
	c:RegisterEffect(e6)
end
function c98920041.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_BATTLE_PHASE)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c98920041.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920041.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0) 
	Duel.SetChainLimit(c98920041.chlimit)
end
function c98920041.chlimit(e,ep,tp)
	return tp==ep
end
function c98920041.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function c98920041.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920041.damop(e,tp,eg,ep,ev,re,r,rp)
	if c98920041[0]>0 then
		local ct=c98920041[0]*500
		Duel.Hint(HINT_CARD,0,98920041)
		Duel.Damage(1-tp,ct,REASON_EFFECT)
	end
end
function c98920041.bdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #sg>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
function c98920041.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c98920041[0]=0
end
function c98920041.addcount(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	c98920041[0]=c98920041[0]+ct
end