--漆黑的骑士
function c75030023.initial_effect(c) 
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON) 
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_BATTLE_DESTROYING)  
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetRange(LOCATION_DECK) 
	e1:SetCondition(c75030023.spcon) 
	e1:SetCost(c75030023.spcost)
	e1:SetTarget(c75030023.sptg) 
	e1:SetOperation(c75030023.spop) 
	c:RegisterEffect(e1) 
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2) 
	--
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_BE_BATTLE_TARGET) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c75030023.atkcon)
	e3:SetTarget(c75030023.xxtg1)
	e3:SetOperation(c75030023.xxop1)
	c:RegisterEffect(e3)
	local e3=Effect.CreateEffect(c) 
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING) 
	e3:SetRange(LOCATION_MZONE) 
	e3:SetCondition(c75030023.tgcon)
	e3:SetTarget(c75030023.xxtg2)
	e3:SetOperation(c75030023.xxop2)
	c:RegisterEffect(e3) 
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetDescription(aux.Stringid(75030023,1))
	e4:SetType(EFFECT_TYPE_QUICK_O) 
	e4:SetCode(EVENT_FREE_CHAIN) 
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e4:SetRange(LOCATION_MZONE) 
	e4:SetCountLimit(1)
	e4:SetTarget(c75030023.idtg) 
	e4:SetOperation(c75030023.idop) 
	c:RegisterEffect(e4) 
end 
function c75030023.spcon(e,tp,eg,ep,ev,re,r,rp) 
	return eg:GetFirst():IsCode(75030004) 
end 
function c75030023.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return not e:GetHandler():IsPublic() end 
	Duel.ConfirmCards(1-tp,e:GetHandler()) 
	Duel.ShuffleDeck(tp) 
end 
function c75030023.sptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_ATTACK) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0) 
end 
function c75030023.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,1-tp,true,false,POS_FACEUP) 
	end   
end 
function c75030023.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttackTarget()
	return at:IsFaceup() and at:IsCode(75030024)
end
function c75030023.cfilter(c,tp)
	return c:IsFaceup() and c:IsCode(75030024) and c:IsLocation(LOCATION_MZONE) 
end
function c75030023.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c75030023.cfilter,1,nil,tp)
end 
function c75030023.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetControler()~=e:GetHandler():GetOwner() and e:GetHandler():IsControlerCanBeChanged() and e:GetHandler():GetFlagEffect(75030023)==0 end  
	e:GetHandler():RegisterFlagEffect(75030023,RESET_EVENT+RESETS_STANDARD,0,1)   
end
function c75030023.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():GetControler()~=e:GetHandler():GetOwner() and e:GetHandler():IsControlerCanBeChanged() and e:GetHandler():GetFlagEffect(75030023)==0 end  
	e:GetHandler():RegisterFlagEffect(75030023,RESET_EVENT+RESETS_STANDARD,0,1) 
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c75030023.xxop1(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:GetControler()~=c:GetOwner() and Duel.GetControl(c,c:GetOwner()) then 
		Duel.NegateAttack()
	end 
end
function c75030023.xxop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:GetControler()~=c:GetOwner() and Duel.GetControl(c,c:GetOwner()) then 
		Duel.NegateActivation(ev)
	end  
end 
function c75030023.idtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end 
end 
function c75030023.idop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil) 
	if g:GetCount()>0 then 
		local tc=g:GetFirst() 
		while tc do  
		--indes
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(75030023,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE) 
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(1) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE) 
		tc:RegisterEffect(e2)
		tc=g:GetNext() 
		end 
	end 
end 





