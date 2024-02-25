--大原满美食汇 - 面包售卖
local s,id,o=GetID()
function s.initial_effect(c)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.target)
	e2:SetOperation(s.prop)
	c:RegisterEffect(e2)
end

function s.thfilter(c,tp)
	return c:IsSetCard(0x607) and c:GetType()==0x20004
		and c:GetActivateEffect():IsActivatable(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.prop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and tc:GetActivateEffect():IsActivatable(tp) then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		
		Duel.BreakEffect()
		if Duel.GetLP(tp)-Duel.GetLP(1-tp)>=2000 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local g2 = Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,1,1,nil,tp)
			local tc2 = g2:GetFirst()
			if tc2 and tc2:GetActivateEffect():IsActivatable(tp) then
				Duel.MoveToField(tc2,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
				local te=tc2:GetActivateEffect()
				local tep=tc2:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		end

	end
end