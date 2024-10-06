--悲歌的奥斯忒茜
function c9910898.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910898)
	e1:SetCondition(c9910898.spcon)
	e1:SetTarget(c9910898.sptg)
	e1:SetOperation(c9910898.spop)
	c:RegisterEffect(e1)
	--extra BP
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910899)
	e2:SetCondition(c9910898.ebcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(c9910898.ebop)
	c:RegisterEffect(e2)
end
function c9910898.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:Filter(Card.IsFaceup,nil)
	return sg and sg:GetClassCount(Card.GetRace)>=2
end
function c9910898.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9910898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c9910898.imcon)
	e1:SetOperation(c9910898.imop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9910898.imcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActivated() and Duel.GetFlagEffect(tp,9910898)==0 and Duel.GetFlagEffect(tp,9910899)==0
end
function c9910898.imop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,9910898,RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(c9910898.indtg)
	e1:SetValue(c9910898.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(re)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(c9910898.hintcon)
	e2:SetOperation(c9910898.hintop)
	e2:SetLabelObject(re)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_NEGATED)
	e3:SetCondition(c9910898.hintcon)
	e3:SetOperation(c9910898.resetop)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c9910898.indtg(e,c)
	return aux.IsCodeListed(c,9910871)
end
function c9910898.efilter(e,te)
	return te==e:GetLabelObject()
end
function c9910898.hintcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c9910898.hintop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,9910899)==0 then Duel.RegisterFlagEffect(tp,9910899,RESET_PHASE+PHASE_END,0,1) end
	if not (re and e:GetLabelObject() and re==e:GetLabelObject()) then return end
	Duel.Hint(HINT_CARD,0,9910898)
end
function c9910898.resetop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ResetFlagEffect(tp,9910898)
end
function c9910898.cfilter2(c)
	return c:IsSummonLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsRace(RACE_FISH)
end
function c9910898.ebcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9910898.cfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c9910898.ebop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BP_TWICE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	if Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c9910898.bpcon)
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c9910898.bpcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
