--阻抗之腿 绿斯莱
function c33700327.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700327.descon)
	e2:SetOperation(c33700327.desop)
	c:RegisterEffect(e2)	
end
function c33700327.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5449)
end
function c33700327.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0)
	local b2=Duel.IsExistingMatchingCard(c33700327.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700327)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700327,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	   Duel.Destroy(cg,REASON_EFFECT)
	else 
	   local ct=Duel.GetMatchingGroupCount(c33700327.cfilter,tp,LOCATION_ONFIELD,0,nil)
	   if Duel.Damage(1-tp,ct*400,REASON_EFFECT)~=0 then
		  Duel.Recover(tp,ct*400,REASON_EFFECT)
	   end
	end
end
function c33700327.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
