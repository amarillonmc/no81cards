--封缄的双人连携
function c67200291.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--limit SpSummon  
	c:SetSPSummonOnce(67200291) 
	--fusion material  
	c:EnableReviveLimit()  
	aux.AddFusionProcFunRep(c,c67200291.ffilter,2,false) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE+LOCATION_PZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)   
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200291,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e2:SetCountLimit(1,67200291)
	e2:SetCost(c67200291.discost)
	e2:SetTarget(c67200291.distg)
	e2:SetOperation(c67200291.disop)
	c:RegisterEffect(e2) 
end
--
function c67200291.ffilter(c,fc,sub,mg,sg)  
	return c:IsFusionSetCard(0x674) and c:IsFusionType(TYPE_PENDULUM) and (not sg or sg:FilterCount(aux.TRUE,c)==0 or sg:IsExists(c67200291.f2filter,1,c,c:GetLeftScale()))
end
function c67200291.f2filter(c,les)
	return c:IsFusionType(TYPE_PENDULUM) and c:GetLeftScale()>8-les
end
--
function c67200291.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c67200291.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and aux.NegateEffectMonsterFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	Duel.SelectTarget(tp,aux.NegateEffectMonsterFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function c67200291.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

