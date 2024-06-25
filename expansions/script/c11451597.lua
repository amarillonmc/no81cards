--结界守护者 利斯佩
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.adcon)
	e1:SetCost(cm.adcost)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--barrier
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.sccon)
	e2:SetCost(cm.sccost)
	e2:SetTarget(cm.sctg)
	e2:SetOperation(cm.scop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsControler(tp)
end
function cm.filter2(c,tp)
	return c:IsControler(tp) and c:IsAbleToHand()
end
function cm.pfilter(c)
	return c:IsPublic() and not c:IsCode(m)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter,1,nil,1-tp)
end
function cm.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(m,4))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(cm.filter2,nil,1-tp)
	local pg=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_HAND,0,nil)
	if chk==0 then return #g>0 and #pg>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.filter2,nil,1-tp):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND)
		local pg=Duel.GetMatchingGroup(cm.pfilter,tp,LOCATION_HAND,0,nil)
		if #dg>0 and #pg>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local sc=pg:Select(tp,1,1,nil):GetFirst()
			sc:RegisterFlagEffect(11451544,RESET_EVENT+RESETS_STANDARD,0,1)
			sc:ResetFlagEffect(9822220)
			local eset={sc:IsHasEffect(EFFECT_PUBLIC)}
			if #eset>0 then
				for _,ae in pairs(eset) do
					if ae:IsHasType(EFFECT_TYPE_SINGLE) then
						ae:Reset()
					else
						local tg=ae:GetTarget() or aux.TRUE
						ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(11451544)==0 end)
					end
				end
			end
		end
	end
end
function cm.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.cfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function cm.mfilter(c)
	return bit.band(c:GetType(),0x81)==0x81 and c:IsAbleToHand()
end
function cm.sfilter(c)
	return bit.band(c:GetType(),0x82)==0x82 and c:IsAbleToHand()
end
function cm.sabcheck(g)
	return g:GetFirst():GetAttribute()&g:GetNext():GetAttribute()>0
end
function cm.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,0,LOCATION_MZONE,nil,e)
	if chkc then return false end
	local b1=Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return (b1 and g:CheckSubGroup(cm.sabcheck,2,2)) or (b2 and g:CheckSubGroup(aux.dabcheck,2,2)) end
	local sg=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if b1 and b2 then
		sg=g:SelectSubGroup(tp,aux.TRUE,false,2,2)
	elseif b1 then
		sg=g:SelectSubGroup(tp,cm.sabcheck,false,2,2)
	elseif b2 then
		sg=g:SelectSubGroup(tp,aux.dabcheck,false,2,2)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.tfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function cm.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(cm.tfilter,nil,e)
	if #g<2 then return end
	local ac=g:GetFirst()
	local bc=g:GetNext()
	local b1=Duel.IsExistingMatchingCard(cm.mfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil)
	if ac:IsAttribute(bc:GetAttribute()) and (ac:GetAttribute()==bc:GetAttribute() or ((b1 or not b2) and Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.mfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.sfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end