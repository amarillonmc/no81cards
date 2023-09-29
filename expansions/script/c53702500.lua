if AD_Database then return end
AD_Database=true
SNNM=SNNM or {}
local cm=SNNM
--53702700 alleffectreset
function cm.AllGlobalCheck(c)
	if not cm.snnm_global_check then
		cm.snnm_global_check=true
		local x=c:GetOriginalCodeRule()
		if c.main_peacecho then
			local alle1=Effect.CreateEffect(c)
			alle1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle1:SetCode(EFFECT_SEND_REPLACE)
			alle1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle1:SetTarget(cm.PeacechoToDeckTarget1)
			alle1:SetValue(function(e,c) return false end)
			local alle2=Effect.CreateEffect(c)
			alle2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle2:SetCode(EFFECT_SEND_REPLACE)
			alle2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle2:SetTarget(cm.PeacechoToDeckTarget2)
			alle2:SetValue(function(e,c) return c:GetFlagEffect(53707099)>0 end)
			cm[0]=Duel.GetDecktopGroup
			Duel.GetDecktopGroup=function(tp,ct)
				Duel.RegisterFlagEffect(tp,53707000,RESET_CHAIN,0,0)
				return cm[0](tp,ct)
			end
			cm[1]=Duel.DiscardDeck
			Duel.DiscardDeck=function(tp,ct,reason)
				local g=Duel.GetDecktopGroup(tp,ct)
				Duel.DisableShuffleCheck()
				Duel.SendtoGrave(g,reason)
			end
			local alle5=Effect.CreateEffect(c)
			alle5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle5:SetCode(EFFECT_SEND_REPLACE)
			alle5:SetTarget(cm.ThirdPeacechotg)
			alle5:SetValue(cm.ThirdPeacechoval)
			Duel.RegisterEffect(alle5,0)
			local alle7=Effect.GlobalEffect()
			alle7:SetType(EFFECT_TYPE_FIELD)
			alle7:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			alle7:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
			alle7:SetTarget(function(e,c)return c.main_peacecho and c:IsAbleToDeck()end)
			alle7:SetValue(LOCATION_DECK)
			Duel.RegisterEffect(alle7,0)
			local alle8=Effect.CreateEffect(c)
			alle8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle8:SetCode(EVENT_TO_DECK)
			alle8:SetOperation(cm.ThirdPeacechoxyztd)
			Duel.RegisterEffect(alle8,0)
			local alle9=Effect.CreateEffect(c)
			alle9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle9:SetCode(EVENT_TO_DECK)
			alle9:SetOperation(cm.ThirdPeacechoxyztd)
			Duel.RegisterEffect(alle9,1)
		end
		if c.alc_yaku then
			local alle3=Effect.CreateEffect(c)
			alle3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle3:SetCode(EVENT_SSET)
			alle3:SetOperation(cm.ALCYakuCheck)
			Duel.RegisterEffect(alle3,0)
		end
		if c.organic_saucer then
			local alle4=Effect.CreateEffect(c)
			alle4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle4:SetCode(EVENT_SPSUMMON_SUCCESS)
			alle4:SetOperation(cm.OSCheck)
			Duel.RegisterEffect(alle4,0)
		end
		if c.cybern_numc then
			local alle6=Effect.CreateEffect(c)
			alle6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle6:SetCode(EVENT_CHAINING)
			alle6:SetOperation(cm.CyberNSwitch)
			Duel.RegisterEffect(alle6,0)
		end
	end
end
function cm.UpRegi(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,53707080)>0 then return end
	Duel.RegisterFlagEffect(tp,53707080,0,0,0)
	if not Duel.SelectYesNo(tp,aux.Stringid(53702500,6)) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.UpCheck)
	Duel.RegisterEffect(e1,tp)
end
function cm.UpCheck(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #g>0 then Duel.ConfirmCards(tp,g) else Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702500,7)) end
end
function cm.UpConfirm(tp)
	local UCg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #UCg>0 then Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(53702500,2)) end
	if #UCg==1 then UCg:Select(tp,1,1,nil) elseif #UCg>1 then Duel.ConfirmCards(tp,UCg) end
end
function cm.Peacecho(c,typ)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	if typ==TYPE_MONSTER then
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e4:SetCode(EVENT_DRAW)
		e4:SetTarget(cm.PeacechoDrawTarget)
		e4:SetOperation(cm.PeacechoDrawOperation)
		c:RegisterEffect(e4)
	end
	if typ==TYPE_CONTINUOUS then
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DRAW)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e5:SetCode(EVENT_DRAW)
		e5:SetTarget(cm.PeacechoDrawTarget2)
		e5:SetOperation(cm.PeacechoDrawOperation2)
		c:RegisterEffect(e5)
	end
	if typ==TYPE_FIELD then
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_DRAW)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e6:SetCode(EVENT_DRAW)
		e6:SetTarget(cm.PeacechoDrawTarget3)
		e6:SetOperation(cm.PeacechoDrawOperation3)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_ACTIVATE_COST)
		e7:SetRange(LOCATION_FZONE)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetTargetRange(1,0)
		e7:SetTarget(cm.Peacechofieldcosttg)
		e7:SetOperation(cm.Peacechofieldcostop)
		c:RegisterEffect(e7)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e9:SetRange(LOCATION_HAND+LOCATION_DECK)
	e9:SetOperation(cm.UpRegi)
	c:RegisterEffect(e9)
end
GM_global_to_deck_check=true
function cm.ThirdPeacechotgrepfilter(c)
	local tp=c:GetOwner()
	return c.main_peacecho and (c:GetLeaveFieldDest()==0 and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)) and c:GetDestination()==LOCATION_GRAVE and ((c:IsLocation(LOCATION_DECK) and (Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=c or c:IsControler(1-tp))) or (not c:IsLocation(LOCATION_DECK) and c:IsAbleToDeck()))
end
function cm.ThirdPeacechotg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return GM_global_to_deck_check and eg:IsExists(cm.ThirdPeacechotgrepfilter,1,nil) end
	GM_global_to_deck_check=false
	for i,xp in ipairs({0,1}) do
		local xyzg=eg:Filter(function(c,p)return c:GetOverlayGroup():IsExists(function(c,p)return c.main_peacecho and c:GetOwner()==p and c:IsAbleToDeck()end,1,nil,p)end,nil,xp)
		if #xyzg>0 then Duel.RegisterFlagEffect(xp,53707600,RESET_CHAIN,0,0) end
	end
	local g=eg:Filter(cm.ThirdPeacechotgrepfilter,nil)
	local confirm=Group.__add(g:Filter(aux.NOT(Card.IsLocation),nil,LOCATION_DECK):Filter(Card.IsFacedown,nil),g:Filter(Card.IsLocation,nil,LOCATION_DECK))
	Duel.ConfirmCards(0,confirm)
	Duel.ConfirmCards(1,confirm)
	for i,p in ipairs({0,1}) do
	local pg=g:Filter(Card.IsControler,nil,p)
	local g2=pg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if #g2>0 then
		if Duel.GetFlagEffect(p,53707000)==0 then Duel.ShuffleDeck(p) end
		for tc2 in aux.Next(g2) do
			Duel.MoveSequence(tc2,0)
			tc2:RegisterFlagEffect(53707500,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1,1)
		end
	end
	if #g2==#pg then
		if #g2>1 and Duel.GetFlagEffect(p,53707000)==0 then Duel.SortDecktop(p,p,#g2) end
		for i=1,#g2 do Duel.MoveSequence(Duel.GetDecktopGroup(p,1):GetFirst(),1) end
		g2:ForEach(Card.ReverseInDeck)
		Duel.ResetFlagEffect(p,53707000)
	else
		local g1=Group.__sub(pg,g2)
		if #g1>0 then
			for tc1 in aux.Next(g1) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(LOCATION_DECK)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc1:RegisterEffect(e1)
				tc1:RegisterFlagEffect(53707500,RESET_EVENT+0x13e0000,0,1)
			end
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetCountLimit(1)
		e2:SetOperation(cm.ThirdPeacechotdop)
		Duel.RegisterEffect(e2,p)
		local g3=g:Filter(function(c,p)return c:IsLocation(LOCATION_DECK) and c:IsControler(1-p) and c:GetOwner()==p end,nil,p)
		if #g3>0 then
			for tc3 in aux.Next(g3) do tc3:RegisterFlagEffect(53707500,RESET_EVENT+0x13e0000,0,1,1) end
			Duel.SendtoDeck(g3,p,0,REASON_EFFECT)
		end
	end
	end
	GM_global_to_deck_check=true
	return true
end
function cm.ThirdPeacechoval(e,c)
	return c:GetFlagEffect(53707500)~=0 and c:GetFlagEffectLabel(53707500)==1
end
function cm.ThirdPeacechotdfilter(c)
	return c:GetFlagEffect(53707500)~=0
end
function cm.ThirdPeacechotdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.ThirdPeacechotdfilter,tp,LOCATION_DECK,0,nil)
	if #g==0 then return end
	if Duel.GetFlagEffect(tp,53707600)==0 then
		if #g==1 then Duel.MoveSequence(g:GetFirst(),1) else
			Duel.SortDecktop(tp,tp,#g)
			for i=1,#g do Duel.MoveSequence(Duel.GetDecktopGroup(tp,1):GetFirst(),1) end
		end
		g:ForEach(Card.ResetFlagEffect,53707500)
		g:ForEach(Card.ReverseInDeck)
		Duel.ResetFlagEffect(tp,53707600)
	else Duel.RegisterFlagEffect(tp,53707700,RESET_CHAIN,0,0) end
	Duel.ResetFlagEffect(tp,53707000)
	e:Reset()
end
function cm.ThirdPeacechoxyztd(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c)return c.main_peacecho and c:IsPreviousLocation(LOCATION_OVERLAY)end,nil)
	if #g==0 and Duel.GetFlagEffect(tp,53707700)==0 then return end
	if Duel.GetFlagEffect(tp,53707700)>0 then g:Merge(Duel.GetMatchingGroup(cm.ThirdPeacechotdfilter,tp,LOCATION_DECK,0,nil)) end
	Duel.ResetFlagEffect(tp,53707700)
	local pg=g:Filter(Card.IsControler,nil,tp)
	if #pg==1 then Duel.MoveSequence(pg:GetFirst(),1) else
		Duel.SortDecktop(tp,tp,#pg)
		for i=1,#pg do Duel.MoveSequence(Duel.GetDecktopGroup(tp,1):GetFirst(),1) end
	end
	g:ForEach(Card.ResetFlagEffect,53707500)
	g:ForEach(Card.ReverseInDeck)
end
function cm.Peacechofieldcosttg(e,te,tp)
	return te:IsActiveType(TYPE_FIELD) and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.Peacechofieldcostop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_RULE)
	e:GetHandler():ReverseInDeck()
end
function cm.PeacechoRepFilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:IsOriginalSetCard(0x3537) and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:GetOriginalType()&TYPE_PENDULUM+TYPE_LINK==0 and c:IsAbleToDeck()
end
function cm.PeacechoToDeckTarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetControler()
	if chk==0 then return not eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and eg:IsExists(cm.PeacechoRepFilter,1,nil) end
	local g=eg:Filter(cm.PeacechoRepFilter,nil)
	local cg=g:Filter(Card.IsFacedown,nil)
	if #cg>0 then Duel.ConfirmCards(1-p,cg) end
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKBOT)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(53707000,RESET_CHAIN,0,1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetCondition(cm.PeacechoTDCondition)
		e2:SetOperation(cm.PeacechoTDOperation)
		e2:SetLabelObject(e1)
		Duel.RegisterEffect(e2,p)
	end
	return true
end
function cm.PeacechoRepFilter2(c,tp)
	return c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=c
end
function cm.PeacechoRepFilter3(c,tp)
	return cm.PeacechoRepFilter2(c,tp) and c:IsOriginalSetCard(0x3537)
end
function cm.PeacechoToDeckTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local p=c:GetControler()
	if chk==0 then return eg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) and eg:IsExists(cm.PeacechoRepFilter3,1,nil,p) end
	local bg=eg:Filter(cm.PeacechoRepFilter2,nil,p)
	local g=bg:Filter(Card.IsOriginalSetCard,nil,0x3537)
	Duel.ConfirmCards(1-p,g)
	if Duel.GetFlagEffect(p,53707000)==0 and #bg==#g then Duel.ShuffleDeck(p) end
	for tc in aux.Next(g) do
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:RegisterFlagEffect(53707099,RESET_CHAIN,0,1)
		Duel.MoveSequence(tc,1)
		tc:ReverseInDeck()
	end
	Duel.ResetFlagEffect(p,53707000)
	return true
end
function cm.PeacechoTDFilter(c)
	return c:GetFlagEffect(53707000)~=0
end
function cm.PeacechoTDCondition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.PeacechoTDFilter,1,nil)
end
function cm.PeacechoTDOperation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(cm.PeacechoTDFilter,nil)
	for tc in aux.Next(g) do
		tc:ReverseInDeck()
		tc:ResetFlagEffect(53707000)
	end
	e:Reset()
	e:GetLabelObject():Reset()
end
function cm.PeacechoDrawTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsPreviousPosition(POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function cm.PeacechoDrawTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsPlayerCanDraw(tp,1) and not e:GetHandler():IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
end
function cm.PeacechoDrawTarget3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousPosition(POS_FACEUP) and Duel.IsPlayerCanDraw(tp,1) and not e:GetHandler():IsForbidden() end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.PeacechoDrawOperation3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	if Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true) then
		local te=c:GetActivateEffect()
		local tep=c:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(c,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
--
function cm.Faceupdeckcheck(g,tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #g>1 then
		Debug.Message("请先确认卡组表面向上的卡的位置")
		Duel.ConfirmCards(tp,g)
	elseif #g>0 then
		Debug.Message("卡组表面向上的卡的位置序号是："..(g:GetFirst():GetSequence()+1).."")
	end
end
--
function cm.FanippetTrap(c,t)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	--e4:SetCost(cm.GraveActCostchk)
	e4:SetTarget(cm.GraveActCostTarget(t))
	e4:SetOperation(cm.GraveActCostOp)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_RELEASE)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCondition(cm.FanippetTrapTGCondition)
	e5:SetTarget(cm.FanippetTrapTGTarget)
	e5:SetOperation(cm.FanippetTrapTGOperation)
	c:RegisterEffect(e5)
end
function cm.FanippetTrapTGCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.FanippetTrapTGTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cm.FanippetTrapTGOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
end
function cm.GraveActCostchk(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function cm.GraveActCostTarget(t)
	return
	function(e,te,tp)
	   local res=false
	   for _,v in pairs(t) do
		   if te==v then res=true end
	   end
	   return te:GetHandler()==e:GetHandler() and res
	end
end
function cm.GraveActCostOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.Fanippetrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.Fanippetrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
end
function cm.ALCYakuNew(c,code,cf,loc,t)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetTarget(cm.NALCTtg(code,loc,t))
	e1:SetOperation(cm.NALCTac(code,cf,t))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0x7f)
	e2:SetOperation(cm.ALCReload)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.ALCYakuActCondition)
	c:RegisterEffect(e3)
end
function cm.ALCReload(e,tp)
	aux.AddFusionProcCode2=_tmp
	aux.AddFusionProcCode2FunRep=_tmp_1
	aux.AddFusionProcCode3=_tmp_2
	aux.AddFusionProcCode4=_tmp_3
	aux.AddFusionProcCodeFun=_tmp_4
	aux.AddFusionProcCodeFunRep=_tmp_5
	aux.AddFusionProcCodeRep=_tmp_6
	aux.AddFusionProcCodeRep2=_tmp_7
	aux.AddFusionProcFun2=_tmp_8
	aux.AddFusionProcFunFun=_tmp_9
	aux.AddFusionProcFunFunRep=_tmp_0
	aux.AddFusionProcFunRep=_tmp_1_0
	aux.AddFusionProcFunRep2=_tmp_1_1
	aux.AddFusionProcMix=_tmp_1_2
	aux.AddFusionProcMixRep=_tmp_1_3
	aux.AddFusionProcShaddoll=_tmp_1_4
end
_tmp=aux.AddFusionProcCode2
_tmp_1=aux.AddFusionProcCode2FunRep
_tmp_2=aux.AddFusionProcCode3
_tmp_3=aux.AddFusionProcCode4
_tmp_4=aux.AddFusionProcCodeFun
_tmp_5=aux.AddFusionProcCodeFunRep
_tmp_6=aux.AddFusionProcCodeRep
_tmp_7=aux.AddFusionProcCodeRep2
_tmp_8=aux.AddFusionProcFun2
_tmp_9=aux.AddFusionProcFunFun
_tmp_0=aux.AddFusionProcFunFunRep
_tmp_1_0=aux.AddFusionProcFunRep
_tmp_1_1=aux.AddFusionProcFunRep2
_tmp_1_2=aux.AddFusionProcMix
_tmp_1_3=aux.AddFusionProcMixRep
_tmp_1_4=aux.AddFusionProcShaddoll
function aux.AddFusionProcCode2(c,code1,code2,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp(c,code1,code2,sub,insf)
end
function aux.AddFusionProcCode2FunRep(c,code1,code2,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2+min
	end
	return _tmp_1(c,code1,code2,f,min,max,sub,insf)
end
function aux.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=3
	end
	return _tmp_2(c,code1,code2,code3,sub,insf)
end
function aux.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=4
	end
	return _tmp_3(c,code1,code2,code3,code4,sub,insf)
end
function aux.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=1+cc
	end
	return _tmp_4(c,code1,f,cc,sub,insf)
end
function aux.AddFusionProcCodeFunRep(c,code1,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_5(c,code1,f,min,max,sub,insf)
end
function aux.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_6(c,code1,cc,sub,insf)
end
function aux.AddFusionProcCodeRep2(c,code1,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_7(c,code1,min,max,sub,insf)
end
function aux.AddFusionProcFun2(c,f,f1,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_8(c,f,f1,insf)
end
function aux.AddFusionProcFunFun(c,f1,f2,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc+1
	end
	return _tmp_9(c,f1,f2,cc,sub,insf)
end
function aux.AddFusionProcFunFunRep(c,f1,f2,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_0(c,f1,f2,min,max,sub,insf)
end
function aux.AddFusionProcFunRep2(c,f,min,max,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_1(c,f,min,max,insf)
end
function aux.AddFusionProcFunRep(c,f,cc,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_1_0(c,f,cc,insf)
end
function aux.AddFusionProcMix(c,sub,insf,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	local val={...}
	local sum=#val 
	if not c.fst then
		ccodem.fst=sum
	end
	return _tmp_1_2(c,sub,insf,...)
end
function aux.AddFusionProcMixRep(c,sub,insf,f1,min,max,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_3(c,sub,insf,f1,min,max,...)
end
function aux.AddFusionProcShaddoll(c,att)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_1_4(c,att)
end
function cm.NALCTtg(code,loc,t)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,table.unpack(t)) and Duel.GetFieldGroupCount(tp,0,loc)>0 end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.NALCTac(code,cf,t)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,table.unpack(t)) then return end
		local g=cf(c,tp)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702600,2))
		local conc=g:Select(tp,1,1,nil):GetFirst()
		if conc:IsFacedown() then Duel.ConfirmCards(tp,conc) end
		Duel.HintSelection(Group.FromCards(conc))
		if conc:IsLocation(LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
		if conc:IsLocation(LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
		local cd=conc:GetCode()
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(cd)
			e1:SetReset(RESET_EVENT+0x7e0000)
			c:RegisterEffect(e1)
			local chkf=tp
			local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
			local mtf=function(c,e,tp)return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() and not c:IsImmuneToEffect(e)end
			local fuf=function(c,e,tp,m,f,chkf,ft)
						  return c:IsType(TYPE_FUSION) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf) and (not c.fst or ft>=c.fst)
					  end
			local zck=function(g,c,chkf,ft)return c:CheckFusionMaterial(g,nil,chkf) and ft>=#g end
			local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(mtf,nil,e,tp)
			if #mg1==0 then return end
			local sg1=Duel.GetMatchingGroup(fuf,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,ft)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(fuf,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf,114)
			end
			if (#sg1>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
				Duel.BreakEffect()
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					if tc.fst then
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702600,3))
						local mat1=mg1:SelectSubGroup(tp,zck,false,tc.fst,#mg1,tc,chkf,ft)
						--local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
						tc:SetMaterial(mat1)
						for mvc in aux.Next(mat1) do Duel.MoveToField(mvc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
					end
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()
			end
		end
	end
end
function cm.ALCYakuActCondition(e)
	return e:GetHandler():GetFlagEffect(53713000)>0
end
function cm.OrganicSaucer(c,lab,code)
	aux.EnablePendulumAttribute(c)
	if lab<4 then
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(code,0))
		e0:SetCategory(CATEGORY_TOGRAVE)
		e0:SetRange(LOCATION_PZONE)
		e0:SetCountLimit(1)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+0x11e0)
		e0:SetCondition(cm.OSDiskCondition)
		e0:SetTarget(cm.OSDiskTarget1)
		e0:SetOperation(cm.OSDiskActivate1)
		c:RegisterEffect(e0)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,1))
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetRange(LOCATION_HAND)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(cm.OSKaijuCondition1)
		e2:SetTarget(cm.OSKaijuTarget(lab))
		e2:SetOperation(cm.OSKaijuOperation(lab))
		c:RegisterEffect(e2)
	else
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(code,0))
		e0:SetCategory(CATEGORY_DECKDES)
		e0:SetRange(LOCATION_PZONE)
		e0:SetCountLimit(1)
		e0:SetType(EFFECT_TYPE_QUICK_O)
		e0:SetCode(EVENT_FREE_CHAIN)
		e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+0x11e0)
		e0:SetCondition(cm.OSDiskCondition)
		e0:SetTarget(cm.OSDiskTarget2)
		e0:SetOperation(cm.OSDiskActivate2)
		c:RegisterEffect(e0)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(code,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(cm.OSKaijuCondition2)
		e1:SetCost(cm.OSKaijuCost)
		e1:SetTarget(cm.OSKaijuTarget(lab))
		e1:SetOperation(cm.OSKaijuOperation(lab))
		c:RegisterEffect(e1)
	end
end
function cm.OSCheck(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local p=tc:GetSummonPlayer()
		local rac=Duel.GetFlagEffectLabel(p,53703000)
		Duel.ResetFlagEffect(p,53703000)
		local race=nil
		if rac==nil then race=tc:GetRace() else race=rac|tc:GetRace() end
		Duel.RegisterFlagEffect(p,53703000,RESET_PHASE+PHASE_END,0,1,race)
	end
end
function cm.OSDiskCondition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetCurrentChain()==0
end
function cm.OSDiskTarget1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>1 and Duel.GetDecktopGroup(tp,2):IsExists(Card.IsAbleToGrave,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,LOCATION_DECK)
end
function cm.OSDiskActivate1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<2 then return end
	Duel.ConfirmDecktop(1-tp,2)
	local g=Duel.GetDecktopGroup(1-tp,2)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(tp,Card.IsAbleToGrave,1,1,nil)
		if #sg>0 then
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(sg,REASON_EFFECT)
			g:Sub(sg)
			Duel.MoveSequence(g:GetFirst(),1)
		else
			for i=1,2 do
				local mg=Duel.GetDecktopGroup(1-tp,1)
				Duel.MoveSequence(mg:GetFirst(),1)
			end
		end
	end
end
function cm.OSCostfilter(c)
	return c:IsPreviousLocation(LOCATION_DECK)
end
function cm.OSKaijuCondition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.OSCostfilter,1,nil)
end
function cm.OSKaijuSPfilter(c,e,tp)
	return c:IsSetCard(0x3533) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.OSKaijuMfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE)
end
function cm.OSKaijuTarget(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(cm.OSKaijuSPfilter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_PZONE)
		if lab<4 and eg:IsExists(cm.OSKaijuMfilter,1,nil) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA)
			Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
			if lab==1 and Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_DESTROY)
				local g=Duel.GetMatchingGroup(Card.IsAttackPos,tp,0,LOCATION_MZONE,nil)
				Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			end
			if lab==2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_REMOVE)
				local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
				Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
			end
			if lab==3 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) then
				e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOEXTRA+CATEGORY_DESTROY)
				local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
				Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
			end
		end
	end
end
function cm.OSKaijuOperation(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
		if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 and lab<4 and c:IsRelateToEffect(e) and eg:IsExists(cm.OSKaijuMfilter,1,nil) then
			Duel.BreakEffect()
			Duel.SendtoExtraP(c,tp,REASON_EFFECT)
			if c:IsLocation(LOCATION_EXTRA) and lab==1 and Duel.IsExistingMatchingCard(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
				if sg:GetCount()>0 then
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
			if c:IsLocation(LOCATION_EXTRA) and lab==2 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
				if sg:GetCount()>0 then
					Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if c:IsLocation(LOCATION_EXTRA) and lab==3 and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
				if sg:GetCount()>0 then
					Duel.HintSelection(sg)
					Duel.Destroy(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.OSDiskTarget2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function cm.OSDiskActivate2(e,tp,eg,ep,ev,re,r,rp)
	local ct={}
	for i=3,1,-1 do
		if Duel.IsPlayerCanDiscardDeck(1-tp,i) then
			table.insert(ct,i)
		end
	end
	if #ct==1 then
		Duel.DiscardDeck(1-tp,ct[1],REASON_EFFECT)
	else
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(e:GetHandler():GetOriginalCode(),4))
		local ac=Duel.AnnounceNumber(1-tp,table.unpack(ct))
		Duel.DiscardDeck(1-tp,ac,REASON_EFFECT)
	end
end
function cm.OSKaijuCondition2(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.OSKaijuCost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckOrExtraAsCost() end
	Duel.SendtoExtraP(c,tp,REASON_COST)
end
function cm.OSReturnFilter(c,tp)
	local rac=Duel.GetFlagEffectLabel(tp,53703000)
	local b1=nil
	if rac==nil then b1=0 else b1=rac&(c:GetRace())==0 end
	return c:IsSetCard(0x3533) and c:IsType(TYPE_PENDULUM) and b1 and not c:IsForbidden()
end
function cm.OSReturnTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.OSReturnOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsAbleToHand() and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(cm.OSReturnFilter,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.OSReturnFilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
--
