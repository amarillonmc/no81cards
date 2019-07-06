--阻抗之心 漆黑简恩
function c33700334.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5449),2,2)
	c:EnableReviveLimit()   
	--battle indestructable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c33700334.tgtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--avoid
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c33700334.tgtg2)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetCondition(c33700334.descon)
	e3:SetOperation(c33700334.desop)
	c:RegisterEffect(e3)   
end
function c33700334.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c33700334.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local b1=(c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil):GetCount()>0)
	local b2=Duel.IsExistingMatchingCard(c33700334.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
	if not b1 and not b2 then return end
	Duel.Hint(HINT_CARD,0,33700334)
	local p=Duel.IsPlayerAffectedByEffect(tp,33700341) or 1-tp
	if b1 and (not b2 or not Duel.SelectYesNo(p,aux.Stringid(c33700334,1))) then
	   local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsAbleToGrave,nil)
	   Duel.SendtoGrave(cg,REASON_EFFECT)
	else 
	   local dg=Duel.GetMatchingGroup(c33700334.cfilter,tp,0,LOCATION_ONFIELD,nil)
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c33700334.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep==1-tp and c:GetBattleTarget()==nil and c:IsRelateToBattle() and c:GetColumnGroup():Filter(Card.IsControler,nil,tp):GetCount()==0
end
function c33700334.tgtg2(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c33700334.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c) or e:GetHandler()==c
end

