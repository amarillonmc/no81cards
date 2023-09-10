--翠玉碑骑士 斯佩尔比亚
function c67200785.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200785,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,67200785)
	e1:SetCost(c67200785.sccost)
	e1:SetTarget(c67200785.sctg)
	e1:SetOperation(c67200785.scop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(c67200785.spcon)
	e2:SetTarget(c67200785.sptg)
	e2:SetOperation(c67200785.spop)
	e2:SetValue(SUMMON_VALUE_SELF)
	c:RegisterEffect(e2)  
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(67200785,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,67200786)
	e3:SetCondition(c67200785.condition)
	e3:SetOperation(c67200785.operation)
	c:RegisterEffect(e3)	
end
function c67200785.scfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200785.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200785.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c67200785.scfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67200785.scfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200785.scfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67200785.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and aux.NecroValleyFilter()(tc) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200785.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToGraveAsCost() and c:IsFaceup() and c:IsSetCard(0x567c)
end
function c67200785.sumfilter(c)
	return c:GetLeftScale()
end
function c67200785.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200785.sumfilter,9) 
end
function c67200785.hspgcheck(g)
	if g:GetSum(Card.GetLeftScale)<=9 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,9)
end
function c67200785.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200785.spfilter,tp,LOCATION_EXTRA,0,c)
	aux.GCheckAdditional=c67200785.hspgcheck
	local res=g:CheckSubGroup(c67200785.fselect,1,#g)
	aux.GCheckAdditional=nil
	return res and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c67200785.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c67200785.spfilter,tp,LOCATION_EXTRA,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=c67200785.hspgcheck
	local sg=g:SelectSubGroup(tp,c67200785.fselect,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200785.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
--
function c67200785.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c67200785.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(c67200785.aclimit)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	Duel.Hint(HINT_CARD,1-tp,67200785)
end
function c67200785.aclimit(e,re,tp)
	local tc=re:GetHandler()
	return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and e:GetHandler():GetColumnGroup():IsContains(tc)
end

