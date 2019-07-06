--阻抗之腿 绿斯莱
function c33700331.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700331.descon)
	e2:SetOperation(c33700331.desop)
	c:RegisterEffect(e2)	
end
function c33700331.cfilter(c)
	return c:IsType(TYPE_MONSTER) or c:GetSequence()<=4
end
function c33700331.check(c,tp)
	local g1=Duel.GetMatchingGroup(c33700331.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local zone=0
	for tc in aux.Next(g1) do
		zone=bit.bor(zone,tc:GetColumnZone(LOCATION_MZONE,tp))
	end
	return zone>0,zone
end
function c33700331.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil):GetCount()>0)
	local b2,zone=c33700331.check(c,tp)
	if not b1 and not b2 then return end
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	Duel.Hint(HINT_CARD,0,33700331)
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700331,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil)
	   Duel.SendtoGrave(cg,REASON_EFFECT)
	else 
	   local flag=bit.bxor(zone,0xff)
	   local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag)
	   local nseq=math.log(s,2)
	   Duel.MoveSequence(c,nseq)
	   if c:IsChainAttackable(0,true) and Duel.SelectYesNo(tp,aux.Stringid(33700331,2)) then
		  Duel.ChainAttack()
	   end
	end
end
function c33700331.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
