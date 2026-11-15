--异戒神将
function c43990913.initial_effect(c)
	c:EnableCounterPermit(0x514)
	--link summon
	aux.AddLinkProcedure(c,nil,4,6,c43990913.lcheck)
	c:EnableReviveLimit()
	--material limit
	local se1=Effect.CreateEffect(c)
	se1:SetType(EFFECT_TYPE_SINGLE)
	se1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	se1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	se1:SetValue(c43990913.sumlimit)
	c:RegisterEffect(se1)
	local se2=se1:Clone()
	se2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(se2)
	local se3=se1:Clone()
	se3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(se3)
	local se4=se1:Clone()
	se4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(se4)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c43990913.atkval)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c43990913.regop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c43990913.efcon)
	e3:SetValue(1)
	e3:SetLabel(3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	--target
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e6:SetValue(aux.tgoval)
	e6:SetLabel(5)
	c:RegisterEffect(e6)
	--remove limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c43990913.rmfilter)
	c:RegisterEffect(e5)
	--cannot release
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_RELEASE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,1)
	e7:SetCondition(c43990913.efcon)
	e7:SetTarget(c43990913.rllimit)
	e7:SetLabel(9)
	c:RegisterEffect(e7)
	--imm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_IMMUNE_EFFECT)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c43990913.efcon)
	e8:SetValue(c43990913.efilter)
	e8:SetLabel(12)
	c:RegisterEffect(e8)
	--to grave
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_TOGRAVE)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetCondition(c43990913.efcon)
	e9:SetTarget(c43990913.tgtg)
	e9:SetOperation(c43990913.tgop)
	e9:SetLabel(15)
	c:RegisterEffect(e9)
	--activate limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_CANNOT_ACTIVATE)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,1)
	e10:SetCondition(c43990913.efcon)
	e10:SetValue(1)
	e10:SetLabel(20)
	c:RegisterEffect(e10)
	--[[--counter
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_COUNTER)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	--e11:SetCost(c43990913.ctcost)
	e11:SetTarget(c43990913.cttg)
	e11:SetOperation(c43990913.ctop)
	c:RegisterEffect(e11)]]
	--to grave
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(43990913,1))
	e12:SetCategory(CATEGORY_TOGRAVE)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e12:SetCode(EVENT_PHASE+PHASE_END)
	e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CAN_FORBIDDEN)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetCondition(c43990913.tgscon)
	e12:SetTarget(c43990913.tgstg)
	e12:SetOperation(c43990913.tgsop)
	c:RegisterEffect(e12)
end
function c43990913.lcheck(g)
	return g:IsExists(Card.IsSummonLocation,1,nil,LOCATION_EXTRA)
end
function c43990913.atkval(e,c)
	return Duel.GetCounter(e:GetHandlerPlayer(),1,9,0x514)*1000
end
function c43990913.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():GetOwner()~=tp then
		e:GetHandler():AddCounter(0x514,1)
	end
end
function c43990913.efcon(e)
	return e:GetHandler():GetCounter(0x514)>=e:GetLabel()
end
function c43990913.rmfilter(e,c,rp,r,re)
	return c==e:GetHandler() and rp~=e:GetHandlerPlayer() and e:GetHandler():GetCounter(0x514)>=7
end
function c43990913.sumlimit(e,c,sumtype)
	if not c then return false end
	return (e:GetCode()~=EFFECT_CANNOT_BE_FUSION_MATERIAL or sumtype==SUMMON_TYPE_FUSION)
end
function c43990913.rllimit(e,c,tp)
	return c==e:GetHandler()
end
function c43990913.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetOwnerPlayer()
end
function c43990913.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c43990913.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND+LOCATION_ONFIELD,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_RULE,1-tp)
	end
end
function c43990913.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and e:IsCostChecked() end
	local ct=Duel.DiscardHand(tp,Card.IsDiscardable,1,283,REASON_COST+REASON_DISCARD)
	e:SetLabel(ct)
end
function c43990913.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsFaceup() then
		c:AddCounter(0x514,e:GetLabel())
	end
end
function c43990913.exfilter(c)
	return c:IsExtraDeckMonster() and not c:IsCode(43990913) and c:IsFaceup()
end
function c43990913.tgscon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c43990913.exfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetTurnPlayer()==1-tp and not (g:IsExists(Card.IsType,1,nil,TYPE_FUSION) and g:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) and g:IsExists(Card.IsType,1,nil,TYPE_XYZ) and g:IsExists(Card.IsType,1,nil,TYPE_LINK))
end
function c43990913.tgstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c43990913.tgsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
