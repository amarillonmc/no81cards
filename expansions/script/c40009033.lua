--机空队 苍天零式
function c40009033.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c40009033.matfilter,3,3)  
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009033,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009033)
	e2:SetCondition(c40009033.thcon)
	e2:SetTarget(c40009033.eqtg)
	e2:SetOperation(c40009033.eqop)
	c:RegisterEffect(e2)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009033,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,40009034)
	e1:SetTarget(c40009033.target)
	e1:SetOperation(c40009033.activate)
	c:RegisterEffect(e1) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,0)
	e3:SetTarget(c40009033.target1)
	e3:SetValue(c40009033.indct)
	c:RegisterEffect(e3)   
end
function c40009033.matfilter(c)
	return c:GetBaseAttack()==0 and c:IsType(TYPE_EFFECT)
end
function c40009033.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c40009033.eqfilter(c,e,tp)
	return c:IsType(TYPE_QUICKPLAY) and c:IsSetCard(0xf22) and c:IsCanBeEffectTarget(e) 
end
function c40009033.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c40009033.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c40009033.eqfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c40009033.eqfilter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,3))
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,g1:GetCount(),0,0)
end
function c40009033.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<g:GetCount() then return end
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local tc=g:GetFirst()
	while tc do
		Duel.Equip(tp,tc,c,true,true)
		tc=g:GetNext()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c40009033.eqlimit)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	Duel.EquipComplete()
end
function c40009033.eqlimit(e,c)
	return e:GetOwner()==c
end
function c40009033.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf22)
end
function c40009033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingMatchingCard(c40009033.cfilter,tp,LOCATION_SZONE,0,1,nil)
		and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c40009033.cfilter,tp,LOCATION_SZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c40009033.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c40009033.target1(e,c)
	return c:IsSetCard(0xf22)
end
function c40009033.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end

