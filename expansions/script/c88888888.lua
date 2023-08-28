--宇宙巨神-恐惧之旧影
function c88888888.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,5,c88888888.ovfilter,aux.Stringid(88888888,0),99,c88888888.xyzop)
	c:EnableReviveLimit()
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c88888888.splimit)
	c:RegisterEffect(e0)
	--recycle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(88888888,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e1:SetTarget(c88888888.target)
	e1:SetOperation(c88888888.operation)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(88888888,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE) 
	e2:SetCost(c88888888.cost)
	e2:SetTarget(c88888888.tg)
	e2:SetOperation(c88888888.op)
	c:RegisterEffect(e2)
end
function c88888888.splimit(e,se,sp,st)
	return not se or  not se:IsHasType(EFFECT_TYPE_ACTIONS)
end
function c88888888.mfilter(c)
	return (c:IsLevel(8) or c:IsRank(8)) and c:IsRace(RACE_DRAGON)
end
function c88888888.ovfilter(c)
	if c:GetOverlayCount()<1 then return false end
	local sg=c:GetOverlayGroup()
	return c:IsFaceup() and c:IsRank(8) and c:IsRace(RACE_DRAGON) and sg:IsExists(c88888888.mfilter,5,nil,0) 
end
function c88888888.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,88888888)==0 end
	Duel.RegisterFlagEffect(tp,88888888,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c88888888.filter(c,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c88888888.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c88888888.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE)>-1
		and Duel.IsExistingTarget(c88888888.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local x=5-Duel.GetMatchingGroupCount(aux.TRUE,tp,0,LOCATION_SZONE,nil)
	local g=Duel.SelectTarget(tp,c88888888.filter,tp,LOCATION_GRAVE,0,0,x,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function c88888888.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	for i=1,#g do
		local g1=g:GetFirst()
		Duel.MoveToField(g1,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		g:RemoveCard(g1)
	end
end
function c88888888.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c88888888.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	
end
function c88888888.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*200
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_UPDATE_ATTACK)
		e0:SetValue(val)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e0)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		if e:GetLabel()==0 then
		 e1:SetValue(c88888888.efilter1)
		elseif e:GetLabel()==1 then
		 e1:SetValue(c88888888.efilter2)
		 else
		 e1:SetValue(c88888888.efilter3)
		 end
		c:RegisterEffect(e1)
	end
end
function c88888888.efilter1(e,te)
	return  te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c88888888.efilter2(e,te)
	return  te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end
function c88888888.efilter3(e,te)
	return  te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
end