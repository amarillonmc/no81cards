--星谕神启 太公望
function c22024670.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,6,c22024670.ovfilter,aux.Stringid(22024670,0),6,c22024670.xyzop)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22024670,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_MAIN_END,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c22024670.spcost)
	e1:SetTarget(c22024670.sptg)
	e1:SetOperation(c22024670.spop)
	c:RegisterEffect(e1)
	--immune effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c22024670.immcon)
	e2:SetTarget(c22024670.etarget)
	e2:SetValue(c22024670.efilter)
	c:RegisterEffect(e2)
	
	Duel.AddCustomActivityCounter(22024671,ACTIVITY_CHAIN,c22024670.chainfilter1)
	Duel.AddCustomActivityCounter(22024672,ACTIVITY_CHAIN,c22024670.chainfilter2)
	Duel.AddCustomActivityCounter(22024673,ACTIVITY_CHAIN,c22024670.chainfilter3)

	if not c22024670.global_check then
		c22024670.global_check=true
		Hand_global_effect={}
		--negate
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge0:SetCode(EVENT_CHAINING)
		ge0:SetCondition(c22024670.discon)
		Duel.RegisterEffect(ge0,0)
	end
end
function c22024670.chainfilter1(re,tp,cid)
	local c=re:GetHandler()
	return not (re:IsActiveType(TYPE_MONSTER))
end
function c22024670.chainfilter2(re,tp,cid)
	local c=re:GetHandler()
	return not (re:IsActiveType(TYPE_SPELL))
end
function c22024670.chainfilter3(re,tp,cid)
	local c=re:GetHandler()
	return not (re:IsActiveType(TYPE_TRAP))
end
function c22024670.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22024670.xyzop(e,tp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return (Duel.GetCustomActivityCount(22024671,tp,ACTIVITY_CHAIN)~=0) and (Duel.GetCustomActivityCount(22024672,tp,ACTIVITY_CHAIN)~=0) and (Duel.GetCustomActivityCount(22024673,tp,ACTIVITY_CHAIN)~=0) and Duel.GetFlagEffect(tp,22024670)==0 end
	Duel.RegisterFlagEffect(tp,22024670,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

function c22024670.discon(e,tp,eg,ep,ev,re,r,rp)
	if not re or (re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE)) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0 then
		Hand_global_effect[re]=true
	end
	return 
end
function c22024670.spcon(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then return false end
end
function c22024670.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22024670.spfilter(c,e,tp)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22024670.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c22024670.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c22024670.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c22024670.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local ch=Duel.GetCurrentChain()
		if ch>1 then
			local p,ce=Duel.GetChainInfo(ch-1,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_EFFECT)
			if p==1-tp then
				local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,0,nil)
				if Duel.SelectYesNo(tp,aux.Stringid(22024670,1)) then
					Duel.BreakEffect()
					local g=Group.CreateGroup()
					Duel.ChangeTargetCard(ch-1,g)
					Duel.ChangeChainOperation(ch-1,c22024670.repop)
				end
			end
		end
	end
end
function c22024670.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,1-tp,REASON_EFFECT)
	end
end

function c22024670.immcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCustomActivityCount(22024671,tp,ACTIVITY_CHAIN)~=0) and (Duel.GetCustomActivityCount(22024672,tp,ACTIVITY_CHAIN)~=0) and (Duel.GetCustomActivityCount(22024673,tp,ACTIVITY_CHAIN)~=0)
end
function c22024670.etarget(e,c)
	return c:IsSetCard(0xff1) and c:IsType(TYPE_MONSTER)
end
function c22024670.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end