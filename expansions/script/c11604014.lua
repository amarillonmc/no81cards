--宝可·重复球
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.copy(c,e,tp,ct)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-500*ct)
	c:RegisterEffect(e1)
	if c:GetAttack()==0 then
		Duel.SendtoHand(c,tp,REASON_EFFECT,tp)
		if c:IsLocation(LOCATION_EXTRA+LOCATION_HAND) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and (c:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
		end	
	end
end
function s.filter(c,tp)
	return c:GetOwner()==1-tp	
end
function s.filter1(c,code)
	return c:IsOriginalCodeRule(code)	
end
function s.filter2(c,tp)
	local code=c:GetOriginalCode()
	return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_MZONE,0,1,nil,code) 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_DECK)		
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if g:GetCount()>0 then
		Duel.ConfirmCards(tp,g)
		if g:IsExists(s.filter2,1,nil,tp) then			
			Duel.DisableShuffleCheck()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sg=g:FilterSelect(tp,s.filter2,1,1,nil,tp)
			local tc=sg:GetFirst()
			if tc:IsLocation(LOCATION_EXTRA)  then
				Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
				if tc:IsFaceup() then
					Duel.SendtoExtraP(tc,tp,REASON_EFFECT,tp)
				else
					Duel.SendtoDeck(tc,tp,REASON_EFFECT,tp)
				end								
			else
				Duel.SendtoHand(sg,tp,REASON_EFFECT,tp)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleDeck(1-tp)
			end
			--g:Sub(sg)			
		end		
	end			
end