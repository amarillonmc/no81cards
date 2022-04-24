--逆转辩护士 信乐盾之
function c33200509.initial_effect(c)
	aux.AddCodeList(c,33200500)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200509+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c33200509.spcon)
	e1:SetOperation(c33200509.spop)
	c:RegisterEffect(e1)
	--TZ
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(c33200509.tztg)
	e3:SetOperation(c33200509.tzop)
	c:RegisterEffect(e3)
end

--e1
function c33200509.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
end
function c33200509.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
end

--e3
function c33200509.exfilter(c)
   return not c:IsPublic()
end
function c33200509.thfilter(c,opt)
   return ((opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL)) or (opt==2 and c:IsType(TYPE_TRAP))) and c:IsAbleToHand() and aux.IsCodeListed(c,33200500)
end
function c33200509.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tm=Duel.GetFlagEffect(tp,33200503)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())<tm+1 and Duel.IsExistingMatchingCard(c33200509.exfilter,tp,0,LOCATION_HAND,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
	e:GetHandler():RegisterFlagEffect(33200599,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200509.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=4 then return end
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		Duel.ConfirmDecktop(tp,5)
		local sg=g:Filter(c33200509.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		local opt=3
		if sgc:IsType(TYPE_MONSTER) then opt=0 end
		if sgc:IsType(TYPE_SPELL) then opt=1 end
		if sgc:IsType(TYPE_TRAP) then opt=2 end
		Duel.ShuffleHand(1-tp)
		local dg=Duel.GetDecktopGroup(tp,5)
		local ct=dg:GetCount()
		if ct>0 and dg:FilterCount(c33200509.thfilter,nil,opt)>0 and Duel.SelectYesNo(tp,aux.Stringid(33200509,2)) then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sdg=dg:FilterSelect(tp,c33200509.thfilter,1,1,nil,opt)
			if Duel.SendtoHand(sdg,nil,REASON_EFFECT) then  
				Duel.ConfirmCards(1-tp,sdg) 
				Duel.ShuffleHand(tp)
				Duel.ShuffleDeck(tp)
				Duel.BreakEffect()
				Duel.Recover(tp,800,REASON_EFFECT)
			end 
		else
			Duel.ShuffleDeck(tp)
		end
	else
		Duel.ConfirmDecktop(tp,5)
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200509.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		local opt=3
		if sgc:IsType(TYPE_MONSTER) then opt=0 end
		if sgc:IsType(TYPE_SPELL) then opt=1 end
		if sgc:IsType(TYPE_TRAP) then opt=2 end
		Duel.ShuffleHand(1-tp)
		local dg=Duel.GetDecktopGroup(tp,5)
		local ct=dg:GetCount()
		if ct>0 and dg:FilterCount(c33200509.thfilter,nil,opt)>0 and Duel.SelectYesNo(tp,aux.Stringid(33200509,2)) then
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sdg=dg:FilterSelect(tp,c33200509.thfilter,1,1,nil,opt)
			if Duel.SendtoHand(sdg,nil,REASON_EFFECT) then
				Duel.ConfirmCards(1-tp,sdg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleDeck(tp)
				Duel.BreakEffect()
				Duel.Recover(tp,800,REASON_EFFECT)
			end 
		else
			Duel.ShuffleDeck(tp)
		end
	end
end