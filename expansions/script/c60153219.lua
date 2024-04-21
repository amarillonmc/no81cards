--器灵阵·灵魂守护
function c60153219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60153219,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,60153219)
	e1:SetCondition(c60153219.condition)
	e1:SetTarget(c60153219.target)
	e1:SetOperation(c60153219.operation)
	c:RegisterEffect(e1)
	
	--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60153219,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,6013219)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c60153219.e2tg)
	e2:SetOperation(c60153219.e2op)
	c:RegisterEffect(e2)
end

function c60153219.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x3b2a)
end
function c60153219.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Group.FromCards(a,d),2,0,0)
end
function c60153219.operation(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	local g=Group.FromCards(a,d):Filter(Card.IsRelateToBattle,nil)
	if #g==2 and Duel.SendtoGrave(g,REASON_RULE)~=0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(1-tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end


--------------------------------------------------------------------------------------

function c60153219.e2tgf(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c60153219.e2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c60153219.e2tgf,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c60153219.e2tgf,tp,0,LOCATION_DECK,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and g:GetCount()>0 and g2:GetCount()>0 end
end
function c60153219.e2op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60153219.e2tgf,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(c60153219.e2tgf,tp,0,LOCATION_DECK,nil)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0
		and g:GetCount()>0 and g2:GetCount()>0 then 
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SSet(tp,sg)~=0 then
			local tc=sg:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			tc:RegisterEffect(e2,true)
		end
		
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local sg2=g2:Select(1-tp,1,1,nil)
		if Duel.SSet(1-tp,sg2)~=0 then
			local tc2=sg2:GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_TRIGGER)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc2:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e2:SetValue(LOCATION_DECKBOT)
			tc2:RegisterEffect(e2,true)
		end
	end
end