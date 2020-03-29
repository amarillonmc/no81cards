--幻想生物兵器-螳型
local m=14010225
local cm=_G["c"..m]
cm.named_with_FantasyArms=1
function cm.initial_effect(c)
	--special summon from hand or deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--special summon while sent to gy
	if cm.call==nil then
		cm.call=true
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(cm.spchkcon)
		e2:SetTarget(cm.spchktg)
		e2:SetOperation(cm.spchkop)
		Duel.RegisterEffect(e2,0)
	end
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CUSTOM+14011223)
	e3:SetRange(LOCATION_HAND+LOCATION_DECK)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(cm.spcon1)
	e3:SetOperation(cm.spop1)
	c:RegisterEffect(e3)		
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND+LOCATION_ONFIELD)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetCountLimit(1,m)
	e4:SetCost(cm.hcost)
	e4:SetOperation(cm.op)
	c:RegisterEffect(e4)
end
function cm.named(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FantasyArms
end
function cm.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--summon cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetTargetRange(0,0xff)
	e1:SetCost(cm.costchk)
	e1:SetOperation(cm.costop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SPSUMMON_COST)
	Duel.RegisterEffect(e2,tp)
	local e2_1=e1:Clone()
	e2_1:SetCode(EFFECT_FLIPSUMMON_COST)
	Duel.RegisterEffect(e2_1,tp)
	--set cost
	local e3=e1:Clone()
	e3:SetCode(EFFECT_MSET_COST)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SSET_COST)
	Duel.RegisterEffect(e4,tp)
	--activate cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(0,1)
	e5:SetCost(cm.costchk)
	e5:SetOperation(cm.costop)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,tp)
	--accumulate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(0x10000000+m)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(0,1)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
end
function cm.costchk(e,te_or_c,tp)
	local ct,g=Duel.GetFlagEffect(tp,m),Duel.GetDecktopGroup(1-tp,5)
	return g:FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==5 and tp~=e:GetHandlerPlayer()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetDecktopGroup(1-tp,5)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_GRAVE,0,1,c) and not Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local code=c:GetOriginalCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter1,tp,LOCATION_GRAVE,0,1,1,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	local e_t=Effect.CreateEffect(c)
	e_t:SetType(EFFECT_TYPE_FIELD)
	e_t:SetCode(m)
	e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e_t:SetTargetRange(1,0)
	e_t:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e_t,tp)
end
function cm.tdfilter1(c)
	return cm.named(c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToDeckAsCost()
end
function cm.spchkf(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.spchkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(cm.spchkf,1,nil)
end
function cm.spchktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsPlayerAffectedByEffect(tp,14010228) or Duel.IsPlayerAffectedByEffect(1-tp,14010228) end
end
function cm.spchkop(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+14011223,e,0,0,0,0)
	local te1,te2=Duel.IsPlayerAffectedByEffect(tp,14011223),Duel.IsPlayerAffectedByEffect(1-tp,14011223)
	if te1 then
		te1:Reset()
	end
	if te2 then
		te2:Reset()
	end
end
function cm.spfilter1(c,e,tp)
	return cm.named(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not Duel.IsPlayerAffectedByEffect(tp,c:GetOriginalCodeRule())
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetMZoneCount(tp)>0 and Duel.GetMatchingGroupCount(cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)>0 and Duel.IsExistingMatchingCard(cm.tdfilter1,tp,LOCATION_GRAVE,0,1,c)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c,sg,tg,ft=e:GetHandler(),Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp),Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_GRAVE,0,nil),Duel.GetMZoneCount(tp)
	if ft>0 and #sg>0 and #tg>0 then
		local chk1=true
		while chk1==true do
			local sg,tg,ft=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp),Duel.GetMatchingGroup(cm.tdfilter1,tp,LOCATION_GRAVE,0,nil),Duel.GetMZoneCount(tp)
			if Duel.IsPlayerAffectedByEffect(tp,14011223) then 
				chk1=false 
				break
			end
			if ft>0 and #sg>0 and #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
				local g=Duel.SelectMatchingCard(tp,cm.tdfilter1,tp,LOCATION_GRAVE,0,1,1,c)
				if #g>0 then
					Duel.SendtoDeck(g,nil,2,REASON_COST)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
				if #g>0 then
					Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
				end
				local code=g:GetFirst():GetOriginalCodeRule()
				local e_t=Effect.CreateEffect(c)
				e_t:SetType(EFFECT_TYPE_FIELD)
				e_t:SetCode(code)
				e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e_t:SetTargetRange(1,0)
				e_t:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e_t,tp)
			else
				local e_t=Effect.CreateEffect(c)
				e_t:SetType(EFFECT_TYPE_FIELD)
				e_t:SetCode(14011223)
				e_t:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e_t:SetTargetRange(1,0)
				e_t:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e_t,tp)
				chk1=false
			end
		end
	end
end