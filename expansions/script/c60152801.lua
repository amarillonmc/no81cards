--素晴日的Nice爆炸！！
function c60152801.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c60152801.ffilter,2,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c60152801.e1splimit)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c60152801.e2op)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60152801,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60152801.e3con)
	e3:SetCost(c60152801.e3cost)
	e3:SetTarget(c60152801.e3tg)
	e3:SetOperation(c60152801.e3op)
	c:RegisterEffect(e3)
end
function c60152801.ffilter(c,fc,sub,mg,sg)
	return c:IsFaceup() and (not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()) and not sg:IsExists(Card.IsType,1,nil,TYPE_LINK) and not sg:IsExists(Card.IsType,1,nil,TYPE_XYZ)
			and sg:IsExists(Card.IsFusionAttribute,1,nil,ATTRIBUTE_FIRE) and sg:IsExists(Card.IsLevel,1,c,c:GetLevel())))
end
function c60152801.e1splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c60152801.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local sa=0
	local sd=0
	local tc=g:GetFirst()
	while tc do
		local a=tc:GetAttack()
		local d=tc:GetDefense()
		if a<0 then a=0 end
		sa=sa+a
		if d<0 then d=0 end
		sd=sd+d
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(sa)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(sd)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e2)
end
function c60152801.e3con(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD+LOCATION_HAND,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	return ct1<ct2 and Duel.GetTurnPlayer()==tp
end
function c60152801.e3cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(60152801)==0 end
	c:RegisterFlagEffect(60152801,RESET_CHAIN,0,1)
end
function c60152801.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c60152801.e3op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_HAND,aux.ExceptThisCard(e))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,1))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,2))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,3))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,4))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,5))
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,6))
	Duel.Hint(HINT_CARD,0,60152801)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60152801,7))
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
		local turnp=Duel.GetTurnPlayer()
		Duel.SkipPhase(turnp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(turnp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
