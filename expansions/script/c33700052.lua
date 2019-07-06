--防御觉醒
function c33700052.initial_effect(c)
	  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33700052.cost)
	e1:SetOperation(c33700052.activate)
	c:RegisterEffect(e1)
end
function c33700052.filter(c)
	return c:IsReleasable() 
end
function c33700052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and g:FilterCount(c33700052.filter,nil)==g:GetCount() end
	Duel.Release(g,REASON_COST)
end
function c33700052.spfilter(c,e,tp)
	return (c:IsSetCard(0x3440) or c:IsSetCard(0x441)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700052.pfilter(c)
	return c:IsSetCard(0x3440) and c:IsType(TYPE_PENDULUM) and  not c:IsForbidden()
end
function c33700052.activate(e,tp,eg,ep,ev,re,r,rp)
	   local  opt=Duel.SelectOption(1-tp,aux.Stringid(33700052,0),aux.Stringid(33700052,1))
	if opt==0 then
	if Duel.IsExistingMatchingCard(c33700052.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) then
	   local g=Duel.SelectMatchingCard(tp,c33700052.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	   if Duel.GetMZoneCount(1-tp)>0 and g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)>0 then
		 if g:GetFirst():IsSetCard(0x441) and Duel.IsExistingMatchingCard(c33700052.pfilter,tp,LOCATION_DECK,0,1,nil) 
		   and (Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7)) then 
		 local pg=Duel.SelectMatchingCard(tp,c33700052.pfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=pg:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	 elseif g:GetFirst():IsSetCard(0x3440) and Duel.IsExistingMatchingCard(c33700052.spfilter,tp,LOCATION_DECK, 0,1,nil,e,tp) 
	 and Duel.GetMZoneCount(tp)>0 then 
	   local sg=Duel.SelectMatchingCard(tp,c33700052.spfilter,tp,LOCATION_DECK,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		sg:GetFirst():AddCounter(0x1021,2)
end
end
end
	 else
	if Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetLabel(),nil) then
	  local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,e:GetLabel(),e:GetLabel(),nil)
	Duel.Destroy(dg,REASON_EFFECT)
end
	end
end
