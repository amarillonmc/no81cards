local m=31400014
local cm=_G["c"..m]
cm.name="永恒二重龙"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_DUAL),4,2,cm.ovfilter,aux.Stringid(m,0))
	Duel.AddCustomActivityCounter(m,ACTIVITY_SUMMON,cm.counterfilter)
	if cm.eternity_dual==nil then
		cm.eternity_dual={0}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e1_1=e1:Clone()
	e1_1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e1_1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1_2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.dualtg)
	e2:SetCode(EFFECT_DUAL_STATUS)
	Duel.RegisterEffect(e2,0)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.counterfilter(c)
	return not c:IsType(TYPE_EFFECT)
end
function cm.ovfilter(c)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SUMMON)==0 and c:IsFaceup() and c:IsCode(m) 
end
function cm.filter(c)
	return c:IsType(TYPE_DUAL) and c:IsDualState()
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g:ForEach(
		function (card)
			flag=true
			local code=card:GetCode()
			for i,num in pairs(cm.eternity_dual) do
				if num==code then
					flag=false
					break
				end
			end
			if flag then
				table.insert(cm.eternity_dual,code)
			end
		end
	)
end
function cm.dualtg(e,c)
	return c:IsFaceup() and c:IsCode(table.unpack(cm.eternity_dual))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,m)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_DUAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sufilter(c)
	return c:IsType(TYPE_DUAL) and c:IsSummonable(true,nil)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) and Duel.IsExistingMatchingCard(cm.sufilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		Duel.Summon(tp,Duel.SelectMatchingCard(tp,cm.sufilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst(),true,nil)
	end
end