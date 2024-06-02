--洗狩兔
local m=11561058
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11561058)
	e1:SetCost(c11561058.cost)
	e1:SetOperation(c11561058.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,11561058)
	e2:SetCondition(c11561058.xbcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c11561058.xbtg)
	e2:SetOperation(c11561058.xbop)
	c:RegisterEffect(e2)
	if c11561058.counter==nil then
		c11561058.counter=true
		c11561058[0]=0
		c11561058[1]=0
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetOperation(c11561058.resetcount)
		Duel.RegisterEffect(e3,0)
	end
	
end
function c11561058.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c11561058[0]=0
	c11561058[1]=0
end
function c11561058.xbcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.exccon(e)
end
function c11561058.xbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0
		and Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c11561058.stfilter(c,ac)
	return not c:IsCode(ac)
end
function c11561058.xbop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	local ct
	if g:GetCount()>0 then
		ct=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		c11561058[1-tp]=c11561058[1-tp]+ct
	end
	local bg=Duel.GetMatchingGroup(c11561058.stfilter,tp,0,LOCATION_HAND,nil,ac)
	local bc=bg:GetCount()
	while Duel.GetLP(tp)>2000 and bc>0 do
		Duel.SetLP(tp,math.ceil(Duel.GetLP(tp)/2))
		bc=bc-1
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetOperation(c11561058.dr)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c11561058.dr(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(1-tp,c11561058[1-tp],REASON_EFFECT)
end

function c11561058.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() and e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c11561058.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--counter2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(c11561058.regop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(c11561058.damcon)
	e3:SetOperation(c11561058.damop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c11561058.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(11561058,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c11561058.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(11561058)~=0
end
function c11561058.damop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION),LOCATION_HAND)~=0 then
	Duel.Hint(HINT_CARD,0,11561058)
	Duel.Recover(ep,300,REASON_EFFECT) end
end