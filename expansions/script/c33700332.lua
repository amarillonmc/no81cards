--阻抗之腿 绿斯莱
function c33700332.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700332.descon)
	e2:SetOperation(c33700332.desop)
	c:RegisterEffect(e2)	
end
function c33700332.cfilter1(c,seq,tp)
	return not c:IsType(TYPE_PENDULUM) and c:GetSequence()~=seq and Duel.CheckLocation(tp,LOCATION_SZONE,seq) and c:GetSequence()<=4
end
function c33700332.cfilter3(c,seq,tp)
	return c:IsType(TYPE_MONSTER) and c:GetSequence()~=seq and Duel.CheckLocation(tp,LOCATION_MZONE,seq)
end
function c33700332.cfilter4(c,seq,tp)
	return c:IsType(TYPE_PENDULUM) and c:GetSequence()~=seq and Duel.CheckLocation(tp,LOCATION_SZONE,seq)
end
function c33700332.check(c,tp)
	local seq=c:GetSequence()
	local g1=Duel.GetMatchingGroup(c33700332.cfilter3,tp,0,LOCATION_MZONE,nil,4-seq,1-tp)
	local g3=Duel.GetMatchingGroup(c33700332.cfilter1,tp,0,LOCATION_SZONE,nil,4-seq,1-tp)
	g1:Merge(g3)
	local g2=Group.CreateGroup()
	if seq==0 or seq==4 then
	   g2=Duel.GetMatchingGroup(c33700332.cfilter4,tp,0,LOCATION_SZONE,nil,4-seq,1-tp)
	end
	g1:Merge(g2)
	return g1:GetCount()>0,g1
end
function c33700332.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil):GetCount()>0)
	local b2,g=c33700332.check(c,tp)
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700332)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700332,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil)
	   Duel.SendtoGrave(cg,REASON_EFFECT)
	else 
	   for i=1,2 do
		   local b3,sg=c33700332.check(c,tp)
		   if not b3 or (i==2 and not Duel.SelectYesNo(tp,aux.Stringid(33700332,3))) then break end
		   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
		   local tc=sg:Select(tp,1,1,nil):GetFirst()
		   Duel.MoveSequence(tc,4-seq)
	   end
	   if c:IsChainAttackable(0,true) and Duel.SelectYesNo(tp,aux.Stringid(33700332,2)) then
		  Duel.ChainAttack()
	   end
	end
end
function c33700332.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
