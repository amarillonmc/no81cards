local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(aux.bdcon)
	e1:SetTarget(s.srtg)
	e1:SetOperation(s.srop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetOperation(s.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.con)
	e3:SetOperation(s.op)
	c:RegisterEffect(e3)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(function(c)return c:IsPreviousControler(c:GetControler()) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)end,1,nil) or bit.band(r,REASON_EFFECT)==0 then return end
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.filter(c)
	return c:IsRace(RACE_FIEND) and c:IsLevelAbove(6) and c:IsAbleToHand()
end
function s.srop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)==0 then return end
	local g=Duel.GetDecktopGroup(1-tp,1)
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 or not tc:IsLocation(LOCATION_HAND) then return end
	Duel.ConfirmCards(1-tp,tc)
	if (tc:IsSummonable(true,nil,1) or tc:IsMSetable(true,nil,1)) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_RELEASE) then c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0) end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local tc=g:GetFirst()
	if #g==1 and tc:IsFaceup() and tc:IsCode(35984222) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetTargetRange(1,1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(function(e)return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),id)==0 end)
		Duel.RegisterEffect(e1,tp)
	elseif c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,c)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_STANDBY,RESET_PHASE+PHASE_STANDBY,1) end
	end
end
