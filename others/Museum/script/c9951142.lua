--妖妖梦·西行妖
function c9951142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9951142.target)
	e1:SetOperation(c9951142.activate)
	c:RegisterEffect(e1)
	 --cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c9951142.condition)
	e2:SetValue(c9951142.evalue)
	c:RegisterEffect(e2)
	--cannot release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCondition(c9951142.condition)
	e3:SetValue(c9951142.sumlimit)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e5:SetValue(c9951142.fuslimit)
	c:RegisterEffect(e5)
	local e6=e3:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e3:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e3:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e8)
   --destory
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,9951142)
	e3:SetCondition(c9951142.descon)
	e3:SetCost(c9951142.cost)
	e3:SetTarget(c9951142.destg)
	e3:SetOperation(c9951142.desop)
	c:RegisterEffect(e3)
end
function c9951142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c9951142.filter(c,e,sp)
	return c:IsLevelAbove(7) and c:IsSetCard(0x3bd2) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c9951142.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(c9951142.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp, aux.Stringid(9951142,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=cg:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg, 0, tp, tp, false, false, POS_FACEUP)
		end
	end
end
function c9951142.condition(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_PZONE,0,2,nil,0x3bd2)
end
function c9951142.sumlimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end
function c9951142.fuslimit(e,c,sumtype)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end
function c9951142.evalue(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp==1-e:GetHandlerPlayer()
end
function c9951142.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bd2) and c:IsType(TYPE_MONSTER)
end
function c9951142.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9951142.cfilter,tp,LOCATION_MZONE,0,1,nil) and e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c9951142.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9951142.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9951142.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
