--阻抗之肤 橙悉尼
function c33700329.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700329.descon)
	e2:SetOperation(c33700329.desop)
	c:RegisterEffect(e2)	 
end
function c33700329.tffilter(c,tp)
	return c:IsSetCard(0x5449) and c:IsType(TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c33700329.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0)
	local b2=true
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700329)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700329,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	   Duel.Destroy(cg,REASON_EFFECT)
	else 
	   local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c33700329.tffilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,tp)
	   if g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(33700329,0)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		  local tc=g:Select(tp,1,1,nil):GetFirst()
		  Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	   end
	end
end
function c33700329.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
