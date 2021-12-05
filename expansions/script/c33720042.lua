--(  ・ω・)/ - Hi There! -
--Scripted by:XGlitchy30
local id=33720042
local s=_G["c"..tostring(id)]
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_DECK,0,1,nil,TYPE_MONSTER) end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_DECK,0,1,1,nil,TYPE_MONSTER)
	local tg=g:GetFirst()
	if tg==nil then return end
	Duel.DisableShuffleCheck()
	Duel.ConfirmCards(1-tp,g)
	Duel.MoveSequence(tg,1)
	if not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	local rct=(Duel.GetCurrentPhase()==PHASE_STANDBY) and 4 or 3
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY,rct)
	e1:SetOperation(s.thop)
	e1:SetLabel(0)
	Duel.RegisterEffect(e1,tp)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	e:GetOwner():SetTurnCounter(ct+1)
	if ct==2 then
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CODE)
		local ac=Duel.AnnounceCard(1-tp)
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_DECK,0,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.ConfirmCards(1-tp,g)
			if not tc:IsType(TYPE_MONSTER) then return end
			if tc:IsCode(ac) and tc:IsAbleToHand() then
				Duel.SendtoHand(tc,1-tp,REASON_EFFECT)
				if tc:IsLocation(LOCATION_HAND) and tc:IsControler(1-tp) then
					local e1=Effect.CreateEffect(e:GetOwner())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_PUBLIC)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			elseif not tc:IsCode(ac) and (s.spcheck(tc,e,tp,tp) or s.spcheck(tc,e,tp,1-tp)) then
				local b1=s.spcheck(tc,e,tp,tp)
				local b2=s.spcheck(tc,e,tp,1-tp)
				local op=0
				if b1 and b2 then
					op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
				elseif b1 then
					op=Duel.SelectOption(tp,aux.Stringid(id,1))
				else
					op=Duel.SelectOption(tp,aux.Stringid(id,2))+1
				end
				local fp=(op==0) and tp or 1-tp
				Duel.SpecialSummon(tc,0,tp,fp,false,false,POS_FACEUP)
			end
		end	
	else
		e:SetLabel(e:GetLabel()+1)
	end
end
--
function s.filter(c)
	return c:GetSequence()==0
end
function s.spcheck(c,e,p,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,p,false,false,POS_FACEUP,tp)
end
