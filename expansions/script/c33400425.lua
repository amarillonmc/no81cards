--AST 鸢一折纸 过往
function c33400425.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,c33400425.xyzfilter,4,2)
	c:EnableReviveLimit()
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400425,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c33400425.cost)
	e2:SetTarget(c33400425.eqtg)
	e2:SetOperation(c33400425.eqop)
	c:RegisterEffect(e2)
end
function c33400425.xyzfilter(c)
	return c:IsSetCard(0x5342)  or c:IsSetCard(0x9343)
end
function c33400425.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)   
end
function c33400425.filter(c,e,tp,ec)
	return c:IsSetCard(0x6343)  and c:CheckEquipTarget(ec)and c:CheckUniqueOnField(tp)
end
function c33400425.filter2(c)
	return c:IsSetCard(0xc343)  
end
function c33400425.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c33400425.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c33400425.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,0,0,0,0)
end
function c33400425.eqop(e,tp,eg,ep,ev,re,r,rp)
   if not Duel.IsExistingMatchingCard(c33400425.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler())
	or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.IsExistingMatchingCard(c33400425.filter2,tp,LOCATION_MZONE,0,1,nil) then return false end
	local g=Duel.GetMatchingGroup(c33400425.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	local tc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local tc2=Duel.SelectMatchingCard(tp,c33400425.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	 local tc1=tc2:GetFirst()
	 Duel.Equip(tp,tc,tc1)
end