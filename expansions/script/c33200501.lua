--逆转检事 御剑怜侍
function c33200501.initial_effect(c)
	aux.AddCodeList(c,33200500)
	aux.AddCodeList(c,33200501)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33200501,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200501)
	e1:SetCondition(c33200501.spcon)
	e1:SetTarget(c33200501.sptg)
	e1:SetOperation(c33200501.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33200501,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c33200501.thtg)
	e2:SetOperation(c33200501.thop)
	c:RegisterEffect(e2)
	--TZ
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(c33200501.tztg)
	e3:SetOperation(c33200501.tzop)
	c:RegisterEffect(e3)
end

--e1
function c33200501.spcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c33200501.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33200501.spcfilter,1,nil,tp)
end
function c33200501.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200501.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end

--e2
function c33200501.thfilter(c)
	return aux.IsCodeListed(c,33200501) and c:IsAbleToHand()
end
function c33200501.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200501.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c33200501.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c33200501.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

--e3
function c33200501.exfilter(c)
   return not c:IsPublic()
end
function c33200501.coffilter(c)
   return c:GetFlagEffect(33200507)>0 and not c:IsDisabled()
end
function c33200501.rmfilter(c,opt)
   return (opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL) and c:IsFaceup()) or (opt==2 and c:IsType(TYPE_TRAP) and c:IsFaceup()) and c:IsAbleToRemove() 
end
function c33200501.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tm=Duel.GetFlagEffect(tp,33200503)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())<tm+1 and Duel.IsExistingMatchingCard(c33200501.exfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
	e:GetHandler():RegisterFlagEffect(33200599,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200501.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		local sg=g:Filter(c33200501.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local dtm=Duel.GetFlagEffect(tp,33200506)
			local co=Duel.GetMatchingGroup(c33200501.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
			local cof=co:GetCount()
			if dtm>cof then dtm=cof end
			if Duel.Damage(1-tp,800,REASON_EFFECT) and dtm>=1 then
				Duel.Hint(HINT_CARD,tp,33200506)
				Duel.Draw(tp,dtm,REASON_EFFECT)
				for drc in aux.Next(co) do
					drc:RegisterFlagEffect(33200508,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					if drc:GetFlagEffect(33200508)>=2 then 
						drc:ResetFlagEffect(33200507)
					end
				end
			end
			if Duel.IsExistingMatchingCard(c33200501.rmfilter,tp,0,LOCATION_ONFIELD,1,nil,opt) and Duel.SelectYesNo(tp,aux.Stringid(33200501,2)) then 
				local rmg=Duel.SelectMatchingCard(tp,c33200501.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil,opt)
				local tc=rmg:GetFirst()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end 
		end
	else
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200501.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local dtm=Duel.GetFlagEffect(tp,33200506)
			local co=Duel.GetMatchingGroup(c33200501.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
			local cof=co:GetCount()
			if dtm>cof then dtm=cof end
			if Duel.Damage(1-tp,800,REASON_EFFECT) and dtm>=1 then
				Duel.Hint(HINT_CARD,tp,33200506)
				Duel.Draw(tp,dtm,REASON_EFFECT)
				for drc in aux.Next(co) do
					drc:RegisterFlagEffect(33200508,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
					if drc:GetFlagEffect(33200508)>=2 then 
						drc:ResetFlagEffect(33200507)
					end
				end
			end
			if Duel.IsExistingMatchingCard(c33200501.rmfilter,tp,0,LOCATION_ONFIELD,1,nil,opt) and Duel.SelectYesNo(tp,aux.Stringid(33200501,2)) then 
				local rmg=Duel.SelectMatchingCard(tp,c33200501.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil,opt)
				local tc=rmg:GetFirst()
				Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
			end 
		end
	end
end