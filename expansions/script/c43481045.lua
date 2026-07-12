--极寒之世界树 维里斯佩克斯
local s,id,o=GetID()
function s.initial_effect(c)
	--xyz summon
	aux.AddCodeList(c,43481015)
	aux.AddXyzProcedure(c,nil,10,6,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.actcon)
	e1:SetOperation(s.sumsuc)
	c:RegisterEffect(e1)
	--effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end
function s.chainfilter(re,tp,cid)
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)
	return not (re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and re:GetHandler():IsOriginalCodeRule(43481015))
end

function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(43481015) and Duel.GetCustomActivityCount(id,c:GetControler(),ACTIVITY_CHAIN)==0
end
function s.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.actlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.actlimit(e,re,tp)
	rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsOriginalCodeRule(43481015) and rc:IsLocation(LOCATION_MZONE)
end
--effect 2 cost
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--effect 2 target
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
--effect 2 operation
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,2,nil)
	Duel.HintSelection(sg)
	local dg=Duel.Destroy(sg,REASON_EFFECT)
	if dg>0 then
		local og=Duel.GetOperatedGroup()
		local names={}
		local tc=og:GetFirst()
		while tc do
			local tn=tc:GetOriginalCodeRule()
			if tn and not names[tn] then
				names[tn]=true
			end
			tc=og:GetNext()
		end
		local filters={}
		for code,_ in pairs(names) do
			table.insert(filters,code)
		end
		if #filters>0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,filters)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local thg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,filters)
			if thg:GetCount()>0 then
				Duel.SendtoHand(thg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,thg)
			end
		end
	end
end
function s.thfilter(c,filters)
	return c:IsAbleToHand() and c:IsCode(table.unpack(filters))
end