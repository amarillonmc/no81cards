--翠玉碑骑士 阿克迪亚
function c67200781.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200781,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200781)
	e1:SetCost(c67200781.sccost)
	e1:SetTarget(c67200781.thtg)
	e1:SetOperation(c67200781.thop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(c67200781.spcon)
	e2:SetTarget(c67200781.sptg)
	e2:SetOperation(c67200781.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)  
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1,67200782)
	e4:SetCondition(c67200781.negcon)
	e4:SetCost(c67200781.negcost)
	e4:SetTarget(aux.nbtg)
	e4:SetOperation(c67200781.negop)
	c:RegisterEffect(e4)   
end
function c67200781.thfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567c) and c:IsAbleToHand()
end
function c67200781.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200781.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return  Duel.IsExistingMatchingCard(c67200781.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c67200781.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c67200781.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
end
--
function c67200781.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0x567c)
end
function c67200781.sumfilter(c)
	return c:GetLeftScale()
end
function c67200781.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200781.sumfilter,8) 
end
function c67200781.hspgcheck(g)
	if g:GetSum(Card.GetLeftScale)<=8 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,8)
end
function c67200781.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200781.spfilter,tp,LOCATION_EXTRA,0,c)
	aux.GCheckAdditional=c67200781.hspgcheck
	local res=g:CheckSubGroup(c67200781.fselect,1,#g)
	aux.GCheckAdditional=nil
	return res and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c67200781.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c67200781.spfilter,tp,LOCATION_EXTRA,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=c67200781.hspgcheck
	local sg=g:SelectSubGroup(tp,c67200781.fselect,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200781.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
--
function c67200781.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c67200781.costfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_PENDULUM)
end
function c67200781.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200781.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c67200781.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c67200781.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end



