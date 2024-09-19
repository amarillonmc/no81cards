--洛天依「月面」
function c21185828.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21185828,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_TOGRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,21185828)	
	e2:SetCondition(c21185828.con)
	e2:SetTarget(c21185828.tg)
	e2:SetOperation(c21185828.op)
	c:RegisterEffect(e2)	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,21185829)
	e3:SetCondition(c21185828.con3)
	e3:SetOperation(c21185828.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_HAND+LOCATION_EXTRA)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(c21185828.con4)
	e4:SetOperation(c21185828.op4)
	c:RegisterEffect(e4)
end
function c21185828.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c21185828.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g,#g,0,0)
end
function c21185828.q(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c21185828.w(c)
	return c:IsPosition(POS_FACEUP_DEFENSE) and c:IsAbleToGrave()
end
function c21185828.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,4,4,nil)
	if #g<=0 then return end
	local x=0
	for tc in aux.Next(g) do
		if not tc:IsImmuneToEffect(e) and not tc:IsHasEffect(108) then x=x+1 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(HALF_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local fg=Duel.GetMatchingGroup(c21185828.q,tp,4,4,nil)	
	if x>0 and #fg>0 and Duel.SelectYesNo(tp,aux.Stringid(21185828,0)) then
	Duel.BreakEffect()
		for cc in aux.Next(fg) do
		Duel.ChangePosition(cc,POS_FACEUP_ATTACK)
		end
	local sg=Duel.GetMatchingGroup(c21185828.w,tp,4,4,nil)
		if #sg>0 then
			for p in aux.TurnPlayers() do
			local sg=tg:Filter(Card.IsControler,nil,p)
			Duel.SendtoGrave(sg,REASON_RULE,p)
			end
		end
	end 
end
function c21185828.con3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21185828.e(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack())
end
function c21185828.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	c:SetEntityCode(21185825,true)
	c:ReplaceEffect(21185825,0,0)
	Duel.Hint(10,1,21185825)
	local g=Duel.GetMatchingGroup(c21185828.e,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if #g>0 then
			for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetBaseAttack())
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			end
		end
	end
end
function c21185828.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalCode()==21185828
end
function c21185828.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:SetEntityCode(21185825)
	Duel.ConfirmCards(tp,Group.FromCards(c))
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
	c:ReplaceEffect(21185825,0,0)
	Duel.Hint(HINT_CARD,1,21185825)
end