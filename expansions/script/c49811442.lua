--第13人的埋葬者马甲
function c49811442.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_HAND)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,49811442)
	e3:SetCondition(c49811442.spcon)
	e3:SetCost(c49811442.spcost)
	e3:SetTarget(c49811442.sptg)
	e3:SetOperation(c49811442.spop)
	c:RegisterEffect(e3)
end
function c49811442.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49811442.spconfilter,1,nil,1-tp) and not Duel.IsChainSolving() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=13
end
function c49811442.spconfilter(c,sp)
	return c:IsSummonPlayer(sp) and c:IsSummonLocation(LOCATION_EXTRA)
end
function c49811442.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c49811442.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c49811442.spfilter(c,e,tp)
	return c:IsCode(32864) and c:IsType(TYPE_NORMAL)
end
function c49811442.sgfilter(c)
	return c:IsAbleToGrave() and c:IsType(TYPE_MONSTER)
end
function c49811442.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=13 then
		Duel.ConfirmDecktop(tp,13)
		local cg=Duel.GetDecktopGroup(tp,13)
		if cg:IsExists(c49811442.spfilter,1,nil) then
			local gg=cg:Filter(c49811442.sgfilter,nil)
			if #gg>0 then
				Duel.SendtoGrave(gg,REASON_EFFECT)
			end
		else
			local tg=Group.FilterSelect(cg,tp,c49811442.sgfilter,1,1,nil)
			if #tg>0 then
				Duel.SendtoGrave(tg,REASON_EFFECT)
			end
		end
	end
end
