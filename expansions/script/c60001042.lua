--灵刀联合 灵域统括
function c60001042.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001042,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c60001042.cost)
	e1:SetTarget(c60001042.target)
	e1:SetOperation(c60001042.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001042,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60001042)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60001042.settg)
	e2:SetOperation(c60001042.setop)
	c:RegisterEffect(e2)
end
function c60001042.filter1(c)
	return c:GetSequence()<5 and c:IsAbleToRemove()
end
function c60001042.filter2(c)
	return c:GetSequence()>4 and c:IsAbleToRemove()
end
function c60001042.filter3(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c60001042.filter4(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c60001042.costfilter(c)
	return c:IsSetCard(0x624) and c:IsAbleToGraveAsCost()
end
function c60001042.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rt=4
	if not Duel.IsExistingMatchingCard(c60001042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then rt=rt-1 end
	if not Duel.IsExistingMatchingCard(c60001042.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) then rt=rt-1 end
	if not Duel.IsExistingMatchingCard(c60001042.filter3,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) then rt=rt-1 end
	if not Duel.IsExistingMatchingCard(c60001042.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) then rt=rt-1 end
	local cg=Duel.GetMatchingGroup(c60001042.costfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
	local ct=cg:GetClassCount(Card.GetCode)
	if chk==0 then return rt>0 and ct>0 end
	local ctt={}
	local ctp=1
	while rt>=ctp and ct>=ctp do
		ctt[ctp]=ctp
		ctp=ctp+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(60001042,0))
	local st=Duel.AnnounceNumber(tp,table.unpack(ctt))
	local rg=Group.CreateGroup()
	for i=1,st do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(tp,1,1,nil)
		cg:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
		rg:Merge(sg)
	end
	Duel.SendtoGrave(rg,REASON_COST)
	e:SetLabel(st)
end
function c60001042.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsExistingMatchingCard(c60001042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(c60001042.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b3=Duel.IsExistingMatchingCard(c60001042.filter3,tp,LOCATION_SZONE,LOCATION_SZONE,1,c)
	local b4=Duel.IsExistingMatchingCard(c60001042.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,c)
	if chk==0 then return b1 or b2 or b3 or b4 end
	local ct=e:GetLabel()
	if ct>=3 then Duel.SetChainLimit(c60001042.chainlm) end
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(60001042,1)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(60001042,2)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(60001042,3)
			opval[off-1]=3
			off=off+1
		end
		if b4 then
			ops[off]=aux.Stringid(60001042,4)
			opval[off-1]=4
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			sel=sel+1
			b1=false
		elseif opval[op]==2 then
			sel=sel+2
			b2=false
		elseif opval[op]==3 then
			sel=sel+4
			b3=false
		else
			sel=sel+8
			b4=false
		end
		ct=ct-1
	until ct==0 or off<3
	e:SetLabel(sel)
	if bit.band(sel,1)~=0 then
		local g=Duel.GetMatchingGroup(c60001042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_MZONE)
	end
	if bit.band(sel,2)~=0 then
		local g=Duel.GetMatchingGroup(c60001042.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_MZONE)
	end
	if bit.band(sel,3)~=0 then
		local g=Duel.GetMatchingGroup(c60001042.filter3,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_SZONE)
	end
	if bit.band(sel,4)~=0 then
		local g=Duel.GetMatchingGroup(c60001042.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,LOCATION_SZONE)
	end
end
function c60001042.chainlm(e,rp,tp)
	return tp==rp
end
function c60001042.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if bit.band(sel,1)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60001042.filter1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if bit.band(sel,2)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60001042.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if bit.band(sel,4)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60001042.filter3,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if bit.band(sel,8)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c60001042.filter4,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,c)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c60001042.stfilter(c)
	return c:IsSetCard(0x624) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c60001042.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c60001042.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function c60001042.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c60001042.stfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end

