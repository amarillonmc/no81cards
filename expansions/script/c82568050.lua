--AK-革新者卡涅利安
function c82568050.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_EXTRA)
	c:SetSPSummonOnce(82568050)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--plimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c82568050.pcon)
	e2:SetTarget(c82568050.splimit)
	c:RegisterEffect(e2)  
	--grave pendulum1
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,82568050)
	e3:SetCondition(c82568050.gpencon1)
	e3:SetCost(c82568050.gpencost)
	e3:SetTarget(c82568050.gpentg1)
	e3:SetOperation(c82568050.gpenop1)
	c:RegisterEffect(e3) 
	--grave pendulum2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,82568050)
	e4:SetCondition(c82568050.gpencon2)
	e4:SetCost(c82568050.gpencost)
	e4:SetTarget(c82568050.gpentg2)
	e4:SetOperation(c82568050.gpenop2)
	c:RegisterEffect(e4) 
	Duel.AddCustomActivityCounter(82568050,ACTIVITY_SPSUMMON,c82568050.counterfilter)
	--special summon from hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82568050,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c82568050.spcon)
	e5:SetTarget(c82568050.sptg)
	e5:SetOperation(c82568050.spop)
	c:RegisterEffect(e5)
	 --atklimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e6)
	--Disable
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(82568050,0))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCountLimit(1,82568050)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c82568050.discost)
	e7:SetTarget(c82568050.distg)
	e7:SetOperation(c82568050.disop)
	c:RegisterEffect(e7)
	--todeck
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(82568050,1))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCountLimit(1,82568050)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c82568050.tdcost)
	e8:SetTarget(c82568050.tdtg)
	e8:SetOperation(c82568050.tdop)
	c:RegisterEffect(e8)
	--todeck
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(82568050,2))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_QUICK_O)
	e9:SetCode(EVENT_FREE_CHAIN)
	e9:SetCountLimit(1,82568050)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCost(c82568050.descost)
	e9:SetTarget(c82568050.destg)
	e9:SetOperation(c82568050.desop)
	c:RegisterEffect(e9)
end
function c82568050.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c82568050.splimit(e,c,tp,sumtp,sumpos,re)
	return bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM 
end
function c82568050.pcon(e,c,tp,sumtp,sumpos)
	return Duel.GetCounter(tp,LOCATION_ONFIELD,LOCATION_ONFIELD,0x5825)==0
end
function c82568050.apfilter(c)
	return c:IsFaceup()
end
function c82568050.gravepnfilter(c,csc,apsc,e,tp)
	return (c:GetLevel()>csc and c:GetLevel()<apsc) or (c:GetLevel()<csc and c:GetLevel()>apsc) 
		   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568050.gpencon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568050.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) 
			and Duel.IsPlayerAffectedByEffect(tp,59822133) 
end
function c82568050.gpencost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) and Duel.IsExistingMatchingCard(c82568050.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())  and Duel.GetCustomActivityCount(82568050,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c82568050.splimit2)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
end
function c82568050.splimit2(e,c,sump,sumtype,sumpos,targetp,se)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c82568050.gpentg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local ap=Duel.GetMatchingGroup(c82568050.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			  and Duel.IsExistingMatchingCard(c82568050.gravepnfilter,tp,LOCATION_GRAVE,0,1,nil,csc,apsc,e,tp) and e:GetHandler():GetLeftScale()>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE)
end
function c82568050.gpenop1(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local ap=Duel.GetMatchingGroup(c82568050.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	if not e:GetHandler():IsRelateToEffect(e) 
		  or not Duel.IsExistingMatchingCard(c82568050.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568050.gravepnfilter),tp,LOCATION_GRAVE,0,1,1,nil,csc,apsc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
end
function c82568050.gpencon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82568050.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler())   and not Duel.IsPlayerAffectedByEffect(tp,59822133) 
end
function c82568050.gpentg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler() 
	local ap=Duel.GetMatchingGroup(c82568050.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		 and Duel.IsExistingMatchingCard(c82568050.gravepnfilter,tp,LOCATION_GRAVE,0,1,nil,csc,apsc,e,tp) end
	 Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,LOCATION_GRAVE)
end
function c82568050.gpenop2(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	local c=e:GetHandler()
	local ap=Duel.GetMatchingGroup(c82568050.apfilter,tp,LOCATION_PZONE,0,e:GetHandler()):GetFirst()
	local csc=c:GetLeftScale()
	local apsc=ap:GetLeftScale()
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not e:GetHandler():IsRelateToEffect(e) 
		   or not Duel.IsExistingMatchingCard(c82568050.apfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) then return end
	if lc<=0 then return end
	if lc>=3 then lc=3
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c82568050.gravepnfilter),tp,LOCATION_GRAVE,0,1,lc,nil,csc,apsc,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
end
function c82568050.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.GetFieldCard(tp,LOCATION_PZONE,1) and 
	(Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()-Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetLeftScale()>=9 
	 or Duel.GetFieldCard(tp,LOCATION_PZONE,1):GetLeftScale()-Duel.GetFieldCard(tp,LOCATION_PZONE,0):GetLeftScale()>=9)
end
function c82568050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c82568050.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,SUMMON_TYPE_PENDULUM,tp,tp,true,false,POS_FACEUP)
	c:CompleteProcedure()
end
function c82568050.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82568050.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c82568050.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c82568050.tdfilter(c)
	return c:IsAbleToDeck()
end
function c82568050.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82568050.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c82568050.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) 
	and Duel.IsExistingMatchingCard(c82568050.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
end
function c82568050.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c82568050.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,c82568050.tdfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	g:Merge(g2)
	if c:IsFaceup() and c:IsRelateToEffect(e) and g:GetCount()>0 then
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function c82568050.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,4,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,4,REASON_COST)
end
function c82568050.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end
function c82568050.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c82568050.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) and g:GetCount()>0 then
	Duel.Destroy(g,REASON_EFFECT)
	end
end