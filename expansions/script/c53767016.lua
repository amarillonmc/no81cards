if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
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
	local g=Group.CreateGroup()
	g:KeepAlive()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(g)
	e3:SetOperation(s.mop1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(s.mop2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CUSTOM+id)
	e5:SetCountLimit(1,id+50)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,aux.FALSE)
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
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=tg:SelectSubGroup(tp,aux.dncheck,false,1,Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN))
	if g then
		local og=SNNM.WhitkinsToGrave(g,REASON_EFFECT):Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		if #og>1 and og:IsExists(Card.IsCanBeSpecialSummoned,1,nil,e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			local sp=og:FilterSelect(tp,Card.IsCanBeSpecialSummoned,1,1,nil,e,0,tp,false,false)
			Duel.SpecialSummon(sp,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.acfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsFaceupEx() or c:IsLocation(LOCATION_SZONE))
end
function s.mop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
		if not tg then return end
		local mg=tg:Filter(s.acfilter,nil)
		if #mg>0 then
			g:Merge(mg)
			mg:ForEach(Card.RegisterFlagEffect,id+50,RESET_EVENT+RESETS_STANDARD,0,1,e:GetHandler():GetFieldID())
		end
	end
end
function s.mop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+id,e,r,rp,ep,ev)
		g:Clear()
	end
end
function s.thfilter(c,fid)
	local res=false
	for _,flag in ipairs({c:GetFlagEffectLabel(id+50)}) do if flag==fid then res=true end end
	return res and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.thfilter,nil,e:GetHandler():GetFieldID())
	if chk==0 then return re:GetHandler()==e:GetHandler() and #g>0 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	local tc=tg:GetFirst()
	if #tg>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=tg:Select(tp,1,1,nil):GetFirst()
	end
	if tc then Duel.SendtoHand(tc,tp,REASON_EFFECT) Duel.ConfirmCards(1-tp,tc) end
end
