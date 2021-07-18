--妖圣骑士影 崔斯坦·芭万希
function c40009786.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x107a),4,3,c40009786.ovfilter,aux.Stringid(40009786,0),3,c40009786.xyzop)
	c:EnableReviveLimit()  
	--equip
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(40009786,0))
	--e1:SetCategory(CATEGORY_EQUIP)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	--e1:SetCondition(c40009786.condition)
	--e1:SetTarget(c40009786.target)
	--e1:SetOperation(c40009786.operation)
	--c:RegisterEffect(e1) 
   --negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009786,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(c40009786.descost)
	e2:SetTarget(c40009786.destg)
	e2:SetOperation(c40009786.desop)
	c:RegisterEffect(e2) 
end
function c40009786.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107a) and c:GetEquipCount()>0
end
function c40009786.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,40009786)==0 end
	Duel.RegisterFlagEffect(tp,40009786,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c40009786.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009786.filter(c,ec)
	return c:IsSetCard(0x207a) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(ec)
end
function c40009786.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009786.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function c40009786.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c40009786.filter,tp,LOCATION_DECK,0,1,1,nil,c)
	local tc=g:GetFirst()
	if tc then
		Duel.Equip(tp,tc,c)
	end
end
function c40009786.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c40009786.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x207a) and c:IsType(TYPE_EQUIP)
end
function c40009786.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c40009786.desfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,nil)
	--local ct=g:GetClassCount(Card.GetCode)
	--if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,c40009786.desfilter,tp,LOCATION_SZONE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c40009786.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=Duel.Destroy(dg,REASON_EFFECT)
	if ct>=1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_GRAVE,1,1,nil)
		if g1:GetCount()>0 then
			Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
		end
	end
	local hg1=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	if ct>=2 and hg1:GetCount()>0 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g2:GetCount()>0 then
			Duel.SendtoDeck(g2,nil,0,REASON_EFFECT)
		end
	end
	--local rg=Duel.GetFieldGroup(ep,0,LOCATION_HAND,nil)
	if ct==3 then
		Duel.BreakEffect()
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)<=0 then return end
		local g3=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.SendtoDeck(g3,nil,0,REASON_EFFECT)
	end
end



