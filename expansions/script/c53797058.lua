local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddLinkProcedure(c,nil,2,2,s.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.setcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function s.filter(c,e,tp,zone)
	return c:IsLevel(4) and c:IsRace(RACE_FAIRY) and c:IsDefense(500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function s.setfilter(c,e,tp)
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	return (ft>0 and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)) or c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=g:Filter(aux.NOT(Card.IsPublic),nil)
		local g1=Group.__sub(g,g2):Filter(s.setfilter,nil,e,tp)
		local zone=e:GetHandler():GetLinkedZone(tp)
		return zone~=0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,zone) and (#g1>0 or (#g2>0 and ((Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(1-tp)) or Duel.IsPlayerCanSSet(1-tp))))
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,zone):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_EXTRA_RELEASE_NONSUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetTargetRange(0,LOCATION_ONFIELD)
			e1:SetValue(s.relval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
			local sc=Duel.SelectMatchingCard(1-tp,s.setfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
			if sc then
				local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local op=aux.SelectFromOptions(1-tp,{(ft>0 and sc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)),aux.Stringid(id,1)},{sc:IsSSetable(),aux.Stringid(id,2)})
				if op==1 then
					Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
					Duel.ConfirmCards(tp,sc)
				elseif op==2 then Duel.SSet(1-tp,sc) end
			end
		end
	end
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function s.relval(e,re,r,rp)
	return re:IsActivated() and re:GetHandler()==e:GetHandler() and bit.band(r,REASON_COST)~=0
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
		local g2=g:Filter(aux.NOT(Card.IsPublic),nil)
		local g1=Group.__sub(g,g2):Filter(s.setfilter,nil,e,tp)
		return #g1>0 or (#g2>0 and ((Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummon(1-tp)) or Duel.IsPlayerCanSSet(1-tp)))
	end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
	local sc=Duel.SelectMatchingCard(1-tp,s.setfilter,1-tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if sc then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local op=aux.SelectFromOptions(1-tp,{(ft>0 and sc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE)),aux.Stringid(id,1)},{sc:IsSSetable(),aux.Stringid(id,2)})
		if op==1 then
			Duel.SpecialSummon(sc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
			Duel.ConfirmCards(tp,sc)
		elseif op==2 then Duel.SSet(1-tp,sc) end
	end
end
