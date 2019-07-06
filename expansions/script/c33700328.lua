--阻抗之腿 绿斯莱
function c33700328.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700328.descon)
	e2:SetOperation(c33700328.desop)
	c:RegisterEffect(e2)	
end
function c33700328.spfilter(c,e,tp)
	return c:IsSetCard(0x5449) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33700328.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,33700328)
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0)
	local b2=true
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700328)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700328,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	   Duel.Destroy(cg,REASON_EFFECT)
	else 
	   local g=Duel.GetMatchingGroup(c33700328.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33700328,0)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
		  local e1=Effect.CreateEffect(c)
		  e1:SetType(EFFECT_TYPE_SINGLE)
		  e1:SetCode(EFFECT_CANNOT_ATTACK)
		  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		  tc:RegisterEffect(e1)
	   end
	end
end
function c33700328.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
