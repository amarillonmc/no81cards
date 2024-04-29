local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsRace,RACE_INSECT),2,114,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.tgcon)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetCountLimit(1,id+50)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	if s.global_effect==nil then
		s.global_effect=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge0:SetCode(EVENT_CHAIN_SOLVING)
		ge0:SetOperation(s.checkop)
		Duel.RegisterEffect(ge0,0)
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetLabelObject(g)
		ge1:SetOperation(s.MergedDelayEventCheck1)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(s.MergedDelayEventCheck2)
		Duel.RegisterEffect(ge2,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.acfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceupEx()
end
function s.MergedDelayEventCheck1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if tg and tg:IsExists(s.acfilter,1,nil) then g:Merge(tg:Filter(s.acfilter,nil)) end
	end
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.MergedDelayEventCheck2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,re,r,rp,ep,ev)
		g:Clear()
	end
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.tgfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsType(TYPE_TUNER) and c:IsAbleToGrave()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(1-tp,id)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=tg:SelectSubGroup(tp,aux.dncheck,false,1,Duel.GetFlagEffect(1-tp,id))
	if g and Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if #og>1 and og:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local sp=og:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
			Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsAbleToHand,1,nil) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=tg:Select(tp,1,1,nil):GetFirst()
	end
	if tc then Duel.SendtoHand(tc,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,tc) end
end
