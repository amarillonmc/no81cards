--连接中断
function c10173070.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10173070.target)
	e1:SetOperation(c10173070.activate)
	c:RegisterEffect(e1)   
end
function c10173070.cfilter(c)
	return c:IsFaceup() and c:GetMutualLinkedGroupCount()>0 and c:IsAbleToChangeControler()
end
function c10173070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10173070.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,nil,1,1-tp,LOCATION_MZONE)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
	   Duel.SetChainLimit(c10173070.limit)
	end
end
function c10173070.limit(e,lp,tp)
	e:GetHandler():IsType(TYPE_LINK)
end
function c10173070.activate(e,tp,eg,ep,ev,re,r,rp)
	for i=1,3 do
		local g=Duel.GetMatchingGroup(c10173070.cfilter,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()<=0 or (i>1 and not Duel.SelectYesNo(tp,aux.Stringid(10173070,1))) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg=g:Select(tp,1,1,nil)
		Duel.GetControl(sg,tp,PHASE_END,1)
	end
end
