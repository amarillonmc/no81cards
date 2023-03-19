--海晶少女 黄纹斗
local m=42620042
local cm=_G["c"..m]

function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.condition2)
	c:RegisterEffect(e2)
	--paylp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_COST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0xff,0xff)
	e3:SetCondition(cm.costcon)
	e3:SetCost(cm.costchk)
	e3:SetOperation(cm.costop)
	c:RegisterEffect(e3)
	--accumulate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(0x10000000+42620042)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(cm.costcon)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
end

function cm.conqfilter(c)
	return c:IsType(TYPE_LINK+TYPE_MONSTER) and c:IsSetCard(0x12b) and c:IsLinkAbove(2)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.conqfilter,tp,LOCATION_MZONE,0,1,nil)
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.conqfilter,tp,LOCATION_MZONE,0,1,nil)
end

function cm.costfilter(c)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsSetCard(0x12b) and c:IsDiscardable()
end

function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() 
	and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
	e:SetLabelObject(tc)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end

function cm.opsfilter(c,code)
	return c:IsCode(code) and c:IsSSetable()
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	and Duel.IsExistingMatchingCard(cm.opsfilter,tp,LOCATION_DECK,0,1,nil,tc:GetCode()) 
	and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if g:GetCount()>0 then
			local sc=g:GetFirst()
			Duel.SSet(tp,sc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			sc:RegisterEffect(e1)
		end
	end
end

function cm.costcfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLinkAbove(3) and c:IsType(TYPE_LINK)
end

function cm.costcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.costcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	if tc then
		while tc do
			local lg=tc:GetLinkedGroup()
			if lg:IsContains(c) then return true end
			tc=g:GetNext()
		end
	end
end

function cm.costchk(e,te_or_c,tp)
	local c=e:GetHandler()
	local ctp=c:GetControler()
	local ct=Duel.GetFlagEffect(tp,42620042)
	if tp==1-ctp then
		return Duel.CheckLPCost(tp,ct*700)
	else
		return true 
	end
end

function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ctp=c:GetControler()
	if tp==1-ctp then
		Duel.Hint(HINT_CARD,0,m)
		Duel.PayLPCost(tp,700)
	end
end