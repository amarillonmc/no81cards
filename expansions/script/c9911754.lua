--消弥火灵
function c9911754.initial_effect(c)
	--twist spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c9911754.spcon)
	e1:SetOperation(c9911754.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9911754,0))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_CUSTOM+9911754)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9911754)
	e2:SetCondition(c9911754.drcon)
	e2:SetCost(c9911754.drcost)
	e2:SetTarget(c9911754.drtg)
	e2:SetOperation(c9911754.drop)
	c:RegisterEffect(e2)
	--synchro effect
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,9911755)
	e3:SetCondition(c9911754.sccon)
	e3:SetCost(c9911754.sccost)
	e3:SetTarget(c9911754.sctg)
	e3:SetOperation(c9911754.scop)
	c:RegisterEffect(e3)
	if not c9911754.global_check then
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetCondition(c9911754.regcon)
		ge1:SetOperation(c9911754.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9911754.rtfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsPreviousLocation(LOCATION_REMOVED)
		and not c:IsReason(REASON_SPSUMMON)
end
function c9911754.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(c9911754.rtfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(c9911754.rtfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c9911754.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+9911754,re,r,rp,ep,e:GetLabel())
end
function c9911754.spfilter(c,e,tp)
	return c:IsSetCard(0xc958) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911754.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(c9911754.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
end
function c9911754.spop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
	local bg=Duel.GetMatchingGroup(c9911754.spfilter,tp,LOCATION_HAND,0,c,e,tp)
	if #bg==0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local bc=bg:Select(tp,1,1,nil):GetFirst()
	sg:AddCard(bc)
	sg:AddCard(c)
end
function c9911754.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function c9911754.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c9911754.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
function c9911754.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if Duel.Draw(p,3,REASON_EFFECT)==3 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end
function c9911754.sccon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c9911754.costfilter(c,mg,tp)
	local g=mg:Filter(aux.TRUE,c)
	return c:IsFaceup() and c:IsReleasable() and Duel.IsExistingMatchingCard(c9911754.scfilter,tp,LOCATION_EXTRA,0,1,nil,g,c:GetLevel(),c:GetLevel()*2,c:GetRank(),c:GetRank()*2,c:GetLink(),c:GetLink()*2)
end
function c9911754.scfilter(c,mg,lv1,lv2,lv3,lv4,lv5,lv6)
	return c:IsLevel(lv1,lv2,lv3,lv4,lv5,lv6) and c:IsSynchroSummonable(nil,mg)
end
function c9911754.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetSynchroMaterial(tp)
	if chk==0 then return Duel.IsExistingMatchingCard(c9911754.costfilter,tp,0,LOCATION_MZONE,1,nil,g,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=Duel.SelectMatchingCard(tp,c9911754.costfilter,tp,0,LOCATION_MZONE,1,1,nil,g,tp):GetFirst()
	e:SetLabel(tc:GetLevel(),tc:GetLevel()*2,tc:GetRank(),tc:GetRank()*2,tc:GetLink(),tc:GetLink()*2)
	Duel.Release(tc,REASON_COST)
end
function c9911754.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9911754.scop(e,tp,eg,ep,ev,re,r,rp)
	local lv1,lv2,lv3,lv4,lv5,lv6=e:GetLabel()
	local g=Duel.GetMatchingGroup(c9911754.scfilter,tp,LOCATION_EXTRA,0,nil,g,lv1,lv2,lv3,lv4,lv5,lv6)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil)
	end
end
