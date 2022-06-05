--疾驰龙 全快驱动
function c25000033.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_SYNCHRO),1)
	c:EnableReviveLimit()
	--POS_DEFENSE
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(25000033,0))
	e1:SetCategory(CATEGORY_POSITION) 
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,25000033)
	e1:SetTarget(c25000033.postg)
	e1:SetOperation(c25000033.popop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(25000033,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)	
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,15000033)
	e2:SetTarget(c25000033.sptg)
	e2:SetOperation(c25000033.spop)
	c:RegisterEffect(e2)  
	--to deck 
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,35000033)
	e3:SetCost(c25000033.tdcost)
	e3:SetTarget(c25000033.tdtg)
	e3:SetOperation(c25000033.tdop)
	c:RegisterEffect(e3)
end
function c25000033.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsPosition,tp,0,LOCATION_MZONE,1,nil,POS_FACEUP_ATTACK) end 
end
function c25000033.posop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	--pos
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_POSITION)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c25000033.postg)
	e1:SetValue(POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c25000033.postg(e,c)
	return c:IsFaceup()
end
function c25000033.spfilter(c,e,tp,sync)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c25000033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local ct=mg:GetCount()
	if chk==0 then return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and mg:FilterCount(c25000033.spfilter,nil,e,tp,c)==ct and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end 
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.SetTargetCard(mg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,mg,ct,0,0)
end
function c25000033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end 
	local c=e:GetHandler()
	local mg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=mg:Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()<mg:GetCount() then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<g:GetCount() then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c25000033.tctfil(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtraAsCost()
end
function c25000033.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c25000033.tctfil,tp,LOCATION_MZONE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c25000033.tctfil,tp,LOCATION_MZONE,0,1,1,nil) 
	Duel.SendtoDeck(g,nil,0,REASON_COST) 
end
function c25000033.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
end
function c25000033.tdop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil) 
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end  
end



