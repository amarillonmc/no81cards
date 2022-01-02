--御剑怜侍 逻辑象棋
function c33200507.initial_effect(c)
	aux.AddCodeList(c,33200501)
	aux.AddCodeList(c,33200500)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c33200507.tztg)
	e1:SetOperation(c33200507.tzop)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c33200507.thcon)
	e2:SetCountLimit(1,33200507)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetTarget(c33200507.thtg)
	e2:SetOperation(c33200507.thop)
	c:RegisterEffect(e2)
end

--e1
function c33200507.exfilter(c)
   return not c:IsPublic()
end
function c33200507.coffilter(c)
   return c:GetFlagEffect(33200507)>0 and not c:IsDisabled()
end
function c33200507.desfilter(c,sgc)
	return ((c:IsType(TYPE_MONSTER) and sgc:IsType(TYPE_MONSTER)) or (c:IsType(TYPE_SPELL) and sgc:IsType(TYPE_SPELL)) or (c:IsType(TYPE_TRAP) and sgc:IsType(TYPE_TRAP))) and not c:IsPublic()
end
function c33200507.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 and Duel.IsExistingMatchingCard(c33200507.exfilter,tp,0,LOCATION_HAND,1,nil) end
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200507.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		Duel.ConfirmDecktop(1-tp,1)
		local dg=Duel.GetDecktopGroup(1-tp,1)
		local dgc=dg:GetFirst()
		local sg=g:Filter(c33200507.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		Duel.ShuffleHand(1-tp)
		if (dgc:IsType(TYPE_MONSTER) and not sgc:IsType(TYPE_MONSTER)) or (dgc:IsType(TYPE_SPELL) and not sgc:IsType(TYPE_SPELL)) or (dgc:IsType(TYPE_TRAP) and not sgc:IsType(TYPE_TRAP)) then
			local dtm=Duel.GetFlagEffect(tp,33200506)
			local co=Duel.GetMatchingGroup(c33200506.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
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
		end
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) 
		  and Duel.IsExistingMatchingCard(c33200507.desfilter,tp,LOCATION_HAND,0,1,nil,sgc) 
		  and Duel.SelectYesNo(tp,aux.Stringid(33200507,0)) then   
			local tgg=Duel.SelectMatchingCard(tp,c33200507.desfilter,tp,LOCATION_HAND,0,1,1,nil,sgc)
			local tgc=tgg:GetFirst()
			if tgc then
				Duel.ConfirmCards(1-tp,tgc)
				Duel.ShuffleHand(tp)
				local desg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				local tc=desg:GetFirst()
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	else
		Duel.ConfirmDecktop(1-tp,1)
		local dg=Duel.GetDecktopGroup(1-tp,1)
		local dgc=dg:GetFirst()
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200507.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		Duel.ShuffleHand(1-tp)
		if (dgc:IsType(TYPE_MONSTER) and not sgc:IsType(TYPE_MONSTER)) or (dgc:IsType(TYPE_SPELL) and not sgc:IsType(TYPE_SPELL)) or (dgc:IsType(TYPE_TRAP) and not sgc:IsType(TYPE_TRAP)) then
			local dtm=Duel.GetFlagEffect(tp,33200506)
			local co=Duel.GetMatchingGroup(c33200506.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
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
		end
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(c33200507.desfilter,tp,LOCATION_HAND,0,1,nil,sgc) and Duel.SelectYesNo(tp,aux.Stringid(33200507,0)) then   
			local tgg=Duel.SelectMatchingCard(tp,c33200507.desfilter,tp,LOCATION_HAND,0,1,1,nil,sgc)
			local tgc=tgg:GetFirst()
			if tgc then
				Duel.ConfirmCards(1-tp,tgc)
				Duel.ShuffleHand(tp)
				local desg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				local tc=desg:GetFirst()
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
end

--e2
function c33200507.offilter(c)
	return c:IsCode(33200501) and c:IsFaceup()
end
function c33200507.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END
end
function c33200507.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200507.offilter,tp,LOCATION_MZONE,0,1,nil) 
		and e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c33200507.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.SSet(tp,c)
	end
end