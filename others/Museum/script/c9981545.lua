--骑士时刻铠武·极武装2013
function c9981545.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xbca),3)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c9981545.efilter)
	c:RegisterEffect(e1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981545,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c9981545.condition)
	e1:SetTarget(c9981545.target)
	e1:SetOperation(c9981545.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9981545,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9981545)
	e2:SetTarget(c9981545.destg)
	e2:SetOperation(c9981545.desop)
	c:RegisterEffect(e2)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9981545.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9981545.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981545,0))
end
function c9981545.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER) and re:GetOwner()~=e:GetOwner()
end
function c9981545.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9981545.filter(c,e,tp,ec)
	return c:IsSetCard(0xbca) and c:IsType(TYPE_EQUIP) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c9981545.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_DECK+LOCATION_GRAVE) and c9981545.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9981545.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c9981545.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9981545,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g2=g:Select(tp,1,1,nil)
		g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode())
		g1:Merge(g2)
		if ft>2 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9981545,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			g2=g:Select(tp,1,1,nil)
			g1:Merge(g2)
		end
	end
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c9981545.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<g:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g:GetNext()
	end
	Duel.EquipComplete()
end
function c9981545.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xbca) and c:IsType(TYPE_EQUIP)
end
function c9981545.desfilter(c)
	return c:IsFaceup()
end
function c9981545.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981545.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c9981545.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c9981545.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9981545.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c9981545.cfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c9981545.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9981545,2))
end