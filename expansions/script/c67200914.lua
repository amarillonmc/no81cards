--废都雷狼
function c67200914.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c67200914.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200914,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,67200914)
	e1:SetCost(c67200914.damcost)
	e1:SetTarget(c67200914.damtg)
	e1:SetOperation(c67200914.damop)
	c:RegisterEffect(e1)
end
function c67200914.indtg(e,c)
	return c:IsSetCard(0x967a) and c:IsFaceup()
end
--
function c67200914.costfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x67a)
end
function c67200914.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b2=Duel.IsExistingMatchingCard(c67200914.costfilter,tp,LOCATION_HAND,0,1,c)
	if chk==0 then return c:IsDiscardable() and b2 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200914,3))
	local g=Duel.SelectMatchingCard(tp,c67200914.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoExtraP(g,nil,REASON_COST)
end
function c67200914.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c67200914.spfilter(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200914)) then return false end
	return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c67200914.spfilter1(c,e,tp)
	if not (c:IsSetCard(0x67a) and c:IsFaceup() and c:IsType(TYPE_PENDULUM) and not c:IsCode(67200914)) then return false end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200914.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)>0 then
		local sg=Duel.GetMatchingGroup(c67200914.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(67200914,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=sg:Select(tp,1,1,nil)
			Duel.BreakEffect()
			local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
			local b2=sc:IsExists(c67200914.spfilter1,1,nil,e,tp)
			local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(67200914,3)},{b2,1152})
			if op==1 then
				Duel.MoveToField(sc:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
			if op==2 then
				Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end