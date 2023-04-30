--翠玉碑骑士 阿瓦里提亚
function c67200787.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200787,0))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200787)
	e1:SetCost(c67200787.sccost)
	e1:SetTarget(c67200787.sctg)
	e1:SetOperation(c67200787.scop)
	c:RegisterEffect(e1)
	--spsummon proc
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e2:SetCondition(c67200787.spcon)
	e2:SetTarget(c67200787.sptg)
	e2:SetOperation(c67200787.spop)
	c:RegisterEffect(e2)  
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(67200787,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCountLimit(1,67200788)
	e4:SetCost(c67200787.rmcost)
	e4:SetTarget(c67200787.rmtg)
	e4:SetOperation(c67200787.rmop)
	c:RegisterEffect(e4)	
end
function c67200787.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x567c) and c:IsAbleToExtra()
end
function c67200787.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200787.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200787.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function c67200787.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200787,2))
	local g=Duel.SelectMatchingCard(tp,c67200787.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
end
--
function c67200787.spfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:GetLeftScale()>0 and c:IsAbleToGraveAsCost() and c:IsFaceup()
end
function c67200787.sumfilter(c)
	return c:GetLeftScale()
end
function c67200787.fselect(g,tp)
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(c67200787.sumfilter,9) 
end
function c67200787.hspgcheck(g)
	if g:GetSum(Card.GetLeftScale)<=9 then return true end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(Card.GetLeftScale,9)
end
function c67200787.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c67200787.spfilter,tp,LOCATION_EXTRA,0,c)
	aux.GCheckAdditional=c67200787.hspgcheck
	local res=g:CheckSubGroup(c67200787.fselect,1,#g)
	aux.GCheckAdditional=nil
	return res and ((c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or
		(c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0))
end
function c67200787.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c67200787.spfilter,tp,LOCATION_EXTRA,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=c67200787.hspgcheck
	local sg=g:SelectSubGroup(tp,c67200787.fselect,true,1,#g)
	aux.GCheckAdditional=nil
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c67200787.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
--
function c67200787.costfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_PENDULUM)
end
function c67200787.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200787.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c67200787.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c67200787.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c67200787.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end

