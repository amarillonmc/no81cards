--阻抗之腿 绿斯莱
function c33700326.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c33700326.descon)
	e2:SetOperation(c33700326.desop)
	c:RegisterEffect(e2)	
end
function c33700326.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):GetCount()>0)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil)
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700326)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(33700326,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp)
	   Duel.Destroy(cg,REASON_EFFECT)
	else 
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	   local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,1,nil)
	   Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function c33700326.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
