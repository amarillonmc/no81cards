--AK-落叶的守林人-覆雪
function c82568203.initial_effect(c)
	--XYZ summon
	aux.AddXyzProcedure(c,nil,3,2,c82568203.ovfilter,aux.Stringid(82568203,2),2,c82568203.xyzop)
	c:EnableReviveLimit()
	--set
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82568203,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,82568203)
	e5:SetCost(c82568203.cost)
	e5:SetTarget(c82568203.target)
	e5:SetOperation(c82568203.operation)
	c:RegisterEffect(e5)
end
function c82568203.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c82568203.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82568203.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c82568203.setfilter(c)
	return c:IsSetCard(0x825) and (c:IsType(TYPE_TRAP) or (c:IsType(TYPE_SPELL) and c:IsType(TYPE_QUICKPLAY))) and c:IsSSetable()
end
function c82568203.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) 
end
function c82568203.operation(e,tp,eg,ep,ev,re,r,rp)
		local atk=e:GetHandler():GetAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,c82568203.setfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.BreakEffect()
		if Duel.SSet(tp,tc)~=0 and Duel.IsExistingMatchingCard(c82568203.desfilter,tp,0,LOCATION_MZONE,1,nil,atk) and Duel.SelectYesNo(tp,aux.Stringid(82568203,0))
		then
		local dg=Duel.GetMatchingGroup(c82568203.desfilter,tp,0,LOCATION_MZONE,nil,atk)
		if dg:GetCount()>0 then
		Duel.Destroy(dg,REASON_EFFECT)
		end
		end
	end
end
function c82568203.xyzop(e,tp,chk)
	if chk==0 then return  Duel.GetFlagEffect(tp,82568203)==0 end
	Duel.RegisterFlagEffect(tp,82568203,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c82568203.ovfilter(c)
	return c:IsSetCard(0x825) and c:GetCounter(0x5825)>0 
end
