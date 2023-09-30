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
	e1:SetOperation(cm.adjustop)
	Duel.RegisterEffect(e1,tp)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local ph,ph2=Duel.GetCurrentPhase(),e:GetLabel()
	if ph~=ph2 and (ph<=PHASE_MAIN1 or ph>=PHASE_MAIN2 or ph2<=PHASE_MAIN1 or ph2>=PHASE_MAIN2) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 and Duel.GetMZoneCount(tp)>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
			local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,0,nil)
			if #rg>1 then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local tg=rg:Select(tp,2,2,nil)
				Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
			end
		end
		e:Reset()
	end
end
function cm.setfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x9977) and ((c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or c:IsSSetable())
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
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_REMOVED,0,1,c,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (sa or sb) end
	if c:IsLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(tp,m-1,RESET_PHASE+PHASE_END,0,1)
	elseif c:IsLocation(LOCATION_REMOVED) then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_REMOVED,0,1,1,aux.ExceptThisCard(e),e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and (not tc:IsSSetable() or Duel.SelectYesNo(tp,Stringid(m,3))) then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		else
			Duel.SSet(tp,tc)
		end
		if #Duel.GetOperatedGroup()>0 and c:IsRelateToEffect(e) then
			--Duel.BreakEffect()
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end