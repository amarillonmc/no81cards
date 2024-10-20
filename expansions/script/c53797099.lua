local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	aux.EnableChangeCode(c,3055018,LOCATION_SZONE+LOCATION_GRAVE)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.pcon)
	e2:SetTarget(s.ptg)
	e2:SetOperation(s.pop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(s.spr)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCountLimit(1,id+500)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e4:SetCondition(s.spcon1)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(s.spcon2)
	c:RegisterEffect(e5)
end
function s.spfilter(c)
	return c:IsRace(RACE_PYRO) and c:IsFaceup()
end
function s.pcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.spfilter,1,nil)
end
function s.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,e:GetHandler():GetOwner(),LOCATION_DECK)
end
function s.setfilter(c)
	return c:IsCode(3055018) and not c:IsForbidden()
end
function s.thfilter(c)
	return c:IsSetCard(0x1ad) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.pop(e,tp,eg,ep,ev,re,r,rp)
	local ownp=e:GetHandler():GetOwner()
	Duel.Hint(HINT_SELECTMSG,ownp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(ownp,aux.NecroValleyFilter(s.setfilter),ownp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil):GetFirst()
	local p=ownp
	if Duel.SelectOption(ownp,aux.Stringid(id,1),aux.Stringid(id,2))==1 then
		p=1-p
	end
	if tc then
		local fc=Duel.GetFieldCard(p,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		if Duel.MoveToField(tc,ownp,p,LOCATION_FZONE,POS_FACEUP,true) and tc:IsLocation(LOCATION_FZONE) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
		end
	end
end
function s.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bp,ep=0,0
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_BATTLE_START then
		bp=Duel.GetTurnCount()
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START+RESET_OPPO_TURN,0,2)
	else c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE_START+RESET_OPPO_TURN,0,1) end
	if Duel.GetTurnPlayer()~=tp and Duel.GetCurrentPhase()==PHASE_END then
		ep=Duel.GetTurnCount()
		c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)
	else c:RegisterFlagEffect(id+500,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1) end
	e:SetLabel(bp,ep)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bp,ep=e:GetLabelObject():GetLabel()
	return bp~=Duel.GetTurnCount() and tp~=Duel.GetTurnPlayer() and c:GetFlagEffect(id)>0
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bp,ep=e:GetLabelObject():GetLabel()
	return ep~=Duel.GetTurnCount() and tp~=Duel.GetTurnPlayer() and c:GetFlagEffect(id+500)>0
end
function s.filter(c,e,tp,id)
	return c:IsSetCard(0x1ad) and c:IsReason(REASON_DESTROY) and c:GetTurnID()==id and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil,e,tp,Duel.GetTurnCount())
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local g=nil
	if tg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		g=tg:Select(tp,ft,ft,nil)
	else g=tg end
	if g:GetCount()>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
