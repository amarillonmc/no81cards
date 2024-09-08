--终焉数码兽 奥米加兽
function c50218150.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetRange(LOCATION_HAND)
	e00:SetCondition(c50218150.spcon)
	e00:SetTarget(c50218150.sptg)
	e00:SetOperation(c50218150.spop)
	c:RegisterEffect(e00)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c50218150.distg)
	c:RegisterEffect(e1)	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c50218150.negcon)
	e2:SetTarget(c50218150.negtg)
	e2:SetOperation(c50218150.negop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(c50218150.thtg)
	e3:SetOperation(c50218150.thop)
	c:RegisterEffect(e3)
end
function c50218150.mfilter(c)
	return c:IsAbleToDeckAsCost() and c:IsCode(50218139,50218140)
end
function c50218150.fselect(g,c,tp)
	return Duel.GetMZoneCount(tp,g)>0 and g:GetClassCount(Card.GetCode)==2
end
function c50218150.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c50218150.mfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c50218150.fselect,2,2,c,tp)
end
function c50218150.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c50218150.mfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c50218150.fselect,true,2,2,c,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c50218150.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Remove(g,POS_FACEUP,REASON_SPSUMMON)
	g:DeleteGroup()
end
function c50218150.distg(e,c)
	return (c:IsType(TYPE_EFFECT) or c:GetOriginalType()&TYPE_EFFECT~=0)
		and c:IsStatus(STATUS_SUMMON_TURN+STATUS_FLIP_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c50218150.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c50218150.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c50218150.setfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)
		and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
end
function c50218150.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)>0 then
		if Duel.IsExistingMatchingCard(c50218150.setfilter,tp,0,LOCATION_GRAVE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(50218150,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,c50218150.setfilter,tp,0,LOCATION_GRAVE,1,1,nil)
			Duel.HintSelection(g)
			Duel.SSet(tp,g)
		end
	end
end
function c50218150.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c50218150.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,0)
end
function c50218150.thop(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.GetFirstMatchingCard(c50218150.thfilter,tp,LOCATION_REMOVED,0,nil,50218139)
	if not t1 then return end
	local t2=Duel.GetFirstMatchingCard(c50218150.thfilter,tp,LOCATION_REMOVED,0,nil,50218140)
	if not t2 then return end
	local g=Group.FromCards(t1,t2)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end