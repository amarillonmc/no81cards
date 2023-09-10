--翠玉碑骑士 伊拉
function c67200779.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200779,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200779)
	e1:SetCost(c67200779.sccost)
	e1:SetTarget(c67200779.sctg)
	e1:SetOperation(c67200779.scop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(c67200779.spcon)
	e2:SetTarget(c67200779.sptg)
	e2:SetOperation(c67200779.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)	 
end
function c67200779.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567c) and not c:IsForbidden()
end
function c67200779.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200779.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c67200779.scfilter(chkc,e,tp) end
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingTarget(c67200779.scfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200779,2))
	local g=Duel.SelectTarget(tp,c67200779.scfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,tp,LOCATION_GRAVE)
end
function c67200779.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
	end
end
--
function c67200779.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0x567c)
end
function c67200779.sumfilter(c)
	return c:GetLeftScale()
end
function c67200779.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200779.sumfilter,7) 
end
function c67200779.hspgcheck(g)
	if g:GetSum(Card.GetLeftScale)<=7 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,7)
end
function c67200779.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200779.spfilter,tp,LOCATION_EXTRA,0,c)
	aux.GCheckAdditional=c67200779.hspgcheck
	local res=g:CheckSubGroup(c67200779.fselect,1,#g)
	aux.GCheckAdditional=nil
	return res and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c67200779.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c67200779.spfilter,tp,LOCATION_EXTRA,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=c67200779.hspgcheck
	local sg=g:SelectSubGroup(tp,c67200779.fselect,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200779.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	local sg=Duel.GetOperatedGroup()
	local x=0
	local y=0
	local tc=sg:GetFirst()
	while tc do
		y=tc:GetBaseAttack()
		x=x+y
		tc=sg:GetNext()
	end
	--return x
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(x)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	g:DeleteGroup()
end



