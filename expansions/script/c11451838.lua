--星汐击龙“绀夜”
local cm,m=GetID()
function cm.initial_effect(c)
	--check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_REMOVE)
	e0:SetCondition(aux.ThisCardInGraveAlreadyCheckReg)
	c:RegisterEffect(e0)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.con2)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetLabelObject(e0)
	e2:SetRange(LOCATION_HAND+LOCATION_REMOVED)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c,e,tp)
	return c:IsSetCard(0x9977) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,11451760)>0
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m-1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m)==0
	if chk==0 then return sa or sb end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabel(Duel.GetCurrentPhase())
	e1:SetCondition(function() return not pnfl_adjusting end)
	e1:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e1,tp)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if pnfl_adjusting then return end
	pnfl_adjusting=true
	local ph,ph2=Duel.GetCurrentPhase(),e:GetLabel()
	if ph~=ph2 and (ph<=PHASE_MAIN1 or ph>=PHASE_MAIN2 or ph2<=PHASE_MAIN1 or ph2>=PHASE_MAIN2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
			if #rg>1 then
				--Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tg=rg:Select(tp,2,2,nil)
				Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			end
		end
		e:Reset()
	end
	pnfl_adjusting=false
end
function cm.setfilter(c,e,tp,fd)
	return c:IsFaceup() and c:IsSetCard(0x9977) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>fd and Duel.IsPlayerCanSpecialSummonCount(tp,2)) or c:IsSSetable())
end
function cm.spfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	return c:IsFaceup() and c:IsSetCard(0x9977)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject():GetLabelObject()
	return eg:IsExists(cm.spfilter,1,nil,se)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local sa=c:IsLocation(LOCATION_HAND) and Duel.GetFlagEffect(tp,m-1)==0
	local sb=c:IsLocation(LOCATION_REMOVED) and Duel.GetFlagEffect(tp,m)==0
	if chk==0 then
		local nsp=Duel.GetCurrentChain()==0
		local fd=nsp and 0 or 1
		local exc=not nsp and c
		return ((c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or Duel.GetCurrentChain()==0) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,exc,e,tp,fd) and (sa or sb)
	end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if Duel.GetCurrentChain()>1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local nsp=Duel.GetCurrentChain()<2
	local fd=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local exc=not nsp and aux.ExceptThisCard(e)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,exc,e,tp,fd)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local res=false
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>fd and (not tc:IsSSetable() or Duel.SelectYesNo(tp,Stringid(m,3))) then
			res=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)>0
			if res then Duel.ConfirmCards(1-tp,tc) end
		else
			res=Duel.SSet(tp,tc)>0
		end
		if res and Duel.GetCurrentChain()>1 and c:IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.AdjustAll()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
		--Duel.SpecialSummonComplete()
	end
end