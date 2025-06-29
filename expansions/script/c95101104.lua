--蛇神弗朗西斯
function c95101104.initial_effect(c)
	--chain limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c95101104.cost)
	e1:SetTarget(c95101104.target)
	e1:SetOperation(c95101104.operation)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(95101104,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,95101104)
	e2:SetCost(c95101104.tgcost)
	e2:SetTarget(c95101104.tgtg)
	e2:SetOperation(c95101104.tgop)
	c:RegisterEffect(e2)
end
function c95101104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function c95101104.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,95101104)==0 end
end
function c95101104.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,95101104,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(c95101104.actop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c95101104.actop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_REPTILE) and ep==tp then
		Duel.SetChainLimit(c95101104.chainlm)
	end
end
function c95101104.chainlm(e,rp,tp)
	return tp==rp
end
function c95101104.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c95101104.cfilter(c)
	return (c:IsRace(RACE_REPTILE) or c:IsSetCard(0xbbe) and c:IsType(TYPE_MONSTER)) and c:IsAbleToRemoveAsCost()
end
function c95101104.chkfilter(c,lv)
	return c:IsRace(RACE_REPTILE) and c:IsLevelBelow(lv) and c:IsAbleToGrave()
end
function c95101104.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c95101104.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c95101104.chkfilter,tp,LOCATION_DECK,0,1,nil,#cg)
			and c:IsAbleToRemoveAsCost() end
	local tg=Duel.GetMatchingGroup(c95101104.spfilter,tp,LOCATION_DECK,0,nil,#cg)
	local lvt={}
	for tc in aux.Next(tg) do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(95101104,2))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	local rg1=Group.CreateGroup()
	if lv>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg2=cg:Select(tp,lv-1,lv-1,c)
		rg1:Merge(rg2)
	end
	rg1:AddCard(c)
	Duel.Remove(rg1,POS_FACEUP,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c95101104.tgfilter(c,lv)
	return c:IsRace(RACE_REPTILE) and c:IsLevel(lv) and c:IsAbleToGrave()
end
function c95101104.tgop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c95101104.tgfilter,tp,LOCATION_DECK,0,1,1,nil,lv)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
