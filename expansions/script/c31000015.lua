--Fallacio ex Silentio
function c31000015.initial_effect(c)
	c:SetUniqueOnField(1,0,31000015)
	--XYZ Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),6,2,c31000015.ovfilter,aux.Stringid(31000015,0))
	c:EnableReviveLimit()
	--Protection
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31000015,1))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c31000015.condition)
	e1:SetCost(c31000015.unitcost)
	e1:SetTarget(c31000015.target)
	e1:SetOperation(c31000015.operation)
	c:RegisterEffect(e1)
	--Immunity
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31000015,2))
	e2:SetCategory(CATEGORY_ANNOUNCE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c31000015.cst)
	e2:SetTarget(c31000015.tg)
	e2:SetOperation(c31000015.op)
	c:RegisterEffect(e2)
end

function c31000015.ovfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x308)
end

function c31000015.filter(c)
	return c:IsSetCard(0x308) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end

function c31000015.cst(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c31000015.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,nil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=Duel.SelectMatchingCard(tp,c31000015.filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end

function c31000015.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
	local ag=Group.CreateGroup()
	local codes={}
	for c in aux.Next(g) do
		if c:IsFaceup() then
			local code=c:GetCode()
			if not ag:IsExists(Card.IsCode,1,nil,code) then
				ag:AddCard(c)
				table.insert(codes,code)
			end
		end
	end
	local afilter={codes[1],OPCODE_ISCODE,OPCODE_NOT}
	if #codes>1 then
		for i=2,#codes do
			table.insert(afilter,codes[i])
			table.insert(afilter,OPCODE_ISCODE)
			table.insert(afilter,OPCODE_NOT)
			table.insert(afilter,OPCODE_AND)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp,table.unpack(afilter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end

function c31000015.op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD, LOCATION_ONFIELD)
	e1:SetValue(c31000015.efilter)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterEffect(e1,1-tp)
end

function c31000015.efilter(e,re)
	local code=e:GetLabel()
	return re:GetHandler():IsOriginalCodeRule(code)
end

function c31000015.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end

function c31000015.unitcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function c31000015.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,nil,1,nil,0x308) end
end

function c31000015.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x308))
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
