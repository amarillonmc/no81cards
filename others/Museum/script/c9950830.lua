--fate·项羽
function c9950830.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950830,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c9950830.spcon)
	e2:SetOperation(c9950830.spop)
	c:RegisterEffect(e2)
 --equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950830,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c9950830.target)
	e1:SetOperation(c9950830.operation)
	c:RegisterEffect(e1)
 --Negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950830,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950830.negcon)
	e3:SetCost(c9950830.negcost)
	e3:SetTarget(c9950830.negtg)
	e3:SetOperation(c9950830.negop)
	c:RegisterEffect(e3)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950830.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950830.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950830,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950830,1))
end
function c9950830.rfilter(c,tp)
	return c:IsSetCard(0xba5) and (c:IsControler(tp) or c:IsFaceup())
end
function c9950830.mzfilter(c,tp)
	return c:IsControler(tp) and c:GetSequence()<5
end
function c9950830.rmzfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsControler(tp) and c:GetSequence()<5
end
function c9950830.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	return ft>-3 and rg:GetCount()>2 and rg:IsExists(c9950830.rfilter,1,nil,tp)
		and (ft>0 or rg:IsExists(c9950830.mzfilter,ct,nil,tp))
		and (ft>-2 or rg:IsExists(c9950830.rmzfilter,1,nil,tp))
end
function c9950830.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=nil
	if ft>-2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,Card.IsSetCard,1,1,nil,0xba5)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:FilterSelect(tp,c9950830.rmzfilter,1,1,nil,tp)
	end
	local tc=g:GetFirst()
	if tc:IsControler(tp) and tc:GetSequence()<5 then ft=ft+1 end
	if ft>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:Select(tp,2,2,tc)
		g:Merge(g2)
	elseif ft>-1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c9950830.mzfilter,1,1,tc,tp)
		g:Merge(g2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g3=rg:Select(tp,1,1,g)
		g:Merge(g3)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g2=rg:FilterSelect(tp,c9950830.mzfilter,2,2,tc,tp)
		g:Merge(g2)
	end
	Duel.Release(g,REASON_COST)
end
function c9950830.filter(c,e,tp,ec)
	return c:IsSetCard(0xba5) and c:IsCanBeEffectTarget(e) and c:CheckUniqueOnField(tp) and c:CheckEquipTarget(ec)
end
function c9950830.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9950830.filter(chkc,e,tp,e:GetHandler()) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c9950830.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler()) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local g=Duel.GetMatchingGroup(c9950830.filter,tp,LOCATION_GRAVE,0,nil,e,tp,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g1=g:SelectSubGroup(tp,aux.dncheck,false,1,math.min(ft,4))
	Duel.SetTargetCard(g1)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g1,g1:GetCount(),0,0)
end
function c9950830.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c9950830.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp and Duel.IsChainNegatable(ev)
end
function c9950830.negfilter(c)
	return (c:IsFaceup() or c:GetEquipTarget()) and c:IsType(TYPE_EQUIP) and c:IsAbleToGraveAsCost()
end
function c9950830.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950830.negfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9950830.negfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9950830.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c9950830.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950830,2))
end
