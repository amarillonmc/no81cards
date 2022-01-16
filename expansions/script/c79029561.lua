--CiNo.92 伪骸龙皇·心地混沌极龙
function c79029561.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,5)
	c:EnableReviveLimit()  
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(97403510,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c79029561.rmcon)
	e4:SetTarget(c79029561.rmtg)
	e4:SetOperation(c79029561.rmop)
	c:RegisterEffect(e4) 
	--Remove
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c79029561.rctg)
	e5:SetOperation(c79029561.rcop)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12744567,1))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c79029561.spcon)
	e6:SetTarget(c79029561.sptg)
	e6:SetOperation(c79029561.spop)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BATTLE_CONFIRM)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(c79029561.disop)
	c:RegisterEffect(e7)
	if not c79029561.global_check then
		c79029561.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c79029561.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c79029561.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(79029561,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		tc=eg:GetNext()
	end
end
function c79029561.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c79029561.filter(c,turn)
	return (c:IsLocation(LOCATION_MZONE) or c:GetFlagEffect(79029561)~=0) and c:GetTurnID()==turn and c:IsAbleToRemove()
end
function c79029561.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029561.filter,tp,0,LOCATION_ONFIELD,1,nil,Duel.GetTurnCount()) end
	local g=Duel.GetMatchingGroup(c79029561.filter,tp,0,LOCATION_ONFIELD,nil,Duel.GetTurnCount())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c79029561.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029561.filter,tp,0,LOCATION_ONFIELD,nil,Duel.GetTurnCount())
	if g:GetCount()>0 then
		Duel.Hint(HINT_CARD,0,79029561)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c79029561.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ev)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ev)
end
function c79029561.rcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) and ep==tp then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c79029561.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function c79029561.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029561.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
	and Duel.SpecialSummon(c,0,tp,tp,true,true,POS_FACEUP)~=0 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c79029561.val)
	c:RegisterEffect(e1) 
	end
end
function c79029561.val(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,LOCATION_REMOVED)*1500
end
function c79029561.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	local tc=g:GetFirst()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e1:SetCode(EFFECT_DISABLE_EFFECT)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
end



