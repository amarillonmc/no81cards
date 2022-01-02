--逆转辩护士 神乃木庄龙
function c33200516.initial_effect(c)
	aux.AddCodeList(c,33200500)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200516)
	e1:SetCondition(c33200516.spcon)
	e1:SetTarget(c33200516.sptg)
	e1:SetOperation(c33200516.spop)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33200517)
	e2:SetOperation(c33200516.regop)
	c:RegisterEffect(e2)
	--TZ
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetTarget(c33200516.tztg)
	e3:SetOperation(c33200516.tzop)
	c:RegisterEffect(e3)
end

--e1
function c33200516.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and re:GetHandler():GetFlagEffect(33200500)>0 and re:IsActiveType(TYPE_MONSTER) and rp==tp
end
function c33200516.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c33200516.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
end

--e2
function c33200516.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetPreviousLocation(),LOCATION_ONFIELD)~=0 and c:IsReason(REASON_DESTROY) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(33200516,1))
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetTarget(c33200516.smtg)
		e1:SetOperation(c33200516.smop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c33200516.spfilter(c,e,tp)
	return c:IsCode(33200512) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200516.smtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200516.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c33200516.smop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33200516.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end

--e3
function c33200516.exfilter(c)
   return not c:IsPublic()
end
function c33200516.coffilter(c)
   return c:GetFlagEffect(33200507)>0 and not c:IsDisabled()
end
function c33200516.rmfilter(c,opt)
   return (opt==0 and c:IsType(TYPE_MONSTER)) or (opt==1 and c:IsType(TYPE_SPELL)) or (opt==2 and c:IsType(TYPE_TRAP)) and c:IsAbleToRemove() and c:IsFaceup()
end
function c33200516.tztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tm=Duel.GetFlagEffect(tp,33200503)
	if chk==0 then return Duel.GetFlagEffect(tp,e:GetHandler():GetOriginalCode())<tm+1 and Duel.IsExistingMatchingCard(c33200516.exfilter,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	e:SetLabel(Duel.AnnounceType(tp))
	Duel.RegisterFlagEffect(tp,e:GetHandler():GetOriginalCode(),RESET_PHASE+PHASE_END,0,1)
	e:GetHandler():RegisterFlagEffect(33200500,RESET_EVENT+RESET_CHAIN,0,1)
end
function c33200516.tzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	if not Duel.IsPlayerAffectedByEffect(tp,33200505) then
		local sg=g:Filter(c33200516.exfilter,nil):RandomSelect(1-tp,1)
		local sgc=sg:GetFirst()
		Duel.ConfirmCards(tp,sgc)
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local op=0
			if c:IsRelateToEffect(e) then 
				op=Duel.SelectOption(1-tp,aux.Stringid(33200516,2),aux.Stringid(33200516,3))
			else
				op=0
			end 
			if op==0 then 
				Duel.SendtoGrave(sgc,REASON_EFFECT)
			else
				local dtm=Duel.GetFlagEffect(tp,33200506)
				local co=Duel.GetMatchingGroup(c33200516.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
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
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	else
		Duel.ConfirmCards(tp,g)
		local sg=Duel.SelectMatchingCard(tp,c33200516.exfilter,tp,0,LOCATION_HAND,1,1,nil)
		local sgc=sg:GetFirst()
		Duel.ShuffleHand(1-tp)
		local opt=e:GetLabel()
		if (opt==0 and sgc:IsType(TYPE_MONSTER)) or (opt==1 and sgc:IsType(TYPE_SPELL)) or (opt==2 and sgc:IsType(TYPE_TRAP)) then
			local op=0
			if c:IsRelateToEffect(e) then 
				op=Duel.SelectOption(1-tp,aux.Stringid(33200516,2),aux.Stringid(33200516,3))
			else
				op=0
			end 
			if op==0 then 
				Duel.SendtoGrave(sgc,REASON_EFFECT)
			else
				local dtm=Duel.GetFlagEffect(tp,33200506)
				local co=Duel.GetMatchingGroup(c33200516.coffilter,tp,LOCATION_ONFIELD,0,1,nil)
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
				Duel.Destroy(c,REASON_EFFECT)
			end
		end
	end
end