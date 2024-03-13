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
			--Duel.RegisterEffect(alle1,0)
			local alle2=Effect.CreateEffect(c)
			alle2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle2:SetCode(EFFECT_SEND_REPLACE)
			alle2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle2:SetTarget(cm.PeacechoToDeckTarget2)
			alle2:SetValue(function(e,c) return c:GetFlagEffect(53707099)>0 end)
			--Duel.RegisterEffect(alle2,0)
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
			--cm[2]=Card.ReverseInDeck
			--Card.ReverseInDeck=function(card)
				--card:RegisterFlagEffect(53707050,RESET_EVENT+0x53c0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53702500,2))
				--return cm[2](card)
			--end
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
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0xff)
	e1:SetTarget(cm.RePeacechotg1)
	e1:SetOperation(cm.RePeacechoop)
	--c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTarget(cm.RePeacechotg2)
	--c:RegisterEffect(e2)
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
function cm.RePeacechotg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:IsAbleToDeck() end
	return true
end
function cm.RePeacechotg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_DECK) and c:GetDestination()==LOCATION_GRAVE and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and Duel.GetFieldGroup(tp,LOCATION_DECK,0):GetMinGroup(Card.GetSequence):GetFirst()~=c end
	return true
end
function cm.RePeacechoop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsFacedown() then Duel.ConfirmCards(1-tp,c) end
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	if c:IsLocation(LOCATION_DECK) then
		if Duel.GetFlagEffect(tp,53707000)==0 then Duel.ShuffleDeck(tp) end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVED)
		e3:SetOperation(cm.RePeacechorst)
		e3:SetLabelObject(e)
		Duel.RegisterEffect(e3,tp)
		Duel.MoveSequence(c,1)
	else Duel.SendtoDeck(c,nil,1,REASON_RULE) end
	c:ReverseInDeck()
end
function cm.RePeacechorst(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.ResetFlagEffect(tp,53707000)
	e:Reset()
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
function cm.FanippetTrapSPCondition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp or ep==1-tp or re:GetHandler():IsCode(53716006)
end
function cm.FanippetTrapSPCost(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return Duel.GetFlagEffect(tp,code)==0 and not c:IsLocation(LOCATION_ONFIELD) end
		Duel.RegisterFlagEffect(tp,code,RESET_CHAIN,0,1)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_CHAIN_SOLVING)
		e3:SetOperation(cm.Fanippetready)
		e3:SetLabelObject(c)
		Duel.RegisterEffect(e3,tp)
	end
end
function cm.Fanippetready(e,tp)
	e:GetLabelObject():SetStatus(STATUS_EFFECT_ENABLED,true)
	e:Reset()
end
--
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
function cm.ALCYaku(c,code,num,loc,atk,def,rac,att)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_STANDBY_PHASE+TIMING_END_PHASE)
	if c:GetOriginalCode()~=53713007 then e1:SetCost(cm.ALCYakuActCost(code,num,loc)) else e1:SetCost(cm.ALCYakuActCost2) end
	e1:SetTarget(cm.ALCYakuActTarget(code,atk,def,rac,att))
	e1:SetOperation(cm.ALCYakuActivate(code,atk,def,rac,att))
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCondition(cm.ALCYakuActCondition)
	c:RegisterEffect(e3)
end
function cm.ALCYakuCheck(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	for tc in aux.Next(eg) do
		tc:RegisterFlagEffect(53713000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.ALCYakuActCost(code,num,loc)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local ct=Duel.GetFieldGroupCount(tp,0,loc)
		if chk==0 then return ct>0 end
		local ac=1
		if ct>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(code,1))
			ac=Duel.AnnounceLevel(tp,1,math.min(ct,num))
		end
		local g=Duel.GetFieldGroup(1-tp,loc,0):RandomSelect(tp,ac)
		Duel.ConfirmCards(tp,g)
		if loc==LOCATION_HAND then Duel.ShuffleHand(1-tp) end
		if loc==LOCATION_DECK then Duel.ShuffleDeck(1-tp) end
		local list={}
		for tc in aux.Next(g) do
			table.insert(list,tc:GetCode())
		end
		e:SetLabel(table.unpack(list))
	end
end
function cm.ALCYakuActCost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)>0 end
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	if #g1<1 or (#g2>0 and Duel.SelectYesNo(tp,aux.Stringid(53713007,1))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
		local cg=g2:Select(tp,1,1,nil)
		g1:Merge(cg)
	end
	Duel.ConfirmCards(tp,g1)
	local list={}
	for tc in aux.Next(g1) do
		table.insert(list,tc:GetCode())
	end
	e:SetLabel(table.unpack(list))
end
function cm.ALCYakuActTarget(code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att) end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.ALCYakuFusionFilter1(c,e)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e)
end
function cm.ALCYakuFusionFilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.ALCYakuActivate(code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
			or not Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x1535,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att) then return end
		local list={e:GetLabel()}
		local ct=1
		if #list>1 then
			Duel.Hint(24,tp,aux.Stringid(53702600,2))
			ct=Duel.AnnounceLevel(tp,1,#list)
		end
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		if Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(list[ct])
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD-RESET_LEAVE)
			c:RegisterEffect(e1)
			local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil):Filter(cm.ALCYakuFusionFilter1,nil,e)
			local sg1=Duel.GetMatchingGroup(cm.ALCYakuFusionFilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
			local mg2=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(cm.ALCYakuFusionFilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
			end
			if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(code,0)) then
				Duel.BreakEffect()
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
					tc:SetMaterial(mat1)
					Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
--
function cm.ALCIppa(c,code,num)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.ALCTFCost(num))
	e0:SetOperation(cm.ALCTFOperation(num))
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.ALCFusionCondition)
	e1:SetOperation(cm.ALCFusionOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2,code)
	e2:SetCondition(cm.ALCDisCondition)
	e2:SetTarget(cm.ALCDisTarget)
	e2:SetOperation(cm.ALCDisOperation(code))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(code,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetTarget(cm.ALCSetTarget)
	e3:SetOperation(cm.ALCSetOperation)
	c:RegisterEffect(e3)
end
function cm.ALCTFFilter(c)
	return bit.band(c:GetOriginalType(),TYPE_TRAP)~=0 and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.ALCFSelect(g,e,tp)
	return Duel.GetLocationCountFromEx(tp,tp,g,e:GetHandler())
end
function cm.ALCTFCost(num)
	return
	function(e,c,tp,st)
		if bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
			e:SetLabel(1)
			local cg=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
			return cg:CheckSubGroup(cm.ALCFSelect,num,num,e,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE)>1 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		else
			e:SetLabel(0)
			return true
		end
	end
end
function cm.ALCTFOperation(num)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetLabel()==0 then return true end
		e:SetLabel(0)
		local g=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local fg=g:SelectSubGroup(tp,cm.ALCFSelect,false,num,num,e,tp)
		Duel.HintSelection(fg)
		for tc in aux.Next(fg) do
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end
	end
end
function cm.ALCFusionCondition(e,g,gc,chkfnf)
	if g==nil then return true end
	if gc then return false end
	local c=e:GetHandler()
	local tp=c:GetControler()
	if aux.FCheckAdditional and not aux.FCheckAdditional(tp,Group.CreateGroup(),c) then return false end
	local chkf=(chkfnf & 0xff)
	return chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf)>-1
end
function cm.ALCFusionOperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	Duel.SetFusionMaterial(Group.CreateGroup())
end
function cm.ALCDisCondition(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function cm.ALCRealSetFilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and (c:IsSSetable(true) or c:IsCanTurnSet())
end
function cm.ALCDisTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ALCRealSetFilter,tp,LOCATION_ONFIELD,0,1,nil,eg:GetFirst():GetCode()) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.ALCDisOperation(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.ALCRealSetFilter,tp,LOCATION_ONFIELD,0,1,1,nil,eg:GetFirst():GetCode())
		if #g>0 then
			Duel.HintSelection(g)
			local tc=g:GetFirst()
			tc:CancelToGrave()
			Duel.ChangePosition(tc,POS_FACEDOWN)
			if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
			if code==53713002 then
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_HAND,nil)
				if Duel.NegateActivation(ev) and #g2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:RandomSelect(tp,1)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
			if code==53713004 then
				local rg=Duel.GetDecktopGroup(1-tp,5)
				if Duel.NegateActivation(ev) and rg:FilterCount(Card.IsAbleToRemove,nil)==5 then
					Duel.DisableShuffleCheck()
					Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if code==53713008 then
				local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
				if Duel.NegateActivation(ev) and #rg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
					local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,3,nil)
					Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
				end
			end
			if code==53713009 then
				local g2=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
				if Duel.NegateActivation(ev) and #g2>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local sg=g2:Select(tp,1,1,nil)
					Duel.HintSelection(sg)
					Duel.SendtoGrave(sg,REASON_EFFECT)
				end
			end
		end
	end
end
function cm.ALCSetFilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function cm.ALCSetTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ALCSetFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.ALCSetOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.ALCSetFilter,tp,LOCATION_ONFIELD,0,1,2,nil)
		if #g>0 then
			Duel.HintSelection(g)
			for tc in aux.Next(g) do
				tc:CancelToGrave()
				Duel.ChangePosition(tc,POS_FACEDOWN)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
			end
		end
	end
end
--
function cm.HTFSynchoro(c,lab,code)
	if lab==0 then aux.EnablePendulumAttribute(c,false) end
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.HTFsyncon(lab,code))
	e0:SetTarget(cm.HTFsyntg(lab,code))
	e0:SetOperation(cm.HTFsynop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	if lab>4 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,2))
		e2:SetCategory(CATEGORY_TODECK)
		e2:SetType(EFFECT_TYPE_IGNITION)
		e2:SetRange(LOCATION_GRAVE)
		e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e2:SetCondition(aux.exccon)
		e2:SetTarget(cm.HTFTDTarget(lab))
		e2:SetOperation(cm.HTFTDOperation)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetCondition(cm.HTFSynMatCondition)
		e3:SetOperation(cm.HTFSynMatOperation(code))
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_MATERIAL_CHECK)
		e4:SetValue(cm.HTFvalcheck(lab))
		e4:SetLabelObject(e3)
		c:RegisterEffect(e4)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(cm.DoubleTunerCheck)
	c:RegisterEffect(e9)
end
function cm.DoubleTunerCheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.CheckGroup(g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	if min>max then return false end
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	if ct>=min and ct<max and f(sg,...) then return true end
	return g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params)
end
function cm.HTFval(c,syncard,lab)
	local slv=c:GetSynchroLevel(syncard)
	if lab>4 and c:IsSynchroType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_EFFECT) then
		slv=1
	end
	return slv
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or g:GetCount()
	local ext_params={...}
	local sg=Group.CreateGroup()
	if cg then sg:Merge(cg) end
	local ct=sg:GetCount()
	while ct<max and not (ct>=min and f(sg,...) and not (g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params) and Duel.SelectYesNo(tp,210))) do
		Duel.Hint(HINT_SELECTMSG,tp,desc)
		local tg=g:FilterSelect(tp,cm.CheckGroupRecursive,1,1,sg,sg,g,f,min,max,ext_params)
		if tg:GetCount()==0 then error("Incorrect Group Filter",2) end
		sg:Merge(tg)
		ct=sg:GetCount()
	end
	return sg
end
function cm.HTFmatfilter1(c,syncard,tp,lab)
	if c:IsFacedown() or (lab>4 and not c:IsSynchroType(TYPE_SYNCHRO)) then return false end
	if not c:IsType(TYPE_EFFECT) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() and c:IsType(TYPE_TUNER) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and (not c:IsType(TYPE_EFFECT) or not (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.HTFmatfilter2(c,syncard)
	if not c:IsType(TYPE_EFFECT) and c:IsSynchroType(TYPE_PENDULUM) and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup() then return true end
	return c:IsSynchroType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
		and (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE)) and (not c:IsType(TYPE_EFFECT) or not (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp,lab)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return cm.CheckGroup(tsg,cm.HTFgoal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c,lab)
end
function cm.HTFgoal(g,tp,lv,syncard,tuc,lab)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.HTFval,lv,ct,ct,syncard,lab)
end
function cm.HTFsyncon(lab,code)
	return
	function(e,c,tuner,mg)
		if c==nil then return true end
		if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
		local tp=c:GetControler()
		local minc=2
		local maxc=c:GetLevel()
		local g1=nil
		local g2=nil
		local g3=nil
		if mg then
			g1=mg:Filter(cm.HTFmatfilter1,nil,c,tp,lab)
			g2=mg:Filter(cm.HTFmatfilter2,nil,c)
			g3=g2:Clone()
		else
			if Duel.GetFlagEffect(tp,code)==0 then
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c)
			else
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
			end
			g3=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		end
		local lv=c:GetLevel()
		local sg=nil
		if tuner then
			return cm.HTFmatfilter1(c,tp,lab) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp,lab)
		else
			return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp,lab)
		end
	end
end
function cm.HTFsyntg(lab,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
		local minc=2
		local maxc=c:GetLevel()
		local g1=nil
		local g2=nil
		local g3=nil
		if mg then
			g1=mg:Filter(cm.HTFmatfilter1,nil,c,tp,lab)
			g2=mg:Filter(cm.HTFmatfilter2,nil,c)
			g3=g2:Clone()
		else
			if Duel.GetFlagEffect(tp,code)==0 then
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_EXTRA,LOCATION_MZONE,nil,c)
			else
				g1=Duel.GetMatchingGroup(cm.HTFmatfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp,lab)
				g2=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
			end
			g3=Duel.GetMatchingGroup(cm.HTFmatfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
		end
		local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
		local lv=c:GetLevel()
		local tuc=nil
		if tuner then
			tuner=tuc
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
			if not pe then
				local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp,lab)
				tuc=t1:GetFirst()
			else
				tuc=pe:GetOwner()
				Group.FromCards(tuc):Select(tp,1,1,nil)
			end
		end
		tuc:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000,0,1)
		local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
		local f=tuc.tuner_filter
		if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
		local g=cm.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.HTFgoal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc,lab)
		if g then
			g:KeepAlive()
			e:SetLabelObject(g)
			return true
		else return false end
	end
end
function cm.HTFsynop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_EXTRA) then Duel.RegisterFlagEffect(tp,c:GetOriginalCode(),RESET_PHASE+PHASE_END,0,1) end
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.HTFSynMatCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function cm.HTFSynMatOperation(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(code,0))
	end
end
function cm.HTFvalcheck(lab)
	return
	function(e,c)
		if c:GetMaterialCount()==lab then e:GetLabelObject():SetLabel(1) else e:GetLabelObject():SetLabel(0) end
	end
end
function cm.HTFTDFilter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_EFFECT) and c:IsAbleToDeck()
end
function cm.HTFTDTarget(lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
		if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cm.filter(chkc) end
		if chk==0 then return e:GetHandler():IsAbleToExtra()
			and Duel.IsExistingTarget(cm.HTFTDFilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectTarget(tp,cm.HTFTDFilter,tp,LOCATION_GRAVE,0,1,lab,e:GetHandler())
		g:AddCard(e:GetHandler())
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	end
end
function cm.HTFTDOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if c:IsRelateToEffect(e) and #g>0 then
		g:AddCard(c)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--
function cm.HTFPlacePZone(c,lv,loc,lab,event,code,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(event)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.HTFPlaceCondition(lv,loc,lab))
	e1:SetOperation(cm.HTFPlaceOperation(lv,loc,lab,code))
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.HTFPlaceFilter(c,lv,lab)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(lv) and not c:IsType(TYPE_EFFECT) and not c:IsForbidden() and (c:IsFaceup() or lab==0)
end
function cm.HTFPlaceCondition(lv,loc,lab)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.IsExistingMatchingCard(cm.HTFPlaceFilter,tp,loc,0,1,nil,lv,lab) and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
	end
end
function cm.HTFPlaceOperation(lv,loc,lab,code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_CARD,0,code)
		if lab==0 or Duel.SelectYesNo(tp,aux.Stringid(code,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local tc=Duel.SelectMatchingCard(tp,cm.HTFPlaceFilter,tp,loc,0,1,1,nil,lv,lab):GetFirst()
			if tc then Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true) end
		end
	end
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
function cm.SorisonFish(c)
	--[[local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetTarget(cm.Sorisonsyntg)
	e0:SetValue(1)
	e0:SetOperation(cm.Sorisonsynop)
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_HAND_SYNCHRO)
	e01:SetTarget(cm.Sorisonhsyntg)
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetRange(LOCATION_HAND)
	e02:SetTargetRange(LOCATION_MZONE,0)
	--e02:SetCondition(cm.SorisonhsCondition)
	e02:SetTarget(cm.SorisonhsTarget)
	e02:SetLabelObject(e0)
	--c:RegisterEffect(e02)
	local e03=e02:Clone()
	e03:SetLabelObject(e01)
	--c:RegisterEffect(e03)
	--local e04=Effect.CreateEffect(c)
	--e04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e04:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	--e04:SetCode(EVENT_ADJUST)
	--e04:SetRange(LOCATION_HAND)
	--e04:SetOperation(cm.SorisonAntiRepeat)
	--c:RegisterEffect(e04)--]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(0xff)
	e1:SetOperation(cm.SorisonMark)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53721000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(53721000)
	e2:SetRange(LOCATION_HAND)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_SEND_REPLACE)
	e4:SetRange(LOCATION_HAND)
	e4:SetTarget(cm.SorisonSpecialreptg)
	c:RegisterEffect(e4)
end
function cm.SorisonSpecialreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and c:IsReason(REASON_SYNCHRO) and c:GetReasonCard():IsRace(RACE_AQUA) and c:GetReasonCard():IsCode(53721016) and c:GetDestination()==LOCATION_GRAVE end
	Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetValue(LOCATION_DECK)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	c:RegisterEffect(e1,true)
	return false
end
function cm.SorisonMark(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53721000)>0 then return end
	Duel.RegisterFlagEffect(0,53721000,0,0,0)
	local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,nil)
	for tc in aux.Next(g) do
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(cm.Sorisonsyntg)
	e1:SetValue(1)
	e1:SetOperation(cm.Sorisonsynop)
	tc:RegisterEffect(e1,true)
	local e3=Effect.CreateEffect(tc)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_HAND_SYNCHRO)
	e3:SetTarget(cm.Sorisonhsyntg)
	tc:RegisterEffect(e3,true)
	end
end
function cm.Sorisonsynfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.Sorisonsynfilter2(c,syncard,tuner,f)
	return c:IsHasEffect(53721000) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.Sorisonsyncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=cm.Sorisonsyngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(cm.Sorisonsyncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function cm.Sorisonsyngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function cm.Sorisonsyntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.Sorisonsynfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.Sorisonsynfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	return mg:IsExists(cm.Sorisonsyncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function cm.Sorisonsynop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(cm.Sorisonsynfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	if syncard:IsRace(RACE_AQUA) then
		local exg=Duel.GetMatchingGroup(cm.Sorisonsynfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
		mg:Merge(exg)
	end
	for i=1,maxc do
		local cg=mg:Filter(cm.Sorisonsyncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.Sorisonsyngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg>0 then
		for tc in aux.Next(hg) do
			Duel.ConfirmCards(1-tp,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e1:SetValue(LOCATION_DECK)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e1,true)
		end
	end
	Duel.SetSynchroMaterial(g)
end
function cm.Sorisonhsyntg(e,c)
	return c:IsHasEffect(53721000)
end
function cm.SorisonhsCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53721049)>0
end
function cm.SorisonhsTarget(e,c)
	return c:IsType(TYPE_TUNER)
end
function cm.SorisonAntiRepeatf(c)
	return c:IsOriginalSetCard(0xa531) and not c:IsType(TYPE_TUNER) and c:GetFlagEffect(53721049)>0
end
function cm.SorisonAntiRepeat(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.SorisonAntiRepeatf,tp,LOCATION_HAND,0,c)
	if #g==0 then
		c:RegisterFlagEffect(53721049,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end
function cm.SorisonTGCondition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsAttribute(ATTRIBUTE_WATER)
end
--
function cm.GreatCircle(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCondition(cm.GCSPCondition)
	e1:SetOperation(cm.GCSPOperation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.GCTHCondition)
	e2:SetOperation(cm.GCTHOperation)
	c:RegisterEffect(e2)
end
function cm.GCSPFilter(c)
	return c:IsSetCard(0x3531) and c:IsDiscardable()
end
function cm.GCSPCondition(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.GCSPFilter,tp,LOCATION_HAND,0,1,c)
end
function cm.GCSPOperation(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,cm.GCSPFilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.GCTHCondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
		and e:GetHandler()==Duel.GetFieldCard(tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)-1)
end
function cm.GCTHOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	if c:IsAbleToHand() and (not c:IsAbleToDeck() or Duel.SelectYesNo(tp,aux.Stringid(c:GetOriginalCode(),1))) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,c)
			Duel.SetLP(tp,Duel.GetLP(tp)-400)
		end
	else
		if Duel.SendtoDeck(c,nil,2,REASON_EFFECT)~=0 then Duel.SetLP(tp,Duel.GetLP(tp)-400) end
	end
end
--
function cm.SeadowRover(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	if c:GetOriginalType()&TYPE_TUNER==TYPE_TUNER then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_TO_DECK)
		e2:SetOperation(cm.SRoverDrawOp)
		c:RegisterEffect(e2)
	end
end
function cm.SRoverDrawOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_HAND) or not c:IsPreviousPosition(POS_FACEUP) then return end
	local ct=Duel.GetDrawCount(tp)
	if Duel.GetTurnCount()==1 then
		ct=1
		local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DRAW_COUNT)}
		for _,te in pairs(eset) do if te:GetValue()>ct then ct=te:GetValue() end end
	end
	if ct>3 then return end
	Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetTargetRange(1,0)
	e2:SetValue(ct+1)
	e2:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
end
function cm.SeadowRoverSyn(c)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(SUMMON_TYPE_SYNCHRO)
	e2:SetCondition(cm.SRoverSPcon)
	e2:SetOperation(cm.SRoverSPop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(c:GetOriginalCode(),2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.SRoverDrawCon2)
	e4:SetTarget(cm.SRoverDrawtg2)
	e4:SetOperation(cm.SRoverDrawOp2)
	c:RegisterEffect(e4)
end
function cm.SRovercfilter(c,tp)
	return c:IsSetCard(0x3534) and c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(cm.SRovercfilter1,tp,LOCATION_HAND,0,1,c) and c:IsPublic() and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_TUNER)
end
function cm.SRovercfilter1(c)
	return c:IsSetCard(0x3534) and c:IsType(TYPE_TUNER) and c:IsAbleToDeckAsCost() and c:IsPublic()
end
function cm.SRoverSPcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(cm.SRovercfilter,tp,LOCATION_HAND,0,1,c,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.SRoverSPop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(tp,cm.SRovercfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,cm.SRovercfilter1,tp,LOCATION_HAND,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.SendtoDeck(g1,nil,2,REASON_COST)
end
function cm.SRoverDrawCon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function cm.SRoverDrawtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.SRoverDrawOp2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.SetPublic(c,lab,rst,rstct)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53702500,lab))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(rst,rstct)
	c:RegisterEffect(e1)
end
function cm.SetPublicGroup(c,g,rst,rstct)
	for pubc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(53702500,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(rst,rstct)
		pubc:RegisterEffect(e1)
	end
end
function cm.AnouguryLink(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.AnouguryReptg)
	e1:SetValue(function(e,c)return c:GetFlagEffect(53728000)>0 end)
	c:RegisterEffect(e1)
end
function cm.AnouguryReptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(function(c,ec)return c:GetDestination()==LOCATION_GRAVE and c:GetReasonCard()==ec and ((c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)) or (c:GetEquipGroup():IsExists(function(c,ec)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,1,nil,c)))end,nil,c)
	if chk==0 then return #g>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>=g:FilterCount(function(c,ec)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,nil,c) end
	for mc in aux.Next(g) do
		local beg=mc:GetEquipGroup():Filter(function(c,ec,tp)return c:IsType(TYPE_UNION) and c:CheckUnionTarget(ec) and aux.CheckUnionEquip(c,ec)end,nil,c,tp)
		if #beg>0 then g:Merge(beg) end
	end
	g=g:Filter(Card.IsType,nil,TYPE_UNION)
	for ec in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		ec:RegisterEffect(e1)
	end
	g:ForEach(Card.RegisterFlagEffect,53728000,RESET_EVENT+0x7e0000,0,1)
	local mg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	for tc in aux.Next(mg) do Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetOperation(cm.AnouguryRstop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.AnouguryRstop2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+53728000)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.AnouguryRstop3)
	Duel.RegisterEffect(e4,tp)
	return true
end
function cm.AnouguryRstop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53728000)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	for ec in aux.Next(g) do
		ec:ResetFlagEffect(53728000)
		ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
	end
	Duel.Destroy(g,REASON_RULE)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53728000,re,r,rp,ep,ev)
	e:Reset()
end
function cm.AnouguryRstop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53728000)>0 end,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		for ec in aux.Next(g) do
			Duel.Equip(tp,ec,c,true,true)
			aux.SetUnionState(ec)
			ec:ResetEffect(EFFECT_INDESTRUCTABLE,RESET_CODE)
			ec:ResetFlagEffect(53728000)
		end
		Duel.EquipComplete()
	end
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.AnouguryRstop3(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.MRSYakuSP(c,num,typ)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.MRSYakuSPcost(num,typ))
	e1:SetTarget(cm.MRSYakuSPtg)
	e1:SetOperation(cm.MRSYakuSPop)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	e1_1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1_1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1_1:SetCode(EVENT_CUSTOM+53711005)
	e1_1:SetRange(LOCATION_HAND)
	e1_1:SetCost(cm.MRSYakuSPcost(num,typ))
	e1_1:SetTarget(cm.MRSYakuSPtg)
	e1_1:SetOperation(cm.MRSYakuSPop)
	c:RegisterEffect(e1_1)
end
function cm.MRSYakuspfilter1(c,e,tp,typ)
	if c:IsLocation(LOCATION_HAND) then
		return c:IsType(typ) and c:IsDiscardable()
	else
		return e:GetHandler():IsOriginalSetCard(0x3538) and e:GetHandler():IsLevel(4) and c:IsAbleToRemove() and c:IsHasEffect(53711009,tp)
	end
end
function cm.MRSYakuspfilter2(c,e,tp)
	return c:IsSetCard(0x3538) and c:IsType(TYPE_SPELL)
end
function cm.MRSYakutimefilter(c,tp)
	return c:IsHasEffect(53711099,tp) and c:GetFlagEffect(53711065)<2
end
function cm.MRSYakufselect(g,ct)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	return aux.dncheck(g2) and #g2<=ct
end
function cm.MRSYakuSPcost(num,typ)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local ltime=0
		local timeg=Duel.GetMatchingGroup(cm.MRSYakutimefilter,tp,LOCATION_MZONE,0,c,tp)
		if #timeg>0 then
			local ttct=0
			for timec in aux.Next(timeg) do
				local timect=timec:GetFlagEffect(53711065)
				ttct=ttct+timect
			end
			ltime=2*#timeg-ttct
		end
		local g=Duel.GetMatchingGroup(cm.MRSYakuspfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp,typ)
		local gdg=Duel.GetMatchingGroup(cm.MRSYakuspfilter2,tp,LOCATION_DECK,0,c,e,tp)
		local ct=gdg:GetClassCount(Card.GetCode)
		if ct>ltime then ct=ltime end
		if chk==0 then return #g+ct>num-1 end
		g:Merge(gdg)
		local g1,g2=Group.CreateGroup(),Group.CreateGroup()
		if ltime>0 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(c:GetOriginalCode(),3))
			local sg=g:SelectSubGroup(tp,cm.MRSYakufselect,false,num,num,ct)
			local dg=sg:Filter(Card.IsLocation,nil,LOCATION_DECK)
			if #dg>0 then
				if #timeg>1 then
					for i=1,#dg do
						Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(c:GetOriginalCode(),5))
						local usedg=timeg:FilterSelect(tp,cm.MRSYakutimefilter,1,1,nil)
						Duel.HintSelection(usedg)
						local usedc=usedg:GetFirst()
						local trg=usedc:GetFlagEffect(53711065)
						usedc:RegisterFlagEffect(53711065,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
					end
				else
					for i=1,#dg do
						local trg=timeg:GetFirst():GetFlagEffect(53711065)
						timeg:GetFirst():RegisterFlagEffect(53711065,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(53711015,trg+3))
					end
				end
			end
			local tc=sg:GetFirst()
			while tc do
				local te=tc:IsHasEffect(53711009,tp)
				if te then g1:AddCard(tc) else g2:AddCard(tc) end
				tc=sg:GetNext()
			end
			if #g1>0 then Duel.Remove(g1,POS_FACEUP,REASON_EFFECT+REASON_REPLACE) end
			if #g2>0 then Duel.SendtoGrave(g2,REASON_COST+REASON_DISCARD) end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local sg=Duel.SelectMatchingCard(tp,cm.MRSYakuspfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,num,num,c,e,tp,typ)
			local tc=sg:GetFirst()
			while tc do
				local te=tc:IsHasEffect(53711009,tp)
				if te then g1:AddCard(tc) else g2:AddCard(tc) end
				tc=sg:GetNext()
			end
			if #g1>0 then Duel.Remove(g1,POS_FACEUP,REASON_EFFECT+REASON_REPLACE) end
			if #g2>0 then Duel.SendtoGrave(g2,REASON_COST+REASON_DISCARD) end
		end
	end
end
function cm.MRSYakuSPtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.MRSYakuSPop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.IsInTable(value, tbl)
	for k,v in ipairs(tbl) do
		if v == value then
		return true
		end
	end
	return false
end
function cm.OnStageText(c,typ)
	if typ==act then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(cm.Stageactop)
		c:RegisterEffect(e1)
	elseif typ==nors then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e2:SetCode(EVENT_SUMMON_SUCCESS)
		e2:SetOperation(cm.Stagesop)
		c:RegisterEffect(e2)
	elseif typ==spes then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetOperation(cm.Stagesop)
		c:RegisterEffect(e3)
	end
end
function cm.Stageactop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),11))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),12))
end
function cm.Stagesop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),13))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),14))
	Duel.Hint(24,0,aux.Stringid(e:GetHandler():GetOriginalCode(),15))
end
function cm.SetDirectlyf(c)
	return c:IsFaceup() and ((c:IsLocation(LOCATION_MZONE) and ((bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)~=0 and (not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanTurnSet()) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable() and c:IsCanTurnSet())) or (bit.band(c:GetOriginalType(),TYPE_SPELL+TYPE_TRAP)==0 and c:IsCanTurnSet()))) or (c:IsLocation(LOCATION_SZONE) and c:IsSSetable(true))) and not (c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE))
end
function cm.SetDirectly(g,e,p)
	for tc in aux.Next(g) do
		tc:CancelToGrave()
		Duel.ChangePosition(tc,POS_FACEDOWN)
		local loc=0
		if tc:IsType(TYPE_FIELD) then loc=LOCATION_FZONE
		elseif tc:IsType(TYPE_SPELL+TYPE_TRAP) then loc=LOCATION_SZONE end
		if tc:GetOriginalType()&TYPE_MONSTER==0 and tc:IsLocation(LOCATION_MZONE) then Duel.MoveToField(tc,p,p,loc,POS_FACEDOWN,false) end
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,p,p,0) end
	end
end
function cm.CardnameBreak(c)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(0xff)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetOperation(cm.Breakcount)
	c:RegisterEffect(e3)
end
function cm.Breakcount(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON) then c53799250.sp=true end
	if not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE) then c53799250.ac=true end
end
function cm.DesertedHartrazLink(c,marker)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1163)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC_G)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.Hartrazlkcon)
	e0:SetOperation(cm.Hartrazlkop(marker))
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
end
function cm.Hartrazlkfilter(c,lc,tp)
	return c:IsFaceup() and c:IsLinkRace(RACE_PYRO) and c:IsCanBeLinkMaterial(lc)
end
function cm.Hartrazlvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then return 1+0x10000*c:GetLink() else return 1 end
end
function cm.Hartrazlcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(cm.Hartrazlvfilter,lc:GetLink(),ct,ct)
end
function cm.Hartrazlkcheck(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.Hartrazlcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(cm.Hartrazlkcheck,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.Hartrazlkcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.Hartrazlkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=1
	local maxc=1
	if ct>maxc then return false end
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and cm.Hartrazlcheck(tp,sg,c,minc,ct) or mg:IsExists(cm.Hartrazlkcheck,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function cm.Hartrazlkop(marker)
	return
	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local mg=Duel.GetMatchingGroup(cm.Hartrazlkfilter,tp,LOCATION_MZONE,0,nil,c,tp)
		local sg2=Group.CreateGroup()
		for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do sg2:AddCard(pe:GetHandler()) end
		local ct=sg2:GetCount()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		sg2:Select(tp,ct,ct,nil)
		local minc=1
		local maxc=1
		for i=ct,maxc-1 do
			local cg=mg:Filter(cm.Hartrazlkcheck,sg2,tp,sg2,mg,c,i,minc,maxc)
			if cg:GetCount()==0 then break end
			local minct=1
			if cm.Hartrazlcheck(tp,sg2,c,minc,i) then
				if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then break end
				minct=0
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
			local g=cg:Select(tp,minct,1,nil)
			if g:GetCount()==0 then break end
			sg2:Merge(g)
		end
		Duel.SendtoGrave(sg2,REASON_MATERIAL+REASON_LINK)
		sg2:KeepAlive()
		local self=Group.FromCards(c)
		self:KeepAlive()
		cm[100]=sg2
		cm[101]=e
		cm[102]=self
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_MOVE)
		e3:SetProperty(EFFECT_FLAG_DELAY)
		e3:SetCondition(cm.adjustcon2)
		e3:SetOperation(cm.adjustop2)
		Duel.RegisterEffect(e3,tp)
		c:SetMaterial(sg2)
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
		e2:SetValue(marker)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		c:RegisterEffect(e2)
		c:CompleteProcedure()
		c:RegisterFlagEffect(53729000,0,0,0)
		Duel.RaiseEvent(e:GetHandler(),EVENT_ADJUST,nil,0,PLAYER_NONE,PLAYER_NONE,0)
	end
end
function cm.adjustcon2(e,tp,eg,ep,ev,re,r,rp)
	return cm[102]:GetFirst():GetFlagEffect(53729000)>0
end
function cm.adjustop2(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(#cm[100])
	local sc=cm[102]:GetFirst()
	Debug.Message(sc:GetCode())
	if sc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.RaiseEvent(cm[100],EVENT_BE_MATERIAL,cm[101],REASON_SYNCHRO,tp,tp,0)
	for tc in aux.Next(cm[100]) do
		Duel.RaiseSingleEvent(tc,EVENT_BE_MATERIAL,cm[101],REASON_SYNCHRO,tp,tp,0)
	end
end
function cm.ORsideLink(c,f,min,max,gf,code)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1166)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=c:GetLink() end
	e1:SetCondition(cm.LinkCondition(f,min,max,gf,code))
	e1:SetTarget(cm.LinkTarget(f,min,max,gf))
	e1:SetOperation(cm.LinkOperation(f,min,max,gf))
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)
end
function cm.LConditionFilter(c,f,lc,e)
	return (c:IsFaceup() or not c:IsOnField() or e:IsHasProperty(EFFECT_FLAG_SET_AVAILABLE))
		and c:IsCanBeLinkMaterial(lc) and (not f or f(c))
end
function cm.LExtraFilter(c,f,lc,tp)
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	if not c:IsCanBeLinkMaterial(lc) or f and not f(c) then return false end
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	for _,te in pairs(le) do
		local tf=te:GetValue()
		local related,valid=tf(te,lc,nil,c,tp)
		if related then return true end
	end
	return false
end
function cm.GetLinkCount(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function cm.GetLinkMaterials(tp,f,lc,e)
	local mg=Duel.GetMatchingGroup(cm.LConditionFilter,tp,LOCATION_MZONE,0,nil,f,lc,e)
	local mg2=Duel.GetMatchingGroup(cm.LExtraFilter,tp,LOCATION_HAND+LOCATION_SZONE,LOCATION_ONFIELD,nil,f,lc,tp)
	if mg2:GetCount()>0 then mg:Merge(mg2) end
	return mg
end
function cm.LCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
	local res1=false
	local res2=true
	for _,te in pairs(le) do
		local f=te:GetValue()
		local related,valid=f(te,lc,mg,c,tp)
		if related then res2=false end
		if related and valid then res1=true end
	end
	return res1 or res2
end
function cm.LUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not cm.LCheckOtherMaterial(c,mg,lc,tp)
end
function cm.LCheckGoal(sg,tp,lc,gf,lmat)
	return sg:CheckWithSumEqual(cm.GetLinkCount,lc:GetLink(),#sg,#sg)
		and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0 and (not gf or gf(sg))
		and not sg:IsExists(cm.LUncompatibilityFilter,1,nil,sg,lc,tp)
		and (not lmat or sg:IsContains(lmat))
end
function cm.LExtraMaterialCount(mg,lc,tp)
	for tc in aux.Next(mg) do
		local le={tc:IsHasEffect(EFFECT_EXTRA_LINK_MATERIAL,tp)}
		for _,te in pairs(le) do
			local sg=mg:Filter(aux.TRUE,tc)
			local f=te:GetValue()
			local related,valid=f(te,lc,sg,tc,tp)
			if related and valid then
				te:UseCountLimit(tp)
			end
		end
	end
end
function cm.LinkCondition(f,minc,maxc,gf,code)
	return  function(e,c,og,lmat,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				if c:GetOriginalCode()~=code then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og:Filter(aux.LConditionFilter,nil,f,c,e)
				else
					mg=aux.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not aux.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return mg:CheckSubGroup(aux.LCheckGoal,minc,maxc,tp,c,gf,lmat)
			end
end
function cm.LinkTarget(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.LConditionFilter,nil,f,c,e)
				else
					mg=cm.GetLinkMaterials(tp,f,c,e)
				end
				if lmat~=nil then
					if not cm.LConditionFilter(lmat,f,c,e) then return false end
					mg:AddCard(lmat)
				end
				local fg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_LMATERIAL)
				Duel.SetSelectedCard(fg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				local sg=mg:SelectSubGroup(tp,cm.LCheckGoal,cancel,minc,maxc,tp,c,gf,lmat)
				if sg then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function cm.LinkOperation(f,minc,maxc,gf)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				cm.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
			end
end
function cm.EnableExtraDeckSummonCountLimit()
	if cm.ExtraDeckSummonCountLimit~=nil then return end
	cm.ExtraDeckSummonCountLimit={}
	cm.ExtraDeckSummonCountLimit[0]=1
	cm.ExtraDeckSummonCountLimit[1]=1
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	ge1:SetOperation(cm.ExtraDeckSummonCountLimitReset)
	Duel.RegisterEffect(ge1,0)
end
function cm.ExtraDeckSummonCountLimitReset()
	cm.ExtraDeckSummonCountLimit[0]=1
	cm.ExtraDeckSummonCountLimit[1]=1
end
function cm.HartrazCheck(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetCost(cm.Hztfcost)
	e0:SetOperation(cm.Hztfop)
	--c:RegisterEffect(e0)
end
function cm.Hztfcost(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK then
		e:SetLabel(1)
		local cg=Duel.GetMatchingGroup(cm.ALCTFFilter,tp,LOCATION_MZONE,0,nil)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	else
		e:SetLabel(0)
		return true
	end
end
function cm.Hztfop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return true end
	e:SetLabel(0)
end
function cm.LinkMonstertoSpell(c,marker)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_LINK_SPELL_KOISHI)
	e2:SetValue(marker)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e2)
end
function cm.CyberNSwitch(c)
	if Duel.GetFlagEffect(0,53727000)>0 then return end
	Duel.RegisterFlagEffect(0,53727000,0,0,0)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(53702500,8))
	Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(53702500,8))
	Duel.SelectYesNo(0,aux.Stringid(53702600,1))
	Duel.SelectYesNo(1,aux.Stringid(53702600,1))
	if Duel.GetFlagEffect(0,53727097)==0 and not Duel.SelectYesNo(0,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(0,53727097,0,0,0) end
	if Duel.GetFlagEffect(1,53727097)==0 and not Duel.SelectYesNo(1,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(1,53727097,0,0,0) end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetOperation(cm.CyberNCheck)
		Duel.RegisterEffect(e1,0)
	end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetOperation(cm.CyberNCheck)
		Duel.RegisterEffect(e2,1)
	end
end
function cm.CyberNCheck(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53702500,9))
	local sel=Duel.SelectOption(tp,aux.Stringid(53727004,6),aux.Stringid(53727005,6),aux.Stringid(53727006,6),aux.Stringid(53727007,6))
	if sel==0 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702601,Duel.GetFlagEffect(0,53727004)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702602,Duel.GetFlagEffect(0,53727037)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702603,Duel.GetFlagEffect(0,53727070)+6))
	elseif sel==1 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702604,Duel.GetFlagEffect(0,53727005)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702605,Duel.GetFlagEffect(0,53727038)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702606,Duel.GetFlagEffect(0,53727071)+5))
	elseif sel==2 then
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702607,Duel.GetFlagEffect(0,53727006)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702608,Duel.GetFlagEffect(0,53727039)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702609,Duel.GetFlagEffect(0,53727072)+5))
	else
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702610,Duel.GetFlagEffect(0,53727007)+1))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702611,Duel.GetFlagEffect(0,53727040)+3))
		Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(53702612,Duel.GetFlagEffect(0,53727073)+5))
	end
end
function cm.CyberNRecord(c)
	if Duel.GetFlagEffect(0,53727099)>0 then return end
	Duel.RegisterFlagEffect(0,53727099,0,0,0)
	Duel.Hint(HINT_OPSELECTED,0,aux.Stringid(53702500,10))
	Duel.Hint(HINT_OPSELECTED,1,aux.Stringid(53702500,10))
	Duel.SelectYesNo(0,aux.Stringid(53702600,0))
	Duel.SelectYesNo(1,aux.Stringid(53702600,0))
	local check0,check1=false,false
	if Duel.GetFlagEffect(0,53727097)==0 and not Duel.SelectYesNo(0,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(0,53727097,0,0,0) end
	if Duel.GetFlagEffect(1,53727097)==0 and not Duel.SelectYesNo(1,aux.Stringid(53702500,13)) then Duel.RegisterFlagEffect(1,53727097,0,0,0) end
	if Duel.SelectYesNo(0,aux.Stringid(53702500,12)) then check0=true end
	if Duel.SelectYesNo(1,aux.Stringid(53702500,12)) then check1=true end
	if not check0 or not check1 then check0,check1=false,false end
	if Duel.GetFlagEffect(0,53727097)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_FREE_CHAIN)
		if check0 then e1:SetOperation(cm.CyberNCode1) else e1:SetOperation(cm.CyberNCode2) end
		Duel.RegisterEffect(e1,0)
	end
	if Duel.GetFlagEffect(1,53727097)>0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_FREE_CHAIN)
		if check1 then e2:SetOperation(cm.CyberNCode1) else e2:SetOperation(cm.CyberNCode2) end
		Duel.RegisterEffect(e2,1)
	end
end
function cm.CyberNCode1(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local max=Duel.GetFlagEffect(0,53727001)
	for i=1,max do
		if Duel.GetFlagEffect(0,53777000+i)>0 then
			local cd=Duel.GetFlagEffectLabel(0,53777000+i)
			if not cm.IsInTable(cd,t) and cd~=114 then table.insert(t,cd) end
		else break end
	end
	local g=Group.CreateGroup()
	for i=1,#t do
		local cre=Duel.CreateToken(1-tp,t[i])
		g:AddCard(cre)
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,14))
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,15))
end
function cm.CyberNCode2(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local max=Duel.GetFlagEffect(0,53727001)
	for i=1,max do
		if Duel.GetFlagEffect(0,53777000+i)>0 then
			local cd=Duel.GetFlagEffectLabel(0,53777000+i)
			if not cm.IsInTable(cd,t) and cd~=114 then table.insert(t,cd) end
		else break end
	end
	local g=Group.CreateGroup()
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,14))
	for i=1,#t do Duel.Hint(HINT_CARD,tp,t[i]) end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(53702500,15))
end
function cm.AllEffectReset(c)
	if Duel.GetFlagEffect(0,53702700)>0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetOperation(cm.AllEffectRstop)
	--e1:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53702700)
	c:RegisterEffect(e1)
	Duel.RegisterFlagEffect(0,53702700,0,0,0)
end
function cm.AllEffectRstop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetFlagEffect(0,53702700)>0 then return end
	--Duel.RegisterFlagEffect(0,53702700,0,0,0)
	local g=Duel.GetMatchingGroup(function(c)return c:GetFlagEffect(53702700)==0 end,0,0xff,0xff,nil)
	if #g==0 then return end
	--Debug.Message(99)
	local reg=Card.RegisterEffect
	local rstg=Duel.GetMatchingGroup(function(c)return c.Snnm_Ef_Rst and c:GetFlagEffect(53702700)==0 end,0,0xff,0xff,nil)
	local rstt={}
	for rstc in aux.Next(rstg) do if not cm.IsInTable(rstc:GetOriginalCode(),rstt) then table.insert(rstt,rstc:GetOriginalCode()) end end
	if cm.IsInTable(53759012,rstt) then
		c53759012[1]=Effect.SetLabelObject
		Effect.SetLabelObject=function(se,le)
			if aux.GetValueType(le)=="Effect" then
				local e1=Effect.CreateEffect(se:GetOwner())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(53759012)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				c53759012[1](e1,se)
				e1:SetTargetRange(1,1)
				Duel.RegisterEffect(e1,0)
			end
			return c53759012[1](se,le)
		end
	end
	local helltaker=Duel.GetMatchingGroup(function(c)return c.AD_Ht and c:GetFlagEffect(53702700)==0 end,0,0xff,0xff,nil)
	if #helltaker>0 then
		AD_Helltaker=Effect.SetLabelObject
		Effect.SetLabelObject=function(se,le)
			if aux.GetValueType(le)=="Effect" then
				local hte1=Effect.CreateEffect(se:GetOwner())
				hte1:SetType(EFFECT_TYPE_FIELD)
				hte1:SetCode(53765050)
				hte1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				AD_Helltaker(hte1,se)
				hte1:SetTargetRange(1,1)
				Duel.RegisterEffect(hte1,0)
			end
			return AD_Helltaker(se,le)
		end
	end
	Duel.RegisterFlagEffect(0,53764007,0,0,0)
	local code=e:GetHandler():GetOriginalCode()
	Card.RegisterEffect=function(sc,se,bool)
		if cm.IsInTable(25000008,rstt) then
		if se:GetCode()==EVENT_BATTLE_DESTROYED then
			local ex=se:Clone()
			ex:SetCode(EVENT_CUSTOM+25000008)
			sc:RegisterEffect(ex)
		end
		if se:GetCode()==EVENT_DESTROYED then
			local ex=se:Clone()
			ex:SetCode(EVENT_CUSTOM+25000008)
			sc:RegisterEffect(ex)
		end
		end
		if cm.IsInTable(25000061,rstt) then
		if se:GetType()&EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_IGNITION+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O~=0 then sc:RegisterFlagEffect(25000061,0,0,0) end
		end
		if cm.IsInTable(25000103,rstt) then
		local pro=se:GetProperty()
		if pro&EFFECT_FLAG_UNCOPYABLE==0 then
			if se:GetType()&(EFFECT_TYPE_IGNITION+EFFECT_TYPE_QUICK_F+EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_ACTIVATE)==0 then
				local con=se:GetCondition()
				if con then
					se:SetCondition(function(e,...)
						if Duel.GetFlagEffect(0,25000103+e:GetHandler():GetOriginalCodeRule())>0 and not e:GetHandler():IsLocation(LOCATION_ONFIELD) then return false end
						return con(e,...)
					end)
				else
					se:SetCondition(function(e,...)
						if Duel.GetFlagEffect(0,25000103+e:GetHandler():GetOriginalCodeRule())>0 and not e:GetHandler():IsLocation(LOCATION_ONFIELD) then return false end
						return true
					end)
				end
			end
		end
		end
		if cm.IsInTable(25000122,rstt) then
		local con=se:GetCondition()
		if con then
			se:SetCondition(function(e,...)
				if e:GetHandler():GetFlagEffect(25000122)>0 then return false end
				return con(e,...)
			end)
		else
			se:SetCondition(function(e,...)
				if e:GetHandler():GetFlagEffect(25000122)>0 then return false end
				return true
			end)
		end
		end
		if cm.IsInTable(53796002,rstt) then
		if se:GetRange()==LOCATION_PZONE and se:GetProperty()&EFFECT_FLAG_UNCOPYABLE==0 then
			_G["c"..sc:GetOriginalCode()].pend_effect=se
		end
		end
		if cm.IsInTable(53796005,rstt) then
		local cd,et=se:GetCode(),se:GetType()
		if (cd==EVENT_SUMMON_SUCCESS or cd==EVENT_FLIP_SUMMON_SUCCESS or cd==EVENT_SPSUMMON_SUCCESS) and et&EFFECT_TYPE_SINGLE and et&(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_TRIGGER_O)~=0 then
			local ex1=Effect.CreateEffect(sc)
			ex1:SetType(EFFECT_TYPE_FIELD)
			ex1:SetCode(EFFECT_ACTIVATE_COST)
			ex1:SetRange(0xff)
			ex1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
			ex1:SetTargetRange(1,1)
			ex1:SetLabelObject(se)
			ex1:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
			ex1:SetCost(function(e,te,tp)return Duel.GetFlagEffect(0,53796005)==0 end)
			sc:RegisterEffect(ex1)
			local x=true
			if sc:IsHasEffect(53796005) then
			for _,i in ipairs{sc:IsHasEffect(53796005)} do
				if i:GetOperation()==se:GetOperation() then x=false end
			end
			end
			if x then
			local ex2=se:Clone()
			ex2:SetCode(EVENT_LEAVE_FIELD)
			sc:RegisterEffect(ex2)
			local ex3=ex1:Clone()
			ex3:SetLabelObject(ex2)
			ex3:SetTarget(function(e,te,tp)return te==e:GetLabelObject()end)
			ex3:SetCost(function(e,te,tp)return Duel.GetFlagEffect(0,53796005)>0 end)
			sc:RegisterEffect(ex3)
			local ex4=Effect.CreateEffect(sc)
			ex4:SetType(EFFECT_TYPE_SINGLE)
			ex4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			ex4:SetCode(53796005)
			ex4:SetRange(0xff)
			ex4:SetOperation(se:GetOperation())
			sc:RegisterEffect(ex4)
			end
		end
		end
		if cm.IsInTable(53799017,rstt) then
		if se:GetType()==EFFECT_TYPE_ACTIVATE then
			local tg=se:GetTarget()
			if tg then
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
					if chkc then return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
					if chk==0 then return tg(e,tp,eg,ep,ev,re,r,rp,chk) end
					tg(e,tp,eg,ep,ev,re,r,rp,chk)
					if Duel.GetFlagEffect(tp,53799017)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			else
				se:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
					if chk==0 then return true end
					if Duel.GetFlagEffect(tp,53799017)>0 then Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK) end
				end)
			end
		end
		end
		reg(sc,se,bool)
	end
	--[[AD_Avoid_RegisterEffect=Duel.RegisterEffect
	Duel.RegisterEffect=function(...)
		return
	end--]]
	for tc in aux.Next(g) do
		if tc.initial_effect then
			local ini=cm.initial_effect
			cm.initial_effect=function() end
			tc:ReplaceEffect(m,0)
			cm.initial_effect=ini
			tc.initial_effect(tc)
		end
	end
	Card.RegisterEffect=reg
	--Duel.RegisterEffect=AD_Avoid_RegisterEffect
	if cm.IsInTable(53759012,rstt) then Effect.SetLabelObject=c53759012[1] end
	if #helltaker>0 then Effect.SetLabelObject=AD_Helltaker end
	Duel.ResetFlagEffect(0,53764007)
	g:ForEach(Card.RegisterFlagEffect,53702700,0,0,0)
	e:Reset()
end
function cm.reni(c,sdes,scat,styp,spro,scod,sran,sct,sht,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetHintTiming(table.unpack(sht))
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.renf(c,spro,scod,sran,stran,scon,stg,sval)
	if scon==0 then scon=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	e1:SetTargetRange(table.unpack(stran))
	e1:SetCondition(scon)
	e1:SetTarget(stg)
	e1:SetValue(sval)
	c:RegisterEffect(e1)
	return e1
end
function cm.renst(c,sdes,scat,styp,spro,scod,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_SINGLE+styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.renft(c,sdes,scat,styp,spro,scod,sran,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(sdes)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_FIELD+styp)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	e1:SetRange(sran)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.recst(c,sct)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	c:RegisterEffect(e1)
	return e1
end
function cm.rest(c,scat,styp,spro,scod,sct,scon,scos,stg,sop)
	if scon==0 then scon=aux.TRUE end
	if scos==0 then scos=aux.TRUE end
	if stg==0 then stg=aux.TRUE end
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(scat)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(spro)
	e1:SetCode(scod)
	if sct~=0 then e1:SetCountLimit(table.unpack(sct)) end
	e1:SetCondition(scon)
	e1:SetCost(scos)
	e1:SetTarget(stg)
	e1:SetOperation(sop)
	c:RegisterEffect(e1)
	return e1
end
function cm.bettertrg(c,scod,code)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.btcount(code))
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_END)
		ge2:SetOperation(cm.btreset(code))
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(scod)
		ge3:SetOperation(cm.bteg(code))
		Duel.RegisterEffect(ge3,0)
end
function cm.btcount(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	_G["c"..code].chain=true
	end
end
function cm.bteg(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local class=_G["c"..code]
	if class.chain==true then
		local g=Group.CreateGroup()
		if class[0] then g=class[0] end
		g:Merge(eg)
		g:KeepAlive()
		class[0]=g
	end
	if class.chain==false then
		Duel.RaiseEvent(eg,EVENT_CUSTOM+code,re,r,rp,ep,ev)
	end
	end
end
function cm.btreset(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local class=_G["c"..code]
	class.chain=false
	if not class[0] then return end
	Duel.RaiseEvent(class[0],EVENT_CUSTOM+code,re,r,rp,ep,ev)
	class[0]=nil
	end
end
function cm.RinnaZone(tp,cg)
	local fdzone=0
	for cc in aux.Next(cg) do
		local cs=cc:GetSequence()
		local cz=1<<cs
		fdzone=fdzone|cz
		local bcz=1<<(cs+16)
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				if val then
					if aux.GetValueType(val)=="function" then
						if tp==0 then
							if cz&val(te)>0 then fdzone=fdzone&(~cz) end
						else
							if bcz&val(te)>0 then fdzone=fdzone&(~cz) end
						end
					else
						if tp==0 then
							if cz&val>0 then fdzone=fdzone&(~cz) end
						else
							if bcz&val>0 then fdzone=fdzone&(~cz) end
						end
					end
				end
			end
		end
	end
	return fdzone
end
function cm.DisMZone(tp)
	local zone=0
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local con=te:GetCondition()
		local val=te:GetValue()
		if (not con or con(te)) then
			if val then if aux.GetValueType(val)=="function" then zone=zone|val(te) else zone=zone|val end end
		end
	end
	if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
	return zone
end
function cm.ReleaseMZone(e,tp,z)
	if tp==1 then z=((z&0xffff)<<16)|((z>>16)&0xffff) end
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local con=te:GetCondition()
		local val=te:GetValue()
		if (not con or con(te)) and val then
			local e1=Effect.CreateEffect(e:GetHandler())
			local res=false
			local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
			local t={}
			for _,i in ipairs(xe) do table.insert(t,i:GetLabelObject()) end
			if not cm.IsInTable(te,t) then res=true end
			if not Duel.IsPlayerAffectedByEffect(tp,53734000) or res then
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(53734000)
				e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e2:SetTargetRange(1,1)
				e2:SetLabelObject(te)
				e2:SetValue(val)
				Duel.RegisterEffect(e2,tp)
			end
			local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
			local eval=0
			for _,i in ipairs(xe) do
				if i:GetLabelObject()==te then eval=i:GetValue() end
			end
			local zone=0
			if aux.GetValueType(eval)=="function" then
				zone=eval(te)
				eval=zone
				e1:SetValue(0)
			else
				zone=eval
				e1:SetValue(1)
			end
			if aux.GetValueType(val)=="function" then val=val(te) end
			if z&val~=0 then
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_ADJUST)
				e1:SetLabel(zone)
				e1:SetLabelObject(te)
				e1:SetOperation(cm.ReturnLock)
				Duel.RegisterEffect(e1,tp)
				val=val&(~z)
				te:SetValue(val)
			end
		end
	end
end
function cm.ReturnLock(e,tp,eg,ep,ev,re,r,rp)
	local zone,te=e:GetLabel(),e:GetLabelObject()
	if not te then
		e:Reset()
		return
	end
	local res=true
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,ke in ipairs(ce) do
		if ke==te then res=false end
	end
	local xe={Duel.IsPlayerAffectedByEffect(tp,53734000)}
	local val=0
	for _,i in ipairs(xe) do
		if i:GetLabelObject()==te then val=i:GetValue() end
	end
	local eval=0
	if e:GetValue()==0 then eval=val(te) else eval=val end
	if zone~=eval or res then
		te:SetValue(val)
		e:Reset()
	end
end
function cm.OjamaAdjust()--Deserted
	f1=Duel.RegisterEffect
	Duel.RegisterEffect=function(e,p)
		if e:GetCode()==EFFECT_DISABLE_FIELD then
			local pro,pro2=e:GetProperty()
			pro=pro|EFFECT_FLAG_PLAYER_TARGET
			e:SetProperty(pro,pro2)
			e:SetTargetRange(1,1)
		end
		f1(e,p)
	end
	f2=Card.RegisterEffect
	Card.RegisterEffect=function(sc,e,bool)
		if e:GetCode()==EFFECT_DISABLE_FIELD then
			local op,range,con=e:GetOperation(),e:GetRange(),e:GetCondition()
			if op then
				local res=false
				local xe={Duel.IsPlayerAffectedByEffect(0,53734099)}
				local t={}
				for _,i in ipairs(xe) do table.insert(t,i:GetLabelObject()) end
				if not cm.IsInTable(e,t) then res=true end
				if not Duel.IsPlayerAffectedByEffect(0,53734099) or res then
					local ex2=Effect.CreateEffect(sc)
					ex2:SetType(EFFECT_TYPE_FIELD)
					ex2:SetCode(53734099)
					ex2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					ex2:SetTargetRange(1,1)
					ex2:SetLabelObject(e)
					if range then ex2:SetRange(range) end
					if con then ex2:SetCondition(con) end
					ex2:SetOperation(op)
					Duel.RegisterEffect(ex2,0)
				end
				local ex=Effect.CreateEffect(sc)
				ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ex:SetCode(EVENT_ADJUST)
				ex:SetRange(range)
				ex:SetLabelObject(e)
				ex:SetOperation(cm.OjamaAdjustop)
				f2(sc,ex)
				e:SetOperation(nil)
			else
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
		end
		f2(sc,e,bool)
	end
end
function cm.OjamaAdjustop(e,tp,eg,ep,ev,re,r,rp)--Deserted
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local te=e:GetLabelObject()
	local con,range,op=0,0,0
	local xe={Duel.IsPlayerAffectedByEffect(0,53734099)}
	local t={}
	for _,i in ipairs(xe) do
		if te==i:GetLabelObject() then
			if i:GetCondition() then con=i:GetCondition() end
			if i:GetRange() then range=i:GetRange() end
			op=i:GetOperation()
		end
	end
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) else e1:SetRange(LOCATION_MZONE) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.GCSpirit(c,gc)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53702600,5))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCondition(cm.GCSpiritcon)
	e1:SetOperation(cm.GCSpiritop(gc))
	c:RegisterEffect(e1)
end
function cm.GCSpiritfil(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevelAbove(5) and not c:IsPublic()
end
function cm.GCSpiritcon(e,tp)
	Duel.DisableActionCheck(true) 
	local dc=Duel.CreateToken(tp,e:GetHandler():GetOriginalCode()+50)
	Duel.DisableActionCheck(false) 
	local ph=Duel.GetCurrentPhase()
	return dc:GetActivateEffect():IsActivatable(tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,53735000,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(cm.GCSpiritfil,tp,LOCATION_HAND,0,1,nil) and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.GCSpiritop(gc)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,53735000)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,cm.GCSpiritfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,cg)
	local pc=cg:GetFirst()
	local ep=Effect.CreateEffect(c)
	ep:SetDescription(aux.Stringid(c:GetOriginalCode(),0))
	ep:SetType(EFFECT_TYPE_SINGLE)
	ep:SetCode(EFFECT_PUBLIC)
	ep:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	ep:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	pc:RegisterEffect(ep)
	pc:RegisterFlagEffect(53735000,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,0,1)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local et=Effect.CreateEffect(c)
	et:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	et:SetRange(LOCATION_SZONE)
	et:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	et:SetLabelObject(pc)
	et:SetCode(EVENT_CUSTOM+c:GetOriginalCode())
	et:SetCost(cm.GCSpiritcost)
	et:SetOperation(cm.GCSpiritac(gc))
	et:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(et)
	c:CreateEffectRelation(et)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(0x20002)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(et)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==te end)
	e1:SetOperation(cm.GCSpiritreset1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.Readjust()
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+c:GetOriginalCode(),re,r,rp,ep,ev)
	end
end
function cm.GCSpiritreset1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then
		rc:CancelToGrave(false)
	end
end
function cm.GCSpiritcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	e:SetType(EFFECT_TYPE_ACTIVATE)
	local c=e:GetHandler()
	c:SetStatus(STATUS_EFFECT_ENABLED,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	e1:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
end
function cm.GCSpiritac(gc)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetTargetRange(1,0)
	e0:SetTarget(function(e,c,sump,sumtype,sumpos,targetp)return c:IsLocation(LOCATION_EXTRA)end)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetLabelObject(e:GetLabelObject())
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCondition(cm.GCSpiritregcon1)
	e1:SetOperation(cm.GCSpiritregop1(gc))
	Duel.RegisterEffect(e1,tp)
	local ex=e1:Clone()
	ex:SetCode(EVENT_MSET)
	ex:SetCondition(cm.GCSpiritregconx)
	c:RegisterEffect(ex)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_NEGATED)
	e2:SetOperation(cm.GCSpiritreset2)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CUSTOM+c:GetOriginalCode())
	e3:SetOperation(cm.GCSpiritreset2)
	e3:SetLabelObject(e2)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
	c:SetStatus(STATUS_EFFECT_ENABLED,true)
	e:Reset()
	end
end
function cm.GCSpiritregcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc,pc=eg:GetFirst(),e:GetLabelObject()
	return pc and tc==pc and tc:GetFlagEffect(53735000)>0 and tc:IsPreviousLocation(LOCATION_HAND) and tc:IsPreviousPosition(POS_FACEUP) and tc:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.GCSpiritregconx(e,tp,eg,ep,ev,re,r,rp)
	local tc,pc=eg:GetFirst(),e:GetLabelObject()
	return pc and tc==pc and tc:GetFlagEffect(53735000)>0 and tc:IsPreviousLocation(LOCATION_HAND) and tc:IsPreviousPosition(POS_FACEUP) and tc:GetMaterialCount()~=0
end
function cm.GCSpiritregop1(gc)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(eg,EVENT_CUSTOM+c:GetOriginalCode(),re,r,rp,ep,ev)
	local ec=eg:GetFirst()
	ec:ResetFlagEffect(53735000)
	ec:RegisterFlagEffect(53735000,RESET_EVENT+0x14c0000,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetLabelObject(ec)
	e1:SetCondition(cm.GCSpiritregcon2)
	e1:SetOperation(cm.GCSpiritregop2(gc))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	e:Reset()
	end
end
function cm.GCSpiritregfil(c,tc)
	return c:IsPreviousLocation(LOCATION_MZONE) and (c:IsSummonType(SUMMON_TYPE_ADVANCE) or c:GetMaterialCount()~=0) and c:IsType(TYPE_SPIRIT) and c:GetFlagEffect(53735000)>0
end
function cm.GCSpiritregcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject() and eg:IsExists(cm.GCSpiritregfil,1,nil,e:GetLabelObject())
end
function cm.GCSpiritregop2(gc)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	eg:GetFirst():ResetFlagEffect(53735000)
	local c=e:GetHandler()
	local e1=gc(c)
	--e1:SetDescription(aux.Stringid(53702600,4))
	--e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,0,0,aux.Stringid(53702600,4))
	e:Reset()
	end
end
function cm.GCSpiritreset2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.GCSpiritN(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53702600,5))
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCountLimit(1,c:GetOriginalCode())
	e1:SetCondition(cm.GCSpiritNcon)
	e1:SetOperation(cm.GCSpiritNop)
	c:RegisterEffect(e1)
end
function cm.GCSpiritNcon(e,tp)
	Duel.DisableActionCheck(true) 
	local dc=Duel.CreateToken(tp,e:GetHandler():GetOriginalCode()+50)
	Duel.DisableActionCheck(false) 
	local ph=Duel.GetCurrentPhase()
	return dc:GetActivateEffect():IsActivatable(tp) and Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function cm.GCSpiritNop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local dc=Duel.CreateToken(tp,c:GetOriginalCode()+50)
	local et=dc:GetActivateEffect()
	et:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	et:SetRange(LOCATION_SZONE)
	et:SetCode(c:GetOriginalCode())
	et:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(et)
	c:CreateEffectRelation(et)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(TYPE_SPELL)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:RegisterEffect(e0,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(et)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return re==te end)
	e1:SetOperation(cm.GCSpiritreset1)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.Readjust()
	Duel.RaiseSingleEvent(c,c:GetOriginalCode(),re,r,rp,ep,ev)
end
function cm.NecroceanSynchro(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1164)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(aux.SynMixCondition(aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99,nil))
	e1:SetTarget(cm.Necroceansyntg(aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99,nil))
	e1:SetOperation(cm.Necroceansynop(aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99,nil))
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0xff)
	e2:SetOperation(cm.NecroceanSLevel)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53752000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetLabelObject(e1)
	e3:SetOperation(cm.LilyLind)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(53752000)
	e4:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e4)
end
function cm.LilyLind(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=e:GetLabelObject()
	se:SetLabel(0)
	c:RegisterFlagEffect(53752000,0,0,0)
	local re1={c:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re2={c:IsHasEffect(EFFECT_SPSUMMON_COST)}
	local re5={Duel.IsPlayerAffectedByEffect(tp,EFFECT_SPSUMMON_COUNT_LIMIT)}
	for _,te1 in pairs(re1) do
		local con=te1:GetCondition()
		if not con then con=aux.TRUE end
		te1:SetCondition(cm.Necroceanchcon(con))
		se:SetLabel(1)
	end
	for _,te2 in pairs(re2) do
		local cost=te2:GetCost()
		if cost and not cost(te2,c,tp) then
			if te2:GetType()==EFFECT_TYPE_SINGLE then
				local con=te2:GetCondition()
				if not con then con=aux.TRUE end
				te2:SetCondition(cm.Necroceanchcon(con))
				se:SetLabel(1)
			end
			if te2:GetType()==EFFECT_TYPE_FIELD then
				local tg=te2:GetTarget()
				if not tg then
					te2:SetTarget(cm.Necroceanchtg(aux.TRUE))
					se:SetLabel(1)
				elseif tg(te2,c,tp) then
					te2:SetTarget(cm.Necroceanchtg(tg))
					se:SetLabel(1)
				end
			end
		end
	end
	for _,te5 in pairs(re5) do
		local val=te5:GetValue()
		local _,a=te5:GetLabel()
		if a==0 then te5:SetLabel(0,val) end
		local sp=Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)
		local _,b=te5:GetLabel()
		if sp==0 then
			te5:SetLabel(1,b)
			te5:SetValue(b)
		end
		val=te5:GetValue()
		local l,_=te5:GetLabel()
		if l==0 then te5:SetLabel(sp+1,b) else
			local n=sp-l+1
			if n==val then
				te5:SetValue(val+1)
				local e1=te5:Clone()
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetReset(RESET_PHASE+PHASE_END)
				local loc=te5:GetRange()
				if loc~=0 then
					e1:SetLabelObject(te5)
					te5:GetHandler():RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_ADJUST)
					e2:SetLabel(loc,b)
					e2:SetLabelObject(e1)
					e2:SetOperation(cm.Necroceanreset1)
					Duel.RegisterEffect(e2,tp)
				else Duel.RegisterEffect(e1,te5:GetOwnerPlayer()) end
			end
		end
	end
	local re3={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_SPECIAL_SUMMON)}
	local re4={Duel.IsPlayerAffectedByEffect(tp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
	for _,v in pairs(re4) do table.insert(re3,v) end
	for _,te3 in pairs(re3) do
		local tg=te3:GetTarget()
		if not tg then
			te3:SetTarget(cm.Necroceanchtg3(aux.TRUE))
			se:SetLabel(1)
		elseif tg(te3,c,tp,SUMMON_TYPE_SYNCHRO,POS_FACEUP,tp,se) then
			te3:SetTarget(cm.Necroceanchtg3(tg))
			se:SetLabel(1)
		end
	end
	c:ResetFlagEffect(53752000)
end
function cm.Necroceanchcon(_con)
	return function(e,...)
			   local x=e:GetHandler()
			   if x:IsHasEffect(53752000) and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,x:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and x:GetFlagEffect(53752000)<1 then return false end
			   return _con(e,...)
		   end
end
function cm.Necroceanreset1(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetLabelObject():GetHandler()
	local te=e:GetLabelObject():GetLabelObject()
	local loc,v=e:GetLabel()
	if x:GetLocation()&loc==0 then
		te:SetLabel(0,v)
		te:SetValue(v)
		e:GetLabelObject():Reset()
		e:Reset()
	end
end
function cm.Necroceanchtg3(_tg)
	return function(e,c,sump,sumtype,sumpos,targetp,se)
			   if c:IsHasEffect(53752000) and se:GetHandler()==c and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and c:GetFlagEffect(53752000)<1 then return false end
			   return _tg(e,c,sump,sumtype,sumpos,targetp,se)
		   end
end
function cm.Necroceanchtg(_tg)
	return function(e,c,...)
			   if c:IsHasEffect(53752000) and Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,c:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and c:GetFlagEffect(53752000)<1 then return false end
			   return _tg(e,c,...)
		   end
end
function cm.NecroceanSLevel(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53752000)>0 then return end
	Duel.RegisterFlagEffect(0,53752000,0,0,0)
	func1=Card.IsCanBeSynchroMaterial
	Card.IsCanBeSynchroMaterial=function(tc,sc,...)
		if sc and sc.NecroceanSyn then
			if tc:IsLocation(LOCATION_GRAVE) and tc:IsLevel(0) and tc:GetControler()==sc:GetControler() and not sc.NecroceanKythra then return false end
			local res=Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,sc:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil)
			if tc:IsLocation(LOCATION_ONFIELD) and tc:GetControler()~=sc:GetControler() and not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) and not res then return false end
			if not sc.GuyWildCard then
				if not (tc:IsAbleToRemove() or res) then return false end
				if tc:IsStatus(STATUS_FORBIDDEN) then return false end
				if tc:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL) then return false end
			end
			return true
		else
			return func1(tc,sc,...)
		end
	end
	func2=Card.GetSynchroLevel
	Card.GetSynchroLevel=function(tc,sc)
		if sc and sc.NecroceanSyn and ((tc:IsLocation(LOCATION_GRAVE) and tc:IsLevel(0) and (sc.GuyWildCard or sc.NecroceanKythra or tc:GetControler()~=sc:GetControler())) or (Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,sc:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) and tc:IsLocation(LOCATION_ONFIELD) and tc:GetControler()~=sc:GetControler() and (tc:IsFacedown() or tc:IsLevel(0)))) then
			return 1
		else
			return func2(tc,sc)
		end
	end
	func3=aux.GetSynMaterials
	aux.GetSynMaterials=function(tp,sc)
		local exg=Group.CreateGroup()
		if sc and sc.NecroceanSyn then
			local mg3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
			if not mg3:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) then
				exg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,sc)
			end
			if Duel.IsExistingMatchingCard(function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,sc:GetControler(),LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,nil) then
				local exg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,0,LOCATION_ONFIELD,nil,sc)
				exg:Merge(exg2)
			end
		end
		return Group.__add(func3(tp,sc),exg)
	end
	func4=aux.SynMixCheckGoal
	aux.SynMixCheckGoal=function(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		if ct<minc then return false end
		local g=sg:Clone()
		g:Merge(sg1)
		if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
		if gc and not gc(g) then return false end
		if smat and not g:IsContains(smat) then return false end
		if not aux.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
		if not (g:IsExists(Card.IsLocation,1,nil,LOCATION_GRAVE) and syncard and syncard.NecroceanSyn) then
			if not g:CheckWithSumEqual(Card.GetSynchroLevel,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard) and (not g:IsExists(Card.IsHasEffect,1,nil,89818984) or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,syncard:GetLevel(),g:GetCount(),g:GetCount(),syncard)) then return false end
		end
		local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
		local hct=hg:GetCount()
		if hct>0 and not mgchk then
			local found=false
			for c in aux.Next(g) do
				local he,hf,hmin,hmax=c:GetHandSynchro()
				if he then
					found=true
					if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he,syncard) then return false end
					if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
				end
			end
			if not found then return false end
		end
		for c in aux.Next(g) do
			local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
			if le then
				local lct=g:GetCount()-1
				if lloc then
					local llct=g:FilterCount(Card.IsLocation,c,lloc)
					if llct~=lct then return false end
				end
				if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
				if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
			end
		end
		return true
	end
end
--[[function cm.Necroceansyncon(f1,f2,f3,f4,minc,maxc,gc,check,wild_check)
	return  function(e,c,smat,mg1,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local tp=c:GetControler()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=aux.GetSynMaterials(tp,c,e,check)
				end
				if smat~=nil then mg:AddCard(smat) end
				return mg:IsExists(cm.NecroceanSynMixFilter1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk)
			end
end
function cm.Necroceansyncon2(...)--deserted
	local f1=aux.GetSynMaterials
	local f2=aux.SynMixFilter1
	aux.GetSynMaterials=cm.NecroceanGetSynMaterials
	aux.SynMixFilter1=cm.NecroceanSynMixFilter1
	local res=aux.SynMixCondition(aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99,nil)(...)
	aux.GetSynMaterials=f1
	aux.SynMixFilter1=f2
	return res
end--]]
function cm.Necroceansyntg(f1,f2,f3,f4,minc,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg1,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				local res=false
				while true do
				local g=Group.CreateGroup()
				local mg
				local mgchk=false
				if mg1 then
					mg=mg1
					mgchk=true
				else
					mg=aux.GetSynMaterials(tp,c,e)
				end
				if smat~=nil then mg:AddCard(smat) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
				local c1=mg:FilterSelect(tp,aux.SynMixFilter1,1,1,nil,f1,f2,f3,f4,minc,maxc,c,mg,smat,gc,mgchk):GetFirst()
				g:AddCard(c1)
				if f2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local c2=mg:FilterSelect(tp,aux.SynMixFilter2,1,1,c1,f2,f3,f4,minc,maxc,c,mg,smat,c1,gc,mgchk):GetFirst()
					g:AddCard(c2)
					if f3 then
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
						local c3=mg:FilterSelect(tp,aux.SynMixFilter3,1,1,Group.FromCards(c1,c2),f3,f4,minc,maxc,c,mg,smat,c1,c2,gc,mgchk):GetFirst()
						g:AddCard(c3)
					end
				end
				local g4=Group.CreateGroup()
				for i=0,maxc-1 do
					local mg2=mg:Clone()
					if f4 then
						mg2=mg2:Filter(f4,g,c)
					else
						mg2:Sub(g)
					end
					local cg=mg2:Filter(aux.SynMixCheckRecursive,g4,tp,g4,mg2,i,minc,maxc,c,g,smat,gc,mgchk)
					if cg:GetCount()==0 then break end
					local minct=1
					if aux.SynMixCheckGoal(tp,g4,minc,i,c,g,smat,gc,mgchk) then
						minct=0
					end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
					local tg=cg:Select(tp,minct,1,nil)
					if tg:GetCount()==0 then break end
					g4:Merge(tg)
				end
				g:Merge(g4)
				if g:GetCount()>0 then
					if not g:CheckWithSumEqual(Card.GetSynchroLevel,c:GetLevel(),g:GetCount(),g:GetCount(),c) and (not g:IsExists(Card.IsHasEffect,1,nil,89818984) or not g:CheckWithSumEqual(aux.GetSynchroLevelFlowerCardian,c:GetLevel(),g:GetCount(),g:GetCount(),c)) then
						if not Duel.SelectYesNo(tp,aux.Stringid(53702600,5)) then break end
					else
						g:KeepAlive()
						e:SetLabelObject(g)
						res=true
						break
					end
				else break end
				end
				return res
			end
end
--[[function cm.Necroceansyntg2(...)-
	local f1=aux.GetSynMaterials
	local f2=aux.SynMixFilter1
	local f3=aux.SynMixFilter2
	local f4=aux.SynMixFilter3
	local f5=aux.SynMixFilter4
	local f6=aux.SynMixCheck
	local f7=aux.SynMixCheckRecursive
	local f8=aux.SynMixCheckGoal
	aux.GetSynMaterials=cm.NecroceanGetSynMaterials
	aux.SynMixFilter1=cm.NecroceanSynMixFilter1
	aux.SynMixFilter2=cm.NecroceanSynMixFilter2
	aux.SynMixFilter3=cm.NecroceanSynMixFilter3
	aux.SynMixFilter4=cm.NecroceanSynMixFilter4
	aux.SynMixCheck=cm.NecroceanSynMixCheck
	aux.SynMixCheckRecursive=cm.NecroceanSynMixCheckRecursive
	aux.SynMixCheckGoal=cm.NecroceanSynMixCheckGoal
	local res=aux.SynMixTarget(aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99,nil)(...)
	aux.GetSynMaterials=f1
	aux.SynMixFilter1=f2
	aux.SynMixFilter2=f3
	aux.SynMixFilter3=f4
	aux.SynMixFilter4=f5
	aux.SynMixCheck=f6
	aux.SynMixCheckRecursive=f7
	aux.SynMixCheckGoal=f8
	return res
end--]]
function cm.Necroceansynop(f1,f2,f3,f4,minct,maxc,gc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				local rg=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				local pos,rsn=POS_FACEUP,0
				if c.GuyWildCard then
					pos=POS_FACEDOWN
					rsn=REASON_RULE
				end
				local res=false
				if g:IsExists(function(c,tp)return c:IsControler(1-tp) and c:IsLocation(LOCATION_ONFIELD) and not c:IsHasEffect(EFFECT_SYNCHRO_MATERIAL)end,1,nil,tp) then res=true end
				if g:IsExists(aux.NOT(Card.IsAbleToRemove),1,nil) then
					rsn=REASON_RULE
					res=true
				end
				Duel.Remove(rg,pos,REASON_MATERIAL+REASON_SYNCHRO+rsn)
				Duel.SendtoGrave(Group.__sub(g,rg),REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()
				if e:GetLabel()==1 or res then
					local g=Duel.SelectMatchingCard(tp,function(c)return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:IsOriginalCodeRule(53752019) and c:IsAbleToGrave()end,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil)
					if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT) end
				end
			end
end
--[[function cm.Necroceansfilter(c,syncard,e,tp,check,wild_check)
	if not wild_check then
		if c:IsHasEffect(EFFECT_CANNOT_REMOVE) then return false end
		local re1={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_REMOVE)}
		local res=true
		for _,v1 in ipairs(re1) do
			local tg=v1:GetTarget()
			if not tg or tg(v1,c,tp,REASON_MATERIAL+REASON_SYNCHRO,e) then res=false end
		end
		if not res then return false end
	end
	local flag=c:IsLevel(0)
	if c:IsControler(tp) and flag and not check then return false end
	if not wild_check then
		local re2={c:IsHasEffect(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)}
		for _,v2 in ipairs(re2) do
			local val=v2:GetValue()
			if aux.GetValueType(val)=="number" then flag=false elseif val(v2,c) then flag=false end
		end
	end
	return c:IsCanBeSynchroMaterial(syncard) or flag
end
function cm.NecroceanGetSynMaterials(tp,syncard,e,check,wild_check)
	local mg=Duel.GetMatchingGroup(aux.SynMaterialFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,syncard)
	if mg:IsExists(Card.GetHandSynchro,1,nil) then
		local mg2=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND,0,nil,syncard)
		if mg2:GetCount()>0 then mg:Merge(mg2) end
	end
	local mg3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if not mg3:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) then
		local exg=Duel.GetMatchingGroup(cm.Necroceansfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,syncard,e,tp,check,wild_check)
		if exg:GetCount()>0 then mg:Merge(exg) end
	end
	return mg
end
function cm.NecroceanSynMixFilter1(c,f1,f2,f3,f4,minc,maxc,syncard,mg,smat,gc,mgchk)
	return (not f1 or f1(c,syncard)) and mg:IsExists(cm.NecroceanSynMixFilter2,1,c,f2,f3,f4,minc,maxc,syncard,mg,smat,c,gc,mgchk)
end
function cm.NecroceanSynMixFilter2(c,f2,f3,f4,minc,maxc,syncard,mg,smat,c1,gc,mgchk)
	if f2 then
		return f2(c,syncard,c1)
			and (mg:IsExists(cm.NecroceanSynMixFilter3,1,Group.FromCards(c1,c),f3,f4,minc,maxc,syncard,mg,smat,c1,c,gc,mgchk)
				or minc==0 and cm.NecroceanSynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,nil,nil,gc,mgchk))
	else
		return mg:IsExists(cm.NecroceanSynMixFilter4,1,c1,f4,minc,maxc,syncard,mg,smat,c1,nil,nil,gc,mgchk)
	end
end
function cm.NecroceanSynMixFilter3(c,f3,f4,minc,maxc,syncard,mg,smat,c1,c2,gc,mgchk)
	if f3 then
		return f3(c,syncard,c1,c2)
			and (mg:IsExists(cm.NecroceanSynMixFilter4,1,Group.FromCards(c1,c2,c),f4,minc,maxc,syncard,mg,smat,c1,c2,c,gc,mgchk)
				or minc==0 and cm.NecroceanSynMixFilter4(c,nil,1,1,syncard,mg,smat,c1,c2,nil,gc,mgchk))
	else
		return mg:IsExists(cm.NecroceanSynMixFilter4,1,Group.FromCards(c1,c2),f4,minc,maxc,syncard,mg,smat,c1,c2,nil,gc,mgchk)
	end
end
function cm.NecroceanSynMixFilter4(c,f4,minc,maxc,syncard,mg1,smat,c1,c2,c3,gc,mgchk)
	if f4 and not f4(c,syncard,c1,c2,c3) then return false end
	local sg=Group.FromCards(c1,c)
	sg:AddCard(c1)
	if c2 then sg:AddCard(c2) end
	if c3 then sg:AddCard(c3) end
	local mg=mg1:Clone()
	if f4 then
		mg=mg:Filter(f4,sg,syncard)
	else
		mg:Sub(sg)
	end
	return cm.NecroceanSynMixCheck(mg,sg,minc-1,maxc-1,syncard,smat,gc,mgchk)
end
function cm.NecroceanSynMixCheck(mg,sg1,minc,maxc,syncard,smat,gc,mgchk)
	local tp=syncard:GetControler()
	local sg=Group.CreateGroup()
	if minc<=0 and cm.NecroceanSynMixCheckGoal(tp,sg1,0,0,syncard,sg,smat,gc,mgchk) then return true end
	if maxc==0 then return false end
	return mg:IsExists(cm.NecroceanSynMixCheckRecursive,1,nil,tp,sg,mg,0,minc,maxc,syncard,sg1,smat,gc,mgchk)
end
function cm.NecroceanSynMixCheckRecursive(c,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.NecroceanSynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
		or (ct<maxc and mg:IsExists(cm.NecroceanSynMixCheckRecursive,1,sg,tp,sg,mg,ct,minc,maxc,syncard,sg1,smat,gc,mgchk))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.NecroceanGetSynchroLevel(c,syncard,wild_check)
	local slv=c:GetSynchroLevel(syncard)
	if c:IsLocation(LOCATION_GRAVE) and c:IsLevel(0) then slv=1 end
	return slv
end
function cm.NecroceanGetSynchroLevelFlowerCardian(c,syncard)
	local slv=2
	--if c:IsSynchroType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_GRAVE) then slv=1 end
	return slv
end
function cm.NecroceanSynMixCheckGoal(tp,sg,minc,ct,syncard,sg1,smat,gc,mgchk)
	if ct<minc then return false end
	local g=sg:Clone()
	g:Merge(sg1)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if gc and not gc(g) then return false end
	if smat and not g:IsContains(smat) then return false end
	if not Auxiliary.MustMaterialCheck(g,tp,EFFECT_MUST_BE_SMATERIAL) then return false end
	local hg=g:Filter(Card.IsLocation,nil,LOCATION_HAND)
	local hct=hg:GetCount()
	if hct>0 and not mgchk then
		local found=false
		for c in aux.Next(g) do
			local he,hf,hmin,hmax=c:GetHandSynchro()
			if he then
				found=true
				if hf and hg:IsExists(aux.SynLimitFilter,1,c,hf,he,syncard) then return false end
				if (hmin and hct<hmin) or (hmax and hct>hmax) then return false end
			end
		end
		if not found then return false end
	end
	for c in aux.Next(g) do
		local le,lf,lloc,lmin,lmax=c:GetTunerLimit()
		if le then
			local lct=g:GetCount()-1
			if lloc then
				local llct=g:FilterCount(Card.IsLocation,c,lloc)
				if llct~=lct then return false end
			end
			if lf and g:IsExists(aux.SynLimitFilter,1,c,lf,le,syncard) then return false end
			if (lmin and lct<lmin) or (lmax and lct>lmax) then return false end
		end
	end
	return true
end--]]
--[[function cm.NecroceanSynchro(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.NonTuner(nil),nil,nil,0,99)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(0xff)
	e5:SetOperation(cm.NecroceanSLevel)
	e5:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53752000)
	c:RegisterEffect(e5)
end
function cm.NecroceanSLevel(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53752000)>0 then return end
	Duel.RegisterFlagEffect(0,53752000,0,0,0)
	func1=Card.IsCanBeSynchroMaterial
	Card.IsCanBeSynchroMaterial=function(tc,sc,...)
		if tc:IsLocation(LOCATION_GRAVE) and sc and sc.NecroceanSyn and sc.GuyWildCard then
			if sc and tc:IsLocation(LOCATION_MZONE) and tc:GetControler()~=sc:GetControler() and not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then return false end
			return true
		else
			return func1(tc,sc,...)
		end
	end
	func2=Card.GetSynchroLevel
	Card.GetSynchroLevel=function(tc,sc)
		if sc and sc.NecroceanSyn and sc.GuyWildCard and tc:IsLocation(LOCATION_GRAVE) and tc:IsLevel(0) then
			return 1
		else
			return func2(tc,sc)
		end
	end
	func3=aux.GetSynMaterials
	aux.GetSynMaterials=function(tp,sc)
		local exg=Group.CreateGroup()
		if sc and sc.NecroceanSyn and sc.GuyWildCard then
			local mg3=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
			if not mg3:IsExists(aux.NOT(Card.IsType),1,nil,TYPE_TUNER) then
				exg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,sc)
			end
		end
		return Group.__add(func3(tp,sc),exg)
	end
end--]]
function Intersection(t1, t2)
	local ret = {}
	for k, v1 in pairs(t1) do
		local equal = false
		for k, v2 in pairs(t2) do
			if v1 == v2 then
				equal = true
				break
			end
		end
		if equal then
			table.insert(ret, v1)
		end
	end
	return ret
end
EFFECT_MULTI_SUMMONABLE=53753099
function cm.MultiDual(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DUAL_SUMMONABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0xff)
	e2:SetOperation(cm.MultiDualCheck)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53753000)
	c:RegisterEffect(e2)
	--[[local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_COST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.MultiDualReset)
	c:RegisterEffect(e3)--]]
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MULTI_SUMMONABLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e4)
end
function cm.MultiDualReset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=c:GetFlagEffect(53753000)
	if not c:IsHasEffect(53753050) then cm.MultiDualLabel(c,ct) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.MultiDualSum)
	c:RegisterEffect(e1)
end
function cm.MultiDualSum(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local c=e:GetHandler()
	c:ResetEffect(EFFECT_DUAL_STATUS,RESET_CODE)
end
function cm.MultiDualCheck(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53753099)>0 then return end
	Duel.RegisterFlagEffect(0,53753099,0,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_COST)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(function(e,c,tp)
		e:SetLabelObject(c)
		return true 
	end)
	e1:SetOperation(cm.MultiDualReset)
	Duel.RegisterEffect(e1,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetOperation(cm.DualSummonableCheck)
	Duel.RegisterEffect(e3,tp)
	func1=Card.IsDualState
	Card.IsDualState=function(tc)
		return cm.IsHasDualStatus(tc) or cm.MultiDualCount(tc)==1
	end
	func2=Card.EnableDualState
	Card.EnableDualState=function(tc)
		tc:ResetFlagEffect(53753000)
		cm.MultiDualLabel(tc,0)
	end
end
function cm.MultiDualLabel(c,ct)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE)
	if ct<10 then
		ex:SetDescription(aux.Stringid(53702600,ct+6))
		ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	else ex:SetProperty(EFFECT_FLAG_SINGLE_RANGE) end
	ex:SetCode(EFFECT_FLAG_EFFECT+53753000)
	ex:SetRange(LOCATION_MZONE)
	ex:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(ex)
end
function cm.DualSummonableCheck(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil,EFFECT_DUAL_SUMMONABLE)
	for tc in aux.Next(g) do
		local le={tc:IsHasEffect(EFFECT_DUAL_SUMMONABLE)}
		for _,v in pairs(le) do
			local con=v:GetCondition()
			if not con then con=aux.TRUE end
			v:SetCondition(cm.Dualchcon(con))
		end
	end
	g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil,EFFECT_DUAL_STATUS)
	for tc in aux.Next(g) do
		local le={tc:IsHasEffect(EFFECT_DUAL_STATUS)}
		for _,v in pairs(le) do
			if v:GetOwner()~=tc then
				local e1=v:Clone()
				e1:SetCode(53753050)
				if v:GetType()&EFFECT_TYPE_FIELD~=0 and (not v:GetRange() or v:GetRange()==0) then Duel.RegisterEffect(e1,v:GetOwnerPlayer()) else v:GetOwner():RegisterEffect(e1,true) end
				v:Reset()
			end
		end
	end
	g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil,53753050)
	for tc in aux.Next(g) do
		local ct=tc:GetFlagEffect(53753000)
		tc:ResetFlagEffect(53753000)
		for i=1,ct do tc:RegisterFlagEffect(53753098,RESET_EVENT+RESETS_STANDARD,0,0) end
	end
	g=Duel.GetMatchingGroup(aux.NOT(Card.IsHasEffect),tp,LOCATION_MZONE,LOCATION_MZONE,nil,53753050)
	for tc in aux.Next(g) do
		local ct=tc:GetFlagEffect(53753098)
		tc:ResetFlagEffect(53753098)
		for i=0,ct-1 do cm.MultiDualLabel(tc,i) end
	end
end
function cm.Dualchcon(_con)
	return function(e,...)
			   local x=e:GetHandler()
			   if (cm.MultiDualCount(x)>0 or x:IsHasEffect(53753050)) and not x:IsHasEffect(EFFECT_MULTI_SUMMONABLE) then return false end
			   return _con(e,...)
		   end
end
function cm.DualState(e_or_c)
	if aux.GetValueType(e_or_c)=="Effect" then e_or_c=e_or_c:GetHandler() end
	return cm.IsHasDualStatus(e_or_c) or cm.MultiDualCount(e_or_c)>0
end
function cm.TerState(e_or_c)
	if aux.GetValueType(e_or_c)=="Effect" then e_or_c=e_or_c:GetHandler() end
	return cm.MultiDualCount(e_or_c)>1
end
function cm.IsTerState(e_or_c)
	if aux.GetValueType(e_or_c)=="Effect" then e_or_c=e_or_c:GetHandler() end
	return cm.MultiDualCount(e_or_c)==2
end
function cm.QuadState(e_or_c)
	if aux.GetValueType(e_or_c)=="Effect" then e_or_c=e_or_c:GetHandler() end
	return cm.MultiDualCount(e_or_c)>2
end
function cm.IsQuadState(e_or_c)
	if aux.GetValueType(e_or_c)=="Effect" then e_or_c=e_or_c:GetHandler() end
	return cm.MultiDualCount(e_or_c)==3
end
function cm.MultiDualCount(c)
	local ct=c:GetFlagEffect(53753000)+Duel.GetFlagEffect(c:GetControler(),53753000)
	if ct==0 and cm.IsHasDualStatus(c) then ct=1 end
	if c:IsDisabled() then ct=0 end
	return ct
end
function cm.multi_summon_count(mg)
	local ct=0
	for tc in aux.Next(mg) do
		local ctc=SNNM.MultiDualCount(tc)
		if tc:IsDualState() then ctc=1 end
		ct=ct+ctc
	end
	return ct
end
function cm.multi_summon_count_down(c)
	if cm.IsHasDualStatus(c) then
		c:ResetEffect(EFFECT_DUAL_STATUS,RESET_CODE)
		c:ResetEffect(53753050,RESET_CODE)
	else
		local ct=c:GetFlagEffect(53753000)
		c:ResetFlagEffect(53753000)
		for i=0,ct-2 do SNNM.MultiDualLabel(c,i) end
	end
end
function cm.IsHasDualStatus(c)
	return c:IsHasEffect(EFFECT_DUAL_STATUS) or c:IsHasEffect(53753050)
end
function cm.AlmondimenLevel4(c,atk)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.DualState)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.TerState)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCondition(cm.QuadState)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(cm.Almondimensumtg)
	e4:SetOperation(cm.Almondimensumop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(cm.Almondimencon)
	e5:SetOperation(cm.Almondimenatk(atk))
	c:RegisterEffect(e5)
	return e1,e2,e3,e4,e5
end
function cm.Almondimensumfilter(c)
	return c:IsType(TYPE_DUAL) and c:IsSummonable(true,nil)
end
function cm.Almondimensumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.Almondimensumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.Almondimensumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.Almondimensumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.Almondimencon(e,tp,eg,ep,ev,re,r,rp)
	return cm.DualState(e:GetHandler())
end
function cm.Almondimenatk(atk)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function cm.GelidimenFilpSummon(c,cost,op)
	if c:GetFlagEffect(53754000)<1 then
		c:RegisterFlagEffect(53754000,0,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_FLIPSUMMON_COST)
		e1:SetTargetRange(0xff,0xff)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetLabelObject(c)
		e1:SetTarget(function(e,c,tp)return c==e:GetLabelObject()end)
		e1:SetCost(cost)
		e1:SetOperation(op)
		Duel.RegisterEffect(e1,0)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0xff)
	e2:SetOperation(cm.GelidimenCheck)
	c:RegisterEffect(e2)
end
function cm.GelidimenCheck(e,tp,eg,ep,ev,re,r,rp)
	local le={e:GetHandler():IsHasEffect(EFFECT_FLIPSUMMON_COST)}
	for _,v in pairs(le) do
		if v:GetOwner():GetFlagEffect(53754000)>0 then
			local e1=v:Clone()
			v:Reset()
			Duel.RegisterEffect(e1,e:GetHandler():GetControler())
		end
	end
end
function cm.RabbitTeam(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(cm.RabbitTeamspcon)
	e1:SetOperation(cm.RabbitTeamspop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(0xff)
	e2:SetOperation(cm.RabbitTeamCheck)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_DUEL+53755000)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.RabbitTeamrecon)
	e3:SetValue(LOCATION_DECK)
	c:RegisterEffect(e3)
end
function cm.RabbitTeamspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local num=53755000
	for i=1,4 do if c["Rabbit_Team_Number_"..i] then num=num+i end end
	return Duel.GetFlagEffect(tp,num)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.RabbitTeamspop(e,tp,eg,ep,ev,re,r,rp,c)
	local num=53755000
	for i=1,4 do if c["Rabbit_Team_Number_"..i] then num=num+i end end
	local ct=Duel.GetFlagEffect(tp,num)
	Duel.ResetFlagEffect(tp,num)
	for i=1,ct-1 do Duel.RegisterFlagEffect(tp,num,RESET_PHASE+PHASE_END,0,1) end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_NEGATED)
	e2:SetOperation(cm.RTreset1)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetLabelObject(e2)
	e3:SetOperation(cm.RTreset2)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+53728000)
	e4:SetLabelObject(e3)
	e4:SetOperation(cm.RTreset3)
	Duel.RegisterEffect(e4,tp)
end
function cm.RTreset1(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53728000,re,r,rp,ep,ev)
	e:Reset()
end
function cm.RTreset2(e,tp,eg,ep,ev,re,r,rp)
	Duel.ShuffleDeck(tp)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+53755008,re,r,rp,ep,ev)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.RTreset3(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject() then e:GetLabelObject():Reset() end
	e:Reset()
end
function cm.RabbitTeamrecon(e)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=c:GetControler()
end
function cm.RabbitTeamCheck(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(0,53755000)>0 then return end
	Duel.RegisterFlagEffect(0,53755000,0,0,0)
	cm[55]=Duel.ConfirmDecktop
	Duel.ConfirmDecktop=function(tp,ct)
		if ct<5 then
			local g=Duel.GetDecktopGroup(tp,ct)
			local t={}
			for tc in aux.Next(g) do for i=1,4 do if tc["Rabbit_Team_Number_"..i] and not cm.IsInTable(i,t) then table.insert(t,i) end end end
			for _,v in ipairs(t) do Duel.RegisterFlagEffect(tp,53755000+v,RESET_PHASE+PHASE_END,0,1) end
		end
		return cm[55](tp,ct)
	end
end
function cm.Global_in_Initial_Reset(c,t)
	local le={Duel.IsPlayerAffectedByEffect(0,53702800)}
	for _,v in pairs(le) do
		if v:GetOwner()==c then
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	for _,v in pairs(t) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(53702800)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(v)
		Duel.RegisterEffect(e1,0)
	end
end
function cm.DressamAdjust(c)
	if not Doremy_Adjust then
		Doremy_Adjust=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SUMMON_COST)
		ge1:SetTargetRange(0xff,0xff)
		ge1:SetOperation(cm.Dressamcheckop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EFFECT_SPSUMMON_COST)
		Duel.RegisterEffect(ge2,0)
		local ge2_1=ge1:Clone()
		ge2_1:SetCode(EFFECT_MSET_COST)
		Duel.RegisterEffect(ge2_1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_SUMMON_SUCCESS)
		ge3:SetOperation(cm.Dressamsreset)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge3:Clone()
		ge4:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge4,0)
		local ge4_1=ge3:Clone()
		ge4_1:SetCode(EVENT_MSET)
		Duel.RegisterEffect(ge4_1,0)
		local ge5=ge3:Clone()
		ge5:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(ge5,0)
		local ge6=ge3:Clone()
		ge6:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(ge6,0)
		local ge7=Effect.CreateEffect(c)
		ge7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge7:SetCode(EVENT_CHAIN_SOLVING)
		ge7:SetOperation(cm.Dressamcount)
		Duel.RegisterEffect(ge7,0)
		local ge8=Effect.CreateEffect(c)
		ge8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge8:SetCode(EVENT_CHAIN_SOLVED)
		ge8:SetOperation(cm.Dressamcreset)
		Duel.RegisterEffect(ge8,0)
	end
end
function cm.Dressamcheckop(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=true
end
function cm.Dressamsreset(e,tp,eg,ep,ev,re,r,rp)
	if Doremy_Token_Check then return end
	Doremy_Summoning_Check=false
end
function cm.Dressamcount(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=true
end
function cm.Dressamcreset(e,tp,eg,ep,ev,re,r,rp)
	Doremy_Chain_Solving_Check=false
end
function cm.DressamLocCheck(tp,usep,z)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,usep,LOCATION_REASON_TOFIELD,z)>0 then return true end
	if not Duel.IsPlayerAffectedByEffect(tp,53760022) then return false end
	for i=0,4 do
		local fc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if z&(1<<i)~=0 and fc and fc:IsType(TYPE_EFFECT) and Duel.GetMZoneCount(tp,fc,usep,LOCATION_REASON_TOFIELD,1<<i)>0 then return true end
	end
	return false
end
function cm.DressamSPStep(tc,tp,tgp,pos,z)
	local zone=z
	if Duel.IsPlayerAffectedByEffect(tp,53760022) then
		zone=0
		local ct=0
		for i=0,4 do
			if z&(1<<i)~=0 and cm.DressamLocCheck(tgp,tp,1<<i) then
				zone=zone|(1<<i)
				ct=ct+1
			end
		end
		if zone==0 then return false end
		if ct~=1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53760022,0))
			if tp==tgp then zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,0x7f&(~zone)) else
				zone=Duel.SelectField(tp,1,0,LOCATION_MZONE,0x7f&(~zone))
				zone=zone>>16
			end
		end
		local fc=Duel.GetFieldCard(tgp,LOCATION_MZONE,math.log(zone,2))
		if fc and fc:IsType(TYPE_EFFECT) then Duel.Destroy(fc,REASON_RULE) end
	end
	return Duel.SpecialSummonStep(tc,0,tp,tgp,false,false,pos,zone)
end
function cm.Ranclock(c,cat,att1,op,att2)
	aux.AddCodeList(c,53763001)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53763001,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+cat)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(cm.Ranclockspcon1)
	e1:SetTarget(cm.Ranclocksptg1)
	e1:SetOperation(cm.Ranclockspop1(att1,op))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53763001,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.Ranclockspcon2)
	e2:SetTarget(cm.Ranclocksptg2)
	e2:SetOperation(cm.Ranclockspop2(att2))
	c:RegisterEffect(e2)
	return e1,e2
end
function cm.Ranclockspcon1(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) and ((aux.exccon(e) or e:GetHandler():IsPreviousLocation(LOCATION_HAND)) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.Ranclockdfilter(c)
	return c:IsFaceupEx() and c:IsRace(RACE_FIEND) and c:IsLevelAbove(7)
end
function cm.Ranclocksptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(cm.Ranclockdfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.Ranclockspop1(att1,op)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
			c:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e2:SetValue(att1)
			c:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
			op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end
function cm.Ranclockspcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0
end
function cm.Ranclockspfilter(c,e,tp)
	return c:IsCode(53763001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.Ranclocksptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.Ranclockspfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.Ranclockspop2(att2)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.Ranclockspfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(att2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
	end
end
function cm.TentuScout(c)
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIBUTE_LIMIT)
	e2:SetValue(function(e,c)
		return (not c:IsAttribute(e:GetHandler():GetAttribute()) and not c:IsType(TYPE_SPIRIT)) or (c:IsFacedown() and c:IsControler(1-e:GetHandlerPlayer()))
	end)
	c:RegisterEffect(e2)--]]
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(function(e,c)return c:IsFaceup() and c:IsAttribute(e:GetHandler():GetAttribute())end)
	e3:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		return c:IsReason(REASON_SUMMON) and c:IsReason(REASON_MATERIAL) and c:IsReason(REASON_RELEASE)
	end)
	e4:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		e:GetHandler():RegisterFlagEffect(53764000,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1104)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.Tentuthcon)
	e5:SetTarget(cm.Tentuthtg)
	e5:SetOperation(cm.Tentuthop)
	c:RegisterEffect(e5)
end
function cm.Tentuthcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(53764000)>0
end
function cm.Tentuthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.Tentuthop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) end
end
--1
function cm.ActivatedAsSpellorTrap(c,otyp,loc,setava)
	local e1=Effect.CreateEffect(c)
	if otyp&(TYPE_TRAP+TYPE_QUICKPLAY)~=0 then
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	else e1:SetType(EFFECT_TYPE_IGNITION) end
	e1:SetRange(loc)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	local e1_1=Effect.CreateEffect(c)
	local e2=Effect.CreateEffect(c)
	local e3=Effect.CreateEffect(c)
	if not setava then
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(53765098)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetRange(loc)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		c:RegisterEffect(e2)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetRange(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		c:RegisterEffect(e3)
	else
		e1_1:SetType(EFFECT_TYPE_SINGLE)
		e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1_1:SetCode(53765098)
		e1_1:SetRange(loc|LOCATION_ONFIELD)
		e1_1:SetLabel(otyp)
		e1_1:SetLabelObject(e1)
		c:RegisterEffect(e1_1)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetLabelObject(e1)
		e2:SetOperation(cm.AASTadjustop(otyp))
		Duel.RegisterEffect(e2,0)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_ACTIVATE_COST)
		e3:SetLabel(loc)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetTargetRange(1,1)
		e3:SetLabelObject(e1)
		e3:SetTarget(cm.AASTactarget)
		e3:SetCost(cm.AASTcostchk(otyp))
		e3:SetOperation(cm.AASTcostop(otyp))
		Duel.RegisterEffect(e3,0)
		--cm.Global_in_Initial_Reset(c,{e2,e3})
	end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(53765096)
	e2_1:SetRange(loc|LOCATION_ONFIELD)
	e2_1:SetLabel(otyp)
	e2_1:SetLabelObject(e2)
	c:RegisterEffect(e2_1)
	return e1,e1_1,e2,e3
end
function cm.AASTadjustop(otyp,ext)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local adjt={}
	if ext then adjt=ext else adjt={e:GetLabelObject()} end
	for _,te in pairs(adjt) do
	--local te=e:GetLabelObject()
	--if not te then Debug.Message(e:GetLabel()) return else Debug.Message(555) return end
	--if aux.GetValueType(te)~="Effect" then Debug.Message(aux.GetValueType(te)) return end
	--Debug.Message(#te)
	--Debug.Message(te:GetOwner():GetCode())
	local c=te:GetHandler()
	if not c:IsStatus(STATUS_CHAINING) then
		local xe={c:IsHasEffect(53765099)}
		for _,v in pairs(xe) do v:Reset() end
	end
	local p=te:GetHandlerPlayer()
	local pe={Duel.IsPlayerAffectedByEffect(p,EFFECT_CANNOT_ACTIVATE)}
	local ae={Duel.IsPlayerAffectedByEffect(p,EFFECT_ACTIVATE_COST)}
	local t1,t2={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t1,v)
			table.insert(t2,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t1,v)
				table.insert(t2,2)
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	local t3,t4={},{}
	for _,v in pairs(pe) do
		local val=v:GetValue()
		if aux.GetValueType(val)=="number" or val(v,te,p) then
			table.insert(t3,v)
			table.insert(t4,1)
		end
	end
	for _,v in pairs(ae) do
		local cost=v:GetCost()
		if not v:GetLabelObject() and cost and not cost(v,te,p) then
			local tg=v:GetTarget()
			if not tg or tg(v,te,p) then
				table.insert(t3,v)
				table.insert(t4,2)
			end
		end
	end
	xe1:Reset()
	local ret1,ret2={},{}
	for k,v1 in pairs(t1) do
		local equal=false
		for _,v2 in pairs(t3) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret1,v1)
			table.insert(ret2,t2[k])
		end
	end
	local ret3,ret4={},{}
	for k,v1 in pairs(t3) do
		local equal=false
		for _,v2 in pairs(t1) do
			if v1==v2 then
				equal=true
				break
			end
		end
		if not equal then
			table.insert(ret3,v1)
			table.insert(ret4,t4[k])
		end
	end
	for k,v in pairs(ret1) do
		if ret2[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,false,te))
			end
		end
		if ret2[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,false,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,false,te))
				end
			end
		end
	end
	local xe1=cm.AASTregi(c,te)
	xe1:SetLabel(c:GetSequence(),otyp)
	for k,v in pairs(ret3) do
		if ret4[k]==1 then
			local val=v:GetValue()
			if aux.GetValueType(val)=="number" then val=aux.TRUE end
			if val(v,te,p) then
				v:SetValue(cm.AASTchval(val,true,te))
			end
		end
		if ret4[k]==2 then
			local cost=v:GetCost()
			if not v:GetLabelObject() and cost and not cost(v,te,p) then
				local tg=v:GetTarget()
				if not tg then
					v:SetTarget(cm.AASTchtg(aux.TRUE,true,te))
				elseif tg(v,te,p) then
					v:SetTarget(cm.AASTchtg(tg,true,te))
				end
			end
		end
	end
	xe1:Reset()
	end
	end
end
function cm.AASTbchval(_val,te)
	return function(e,re,...)
				if re==te then return false end
				return _val(e,re,...)
			end
end
function cm.AASTchval(_val,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _val(e,re,...)
			end
end
function cm.AASTchtg(_tg,res,te)
	return function(e,re,...)
				if re==te then return res end
				return _tg(e,re,...)
			end
end
function cm.AASTactarget(e,te,tp)
	if e:GetRange()==0 then
		local ce=e:GetLabelObject()
		return te:GetHandler()==e:GetOwner() and te==ce and ce:GetHandler():IsLocation(e:GetLabel())
	else return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject() end
end
function cm.AASTcostchk(otyp)
	return
	function(e,te,tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or otyp&0x80000~=0
	end
end
function cm.AASTcostop(otyp)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local xe1=cm.AASTregi(c,te)
	if otyp&0x80000~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		if c:IsLocation(LOCATION_SZONE) then
			Duel.MoveSequence(c,5)
			if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
		else
			c:SetCardData(4,0x80002)
			Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
			c:SetCardData(4,0x21)
		end
		if c:IsPreviousLocation(LOCATION_HAND) then Duel.ShuffleHand(tp) end
		if c:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_TYPE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetValue(otyp)
	c:RegisterEffect(e0,true)
	if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP)
		c:SetStatus(STATUS_EFFECT_ENABLED,false)
	elseif not c:IsLocation(LOCATION_SZONE) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	xe1:SetLabel(c:GetSequence()+1,otyp)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	c:CreateEffectRelation(te)
	local te2=te:Clone()
	c:RegisterEffect(te2,true)
	e:SetLabelObject(te2)
	local le1={c:IsHasEffect(53765098)}
	for _,v in pairs(le1) do v:SetLabelObject(te2) end
	local le2={c:IsHasEffect(53765096)}
	for _,v in pairs(le2) do v:GetLabelObject():SetLabelObject(te2) end
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.AASTrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	if not c:IsType(TYPE_FIELD+TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) then return end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
	end
end
function cm.AASTrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	re:Reset()
	--[[local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(re)
	e1:SetOperation(cm.AASTreset)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:Reset()
end
function cm.AASTreset(e,tp,eg,ep,ev,re,r,rp)
	local xe={e:GetOwner():IsHasEffect(53765099)}
	for _,v in pairs(xe) do if v:GetLabelObject()==e:GetLabelObject() then v:Reset() end end
	e:Reset()]]
end
function cm.AASTregi(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(53765099)
	e1:SetLabelObject(e)
	c:RegisterEffect(e1,true)
	return e1
end
function cm.MultipleGroupCheck(c)
	if not AD_Multiple_Group_Check then
		AD_Multiple_Group_Check=true
		Duel.RegisterFlagEffect(0,53759000,0,0,0,0)
		ADIMI_IsExistingMatchingCard=Duel.IsExistingMatchingCard
		Duel.IsExistingMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExistingMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SelectMatchingCard=Duel.SelectMatchingCard
		Duel.SelectMatchingCard=function(sp,f,p,s,o,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,s,o,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectMatchingCard(sp,f,p,s,o,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_GetMatchingGroup=Duel.GetMatchingGroup
		Duel.GetMatchingGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_GetMatchingGroupCount=Duel.GetMatchingGroupCount
		Duel.GetMatchingGroupCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetMatchingGroupCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_GetFirstMatchingCard=Duel.GetFirstMatchingCard
		Duel.GetFirstMatchingCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_GetFirstMatchingCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_IsExists=Group.IsExists
		Group.IsExists=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_IsExists(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_IsExists(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_Filter=Group.Filter
		Group.Filter=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Filter(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Filter(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_FilterCount=Group.FilterCount
		Group.FilterCount=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_FilterCount(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_Remove=Group.Remove
		Group.Remove=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_Remove(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_Remove(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SearchCard=Group.SearchCard
		Group.SearchCard=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_SearchCard(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_FilterSelect=Group.FilterSelect
		Group.FilterSelect=function(g,p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_Filter(g,f,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_FilterSelect(g,p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_CheckSubGroup=Group.CheckSubGroup
		Group.CheckSubGroup=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			local b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			b=ADIMI_CheckSubGroup(...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SelectSubGroup=Group.SelectSubGroup
		Group.SelectSubGroup=function(g,p,f,bool,min,max,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_CheckSubGroup(g,f,min,max,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectSubGroup(g,p,f,bool,min,max,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_IsExistingTarget=Duel.IsExistingTarget
		Duel.IsExistingTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=ADIMI_IsExistingTarget(...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SelectTarget=Duel.SelectTarget
		Duel.SelectTarget=function(...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local b=ADIMI_SelectTarget(...)
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_DiscardHand=Duel.DiscardHand
		Duel.DiscardHand=function(p,f,min,max,reason,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_HAND,LOCATION_HAND,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_DiscardHand(p,f,min,max,reason,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SelectReleaseGroup=Duel.SelectReleaseGroup
		Duel.SelectReleaseGroup=function(p,f,min,max,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...)
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroup(p,f,min,max,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
		ADIMI_SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
		Duel.SelectReleaseGroupEx=function(p,f,min,max,r,bool,ex,...)
			local lab=Duel.GetFlagEffectLabel(0,53759000)
			Duel.SetFlagEffectLabel(0,53759000,lab+1)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i
					break
				end
			end
			cm["Card_Prophecy_Layer_"..ly]=true
			cm["Card_Prophecy_L_Check_"..ly]=true
			if bool then ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,ex,...) else ADIMI_GetMatchingGroup(f,p,LOCATION_MZONE,LOCATION_MZONE,ex,...) end
			cm["Card_Prophecy_L_Check_"..ly]=false
			local b=ADIMI_SelectReleaseGroupEx(p,f,min,max,r,bool,ex,...)
			cm["Card_Prophecy_Certain_SP_"..ly]=false
			cm["Card_Prophecy_Certain_ACST_"..ly]=false
			cm["Card_Prophecy_Layer_"..ly]=false
			Duel.SetFlagEffectLabel(0,53759000,lab)
			return b
		end
	end
end
--2
function cm.ActivatedAsSpellorTrapCheck(c)
	if not AD_ActivatedAsSpellorTrap_Check then
		AD_ActivatedAsSpellorTrap_Check=true
		cm.MultipleGroupCheck(c)
		ADIMI_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res=true
			if ac:GetFlagEffect(53757050)>0 then
				res=false
				ac:ResetFlagEffect(53757050)
			end
			local le={ADIMI_GetActivateEffect(ac)}
			local xe={ac:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				if #le>0 then
					if res and ae:GetLabelObject() then
						for k,v in pairs(le) do
							if v==ae:GetLabelObject() then
								table.insert(le,1,ae)
								table.remove(le,k+1)
								break
							end
						end
					else le={ae} end
				else le={ae} end
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			if not ae and Dimpthox_Imitation then
				for _,v in pairs(Dimpthox_Imitation) do if v:GetOwner()==ac then table.insert(le,v) end end
			end
			return table.unpack(le)
		end
		ADIMI_CheckActivateEffect=Card.CheckActivateEffect
		Card.CheckActivateEffect=function(ac,...)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local le={ADIMI_CheckActivateEffect(ac,...)}
			local xe={ac:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			if ae and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) then
				le={ae}
				local xe1=cm.AASTregi(ac,ae)
				xe1:SetLabel(ac:GetSequence(),typ)
				if ly>0 then cm["Card_Prophecy_Certain_ACST_"..ly]=true end
			end
			return table.unpack(le)
		end
		ADIMI_IsActivatable=Effect.IsActivatable
		Effect.IsActivatable=function(re,...)
			if re then return ADIMI_IsActivatable(re,...) else return false end
		end
		ADIMI_IsType=Card.IsType
		Card.IsType=function(rc,type)
			local res=ADIMI_IsType(rc,type)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not rc:IsLocation(LOCATION_MZONE)
			if ae and (res1 or res2) then res=(type&typ~=0) end
			return res
		end
		ADIMI_CGetType=Card.GetType
		Card.GetType=function(rc)
			local res=ADIMI_CGetType(rc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local xe={rc:IsHasEffect(53765098)}
			local ae=nil
			local typ=0
			for _,v in pairs(xe) do ae=v:GetLabelObject() typ=v:GetLabel() end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_ACST_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not rc:IsLocation(LOCATION_MZONE)
			if ae and (res1 or res2) then res=typ end
			return res
		end
		ADIMI_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(rc,...)
			local xe={rc:IsHasEffect(53765099)}
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if v:GetLabelObject() and rc==v:GetLabelObject():GetHandler() then b=true seq,typ=v:GetLabel() end end
			if b and typ and typ~=0 and rc:IsHasEffect(53765098) then
				local e1=Effect.CreateEffect(rc)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetReset(RESET_EVENT+0xfd0000)
				e1:SetValue(typ)
				rc:RegisterEffect(e1,true)
			end
			return ADIMI_MoveToField(rc,...)
		end
		ADIMI_IsHasType=Effect.IsHasType
		Effect.IsHasType=function(re,type)
			local res=ADIMI_IsHasType(re,type)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then
				if type&EFFECT_TYPE_ACTIVATE~=0 then return true else return false end
			else return res end
		end
		ADIMI_EGetType=Effect.GetType
		Effect.GetType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then return EFFECT_TYPE_ACTIVATE else return ADIMI_EGetType(re) end
		end
		ADIMI_IsActiveType=Effect.IsActiveType
		Effect.IsActiveType=function(re,type)
			local res=ADIMI_IsActiveType(re,type)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then
				if type&typ~=0 then return true else return false end
			else return res end
		end
		ADIMI_GetActiveType=Effect.GetActiveType
		Effect.GetActiveType=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local b=false
			local seq,typ=0,0
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true seq,typ=v:GetLabel() end end
			if b then return typ else return ADIMI_GetActiveType(re) end
		end
		ADIMI_GetActivateLocation=Effect.GetActivateLocation
		Effect.GetActivateLocation=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local ls=0
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>5 then return LOCATION_FZONE elseif ls>0 then return LOCATION_SZONE else return ADIMI_GetActivateLocation(re) end
		end
		ADIMI_GetActivateSequence=Effect.GetActivateSequence
		Effect.GetActivateSequence=function(re)
			local rc=re:GetHandler()
			local xe={}
			if rc then xe={rc:IsHasEffect(53765099)} end
			local ls=0
			local seq=ADIMI_GetActivateSequence(re)
			for _,v in pairs(xe) do
				if re==v:GetLabelObject() then
					ls=v:GetLabel()
					break
				end
			end
			if ls>0 then return ls-1 else return seq end
		end
		ADIMI_GetChainInfo=Duel.GetChainInfo
		Duel.GetChainInfo=function(chainc,...)
			local re=ADIMI_GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local b=false
			local ls,typ=0
			if re and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				local xe={}
				if rc then xe={rc:IsHasEffect(53765099)} end
				for _,v in pairs(xe) do
					if re==v:GetLabelObject() then
						b=true
						ls,typ=v:GetLabel()
						break
					end
				end
			end
			local t={ADIMI_GetChainInfo(chainc,...)}
			if b then
				for k,info in ipairs({...}) do
					if info==CHAININFO_TYPE then t[k]=typ end
					if info==CHAININFO_EXTTYPE then t[k]=typ end
					if info==CHAININFO_TRIGGERING_LOCATION then
						if ls>5 then t[k]=LOCATION_FZONE else t[k]=LOCATION_SZONE end
					end
					if info==CHAININFO_TRIGGERING_SEQUENCE and ls>0 then t[k]=ls-1 end
					if info==CHAININFO_TRIGGERING_POSITION then t[k]=POS_FACEUP end
				end
			end
			return table.unpack(t)
		end
		ADIMI_ChangeChainOperation=Duel.ChangeChainOperation
		Duel.ChangeChainOperation=function(chainc,...)
			local re=Duel.GetChainInfo(chainc,CHAININFO_TRIGGERING_EFFECT)
			local xe={}
			if re and re:GetHandler() then xe={re:GetHandler():IsHasEffect(53765099)} end
			local b=false
			for _,v in pairs(xe) do if re==v:GetLabelObject() then b=true end end
			if b then re:GetHandler():CancelToGrave(false) end
			return ADIMI_ChangeChainOperation(chainc,...)
		end
		ADIMI_IsCanBeEffectTarget=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,se)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if c:IsHasEffect(53765098) and cm["Card_Prophecy_Certain_ACST_"..ly] then b=false else b=ADIMI_IsCanBeEffectTarget(sc,se) end
			return b
		end
	end
end
function cm.SpellorTrapSPable(c)
	if not AD_SpellorTrapSPable_Check then
		AD_SpellorTrapSPable_Check=true
		ADSTSP_IsCanBeSpecialSummoned=Card.IsCanBeSpecialSummoned
		Card.IsCanBeSpecialSummoned=function(sc,se,st,sp,bool1,bool2,spos,stp,sz)
			if st==0 then st=SUMMON_TYPE_SPECIAL end
			if not spos then spos=POS_FACEUP end
			if not stp then stp=sp end
			if not sz then sz=0xff end
			local b=true
			local res=ADSTSP_IsCanBeSpecialSummoned(sc,se,st,sp,bool1,bool2,spos,stp,sz)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if sc.SpecialSummonableSpellorTrap and (ly>0 or Duel.GetFlagEffectLabel(0,53759000)==0) and not sc:IsLocation(LOCATION_MZONE) then
				if sc:IsHasEffect(EFFECT_REVIVE_LIMIT) and not sc:IsStatus(STATUS_PROC_COMPLETE) and not bool1 then b=res end
				local zcheck=false
				for i=0,6 do
					if sz&(1<<i)~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i) then zcheck=true end
					if sz&(1<<(i+16))~=0 and Duel.CheckLocation(stp,LOCATION_MZONE,i+16) then zcheck=true end
					if zcheck then break end
				end
				if not zcheck then b=res end
				local sptype,sprace,spatt,splv,spatk,spdef=table.unpack(sc.SSST_Data)
				local e1=Effect.CreateEffect(sc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(sptype|TYPE_MONSTER)
				sc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RACE)
				e2:SetValue(sprace)
				sc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e3:SetValue(spatt)
				sc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(spatk)
				sc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(spdef)
				sc:RegisterEffect(e5,true)
				local e6=e1:Clone()
				e6:SetCode(EFFECT_CHANGE_LEVEL)
				e6:SetValue(splv)
				sc:RegisterEffect(e6,true)
				if sc:IsHasEffect(EFFECT_CANNOT_SPECIAL_SUMMON) then b=res end
				local re={sc:IsHasEffect(EFFECT_SPSUMMON_COST)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp) then
						local cost=v:GetCost()
						if cost and not cost(v,sc,sp) then b=res end
					end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_CANNOT_SPECIAL_SUMMON)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,st,spos,stp,se) then b=res end
				end
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_LIMIT_SPECIAL_SUMMON_POSITION)}
				for _,v in pairs(re) do
					local tg=v:GetTarget()
					if not tg or tg(v,sc,sp,st,spos,stp,se) then b=res end
				end
				local ct=99
				re={Duel.IsPlayerAffectedByEffect(sp,EFFECT_SPSUMMON_COUNT_LIMIT)}
				for _,v in pairs(re) do ct=math.min(ct,v:GetValue()) end
				if Duel.GetActivityCount(sp,ACTIVITY_SPSUMMON)>=ct then b=res end
				e1:Reset()
				e2:Reset()
				e3:Reset()
				e4:Reset()
				e5:Reset()
				e6:Reset()
				if ly>0 then cm["Card_Prophecy_Certain_SP_"..ly]=true end
			else b=res end
			return b
		end
		ADSTSP_SpecialSummon=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,st,sp,stp,bool1,...)
			tg=Group.__add(tg,tg)
			local g=tg:Filter(function(c)return c.SpecialSummonableSpellorTrap end,nil)
			if #g>0 then
				bool1=true
				for tc in aux.Next(g) do
					local data=tc.SSST_Data
					tc:AddMonsterAttribute(data[1])
				end
			end
			return ADSTSP_SpecialSummon(tg,st,sp,stp,bool1,...)
		end
		ADSTSP_SpecialSummonStep=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(tc,st,sp,stp,bool1,...)
			if tc.SpecialSummonableSpellorTrap then
				bool1=true
				local data=tc.SSST_Data
				tc:AddMonsterAttribute(data[1])
			end
			return ADSTSP_SpecialSummonStep(tc,st,sp,stp,bool1,...)
		end
		ADSTSP_IsType=Card.IsType
		Card.IsType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsType(sc,int) end
			return b
		end
		ADSTSP_IsSynchroType=Card.IsSynchroType
		Card.IsSynchroType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsSynchroType(sc,int) end
			return b
		end
		ADSTSP_IsXyzType=Card.IsXyzType
		Card.IsXyzType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsXyzType(sc,int) end
			return b
		end
		ADSTSP_IsLinkType=Card.IsLinkType
		Card.IsLinkType=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&(TYPE_MONSTER|data[1])~=0) else b=ADSTSP_IsLinkType(sc,int) end
			return b
		end
		ADSTSP_CGetType=Card.GetType
		Card.GetType=function(sc)
			local b=ADSTSP_CGetType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		ADSTSP_GetSynchroType=Card.GetSynchroType
		Card.GetSynchroType=function(sc)
			local b=ADSTSP_GetSynchroType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		ADSTSP_GetXyzType=Card.GetXyzType
		Card.GetXyzType=function(sc)
			local b=ADSTSP_GetXyzType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		ADSTSP_GetLinkType=Card.GetLinkType
		Card.GetLinkType=function(sc)
			local b=ADSTSP_GetLinkType(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=TYPE_MONSTER|data[1] end
			return b
		end
		ADSTSP_IsRace=Card.IsRace
		Card.IsRace=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[2]~=0) else b=ADSTSP_IsRace(sc,int) end
			return b
		end
		ADSTSP_GetRace=Card.GetRace
		Card.GetRace=function(sc)
			local b=ADSTSP_GetRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		ADSTSP_GetOriginalRace=Card.GetOriginalRace
		Card.GetOriginalRace=function(sc)
			local b=ADSTSP_GetOriginalRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		ADSTSP_GetLinkRace=Card.GetLinkRace
		Card.GetLinkRace=function(sc)
			local b=ADSTSP_GetLinkRace(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[2] end
			return b
		end
		ADSTSP_IsAttribute=Card.IsAttribute
		Card.IsAttribute=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[3]~=0) else b=ADSTSP_IsAttribute(sc,int) end
			return b
		end
		ADSTSP_IsNonAttribute=Card.IsNonAttribute
		Card.IsNonAttribute=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int&data[3]==0) else b=ADSTSP_IsNonAttribute(sc,int) end
			return b
		end
		ADSTSP_GetAttribute=Card.GetAttribute
		Card.GetAttribute=function(sc)
			local b=ADSTSP_GetAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		ADSTSP_GetOriginalAttribute=Card.GetOriginalAttribute
		Card.GetOriginalAttribute=function(sc)
			local b=ADSTSP_GetOriginalAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		ADSTSP_GetLinkAttribute=Card.GetLinkAttribute
		Card.GetLinkAttribute=function(sc)
			local b=ADSTSP_GetLinkAttribute(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[3] end
			return b
		end
		ADSTSP_IsLevel=Card.IsLevel
		Card.IsLevel=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[4]) else b=ADSTSP_IsLevel(sc,int,...) end
			return b
		end
		ADSTSP_IsLevelAbove=Card.IsLevelAbove
		Card.IsLevelAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[4]) else b=ADSTSP_IsLevelAbove(sc,int) end
			return b
		end
		ADSTSP_IsLevelBelow=Card.IsLevelBelow
		Card.IsLevelBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[4]) else b=ADSTSP_IsLevelBelow(sc,int) end
			return b
		end
		ADSTSP_GetLevel=Card.GetLevel
		Card.GetLevel=function(sc)
			local b=ADSTSP_GetLevel(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[4] end
			return b
		end
		ADSTSP_GetOriginalLevel=Card.GetOriginalLevel
		Card.GetOriginalLevel=function(sc)
			local b=ADSTSP_GetOriginalLevel(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[4] end
			return b
		end
		ADSTSP_IsAttack=Card.IsAttack
		Card.IsAttack=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[5]) else b=ADSTSP_IsAttack(sc,int,...) end
			return b
		end
		ADSTSP_IsAttackAbove=Card.IsAttackAbove
		Card.IsAttackAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[5]) else b=ADSTSP_IsAttackAbove(sc,int) end
			return b
		end
		ADSTSP_IsAttackBelow=Card.IsAttackBelow
		Card.IsAttackBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[5]) else b=ADSTSP_IsAttackBelow(sc,int) end
			return b
		end
		ADSTSP_GetAttack=Card.GetAttack
		Card.GetAttack=function(sc)
			local b=ADSTSP_GetAttack(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[5] end
			return b
		end
		ADSTSP_GetBaseAttack=Card.GetBaseAttack
		Card.GetBaseAttack=function(sc)
			local b=ADSTSP_GetBaseAttack(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[5] end
			return b
		end
		ADSTSP_IsDefense=Card.IsDefense
		Card.IsDefense=function(sc,int,...)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int==data[6]) else b=ADSTSP_IsDefense(sc,int,...) end
			return b
		end
		ADSTSP_IsDefenseAbove=Card.IsDefenseAbove
		Card.IsDefenseAbove=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int<=data[6]) else b=ADSTSP_IsDefenseAbove(sc,int) end
			return b
		end
		ADSTSP_IsDefenseBelow=Card.IsDefenseBelow
		Card.IsDefenseBelow=function(sc,int)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=(int>=data[6]) else b=ADSTSP_IsDefenseBelow(sc,int) end
			return b
		end
		ADSTSP_GetDefense=Card.GetDefense
		Card.GetDefense=function(sc)
			local b=ADSTSP_GetDefense(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[6] end
			return b
		end
		ADSTSP_GetBaseDefense=Card.GetBaseDefense
		Card.GetBaseDefense=function(sc)
			local b=ADSTSP_GetBaseDefense(sc)
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			local res1=ly>0 and (cm["Card_Prophecy_L_Check_"..ly] or cm["Card_Prophecy_Certain_SP_"..ly])
			local res2=Duel.GetFlagEffectLabel(0,53759000)==0 and not sc:IsLocation(LOCATION_MZONE)
			local data=sc.SSST_Data
			if sc.SpecialSummonableSpellorTrap and (res1 or res2) then b=data[6] end
			return b
		end
		ADSTSP_IsCanBeEffectTarget=Card.IsCanBeEffectTarget
		Card.IsCanBeEffectTarget=function(sc,se)
			local b=true
			local ly=0
			for i=1,114 do
				if not cm["Card_Prophecy_Layer_"..i] then
					ly=i-1
					break
				end
			end
			if sc.SpecialSummonableSpellorTrap and cm["Card_Prophecy_Certain_SP_"..ly] then b=res else b=ADSTSP_IsCanBeEffectTarget(sc,se) end
			return b
		end
	end
end
function cm.HelltakerActivate(c,code)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(53765000)
	e4:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(53765000)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
	local ex=Effect.CreateEffect(c)
	ex:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ex:SetCode(EVENT_MOVE)
	ex:SetOperation(cm.HTAmvhint(code))
	c:RegisterEffect(ex)
	if not AD_Helltaker_Check then
		AD_Helltaker_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(cm.HTAmvop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		ADHT_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(sc,mp,tp,dest,pos,bool,zone)
			local czone=zone or 0xff
			if ad_ht_fr then czone=ad_ht_fr end
			return ADHT_MoveToField(sc,mp,tp,dest,pos,bool,czone)
		end
		ADHT_GetLocationCount=Duel.GetLocationCount
		Duel.GetLocationCount=function(...)
			local ct=ADHT_GetLocationCount(...)+ad_ht_zc
			return ct
		end
	end
end
ad_ht_zc=0
function cm.HTAfactarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te==e:GetLabelObject()
end
AD_Given_Effect={}
function cm.HTAmvop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NOT(Card.IsStatus),tp,LOCATION_ONFIELD,0,nil,STATUS_CHAINING)
	for c in aux.Next(g) do
		local rse={c:IsHasEffect(53765050)}
		for _,v in pairs(rse) do
			if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
			if v:GetLabelObject() then v:GetLabelObject():Reset() end
			v:Reset()
		end
	end
	if not Duel.IsPlayerAffectedByEffect(tp,53765000) then return end
	g=Duel.GetMatchingGroup(function(c)return c:GetActivateEffect() and not c:GetActivateEffect():IsActiveType(TYPE_FIELD)end,tp,LOCATION_HAND,0,nil)
	for c in aux.Next(g) do
		local le={c:GetActivateEffect()}
		for _,te in pairs(le) do
			local ale=nil
			local rse={c:IsHasEffect(53765097)}
			for k,v in pairs(rse) do
				if te==v:GetLabelObject() and k<#rse then
					ale=rse[k+1]
					ale=ale:GetLabelObject()
					break
				end
			end
			if ale then
				if te:GetCategory()~=ale:GetCategory() then ale:SetCategory(te:GetCategory()) end
				local tecon=te:GetCondition() or aux.TRUE
				local alecon=ale:GetCondition() or aux.TRUE
				if tecon~=alecon then ale:SetCondition(tecon) end
				local tecost=te:GetCost() or aux.TRUE
				local alecost=ale:GetCost() or aux.TRUE
				if tecost~=alecost then ale:SetCost(tecost) end
				local tetg=te:GetTarget() or aux.TRUE
				local aletg=ale:GetTarget() or aux.TRUE
				if tetg~=aletg then ale:SetTarget(tetg) end
				if te:GetOperation()~=ale:GetOperation() then ale:SetOperation(te:GetOperation()) end
				if te:GetLabel()~=ale:GetLabel() then ale:SetLabel(te:GetLabel()) end
				if te:GetValue()~=ale:GetValue() then ale:SetValue(te:GetValue()) end
			elseif te:GetRange()&0x2~=0 then
				local e1=te:Clone()
				e1:SetDescription(aux.Stringid(53765000,14))
				if te:GetCode()==EVENT_FREE_CHAIN then
					if te:IsActiveType(TYPE_TRAP+TYPE_QUICKPLAY) then e1:SetType(EFFECT_TYPE_QUICK_O) else e1:SetType(EFFECT_TYPE_IGNITION) end
				elseif te:GetCode()==EVENT_CHAINING and te:GetProperty()&EFFECT_FLAG_DELAY==0 then
					if ADIMI_EGetType(te)&EFFECT_TYPE_QUICK_F~=0 then e1:SetType(EFFECT_TYPE_QUICK_F) else e1:SetType(EFFECT_TYPE_QUICK_O) end
				elseif te:GetCode()~=0 then
					if ADIMI_EGetType(te)&EFFECT_TYPE_TRIGGER_F~=0 then e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F) else e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) end
				else e1:SetType(EFFECT_TYPE_IGNITION) end
				e1:SetRange(LOCATION_HAND)
				local pro,pro2=te:GetProperty()
				e1:SetProperty(pro|EFFECT_FLAG_UNCOPYABLE,pro2)
				e1:SetReset(RESET_EVENT+0xff0000)
				c:RegisterEffect(e1,true)
				--table.insert(AD_Given_Effect,e1)
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" then val=aux.TRUE end
					v:SetValue(cm.AASTbchval(val,e1))
				end
				local zone=0xff
				if te:IsActiveType(TYPE_PENDULUM) then zone=0x11 end
				if te:IsHasProperty(EFFECT_FLAG_LIMIT_ZONE) then
					zone=te:GetValue()
					if aux.GetValueType(zone)=="function" then zone=zone(te,tp,eg,ep,ev,re,r,rp) end
				end
				local fcheck=false
				local fe={Duel.IsPlayerAffectedByEffect(0,53765050)}
				for _,v in pairs(fe) do
					local ae=v:GetLabelObject()
					if ae:GetLabelObject() and ae:GetLabelObject()==te and ae:GetCode() and ae:GetCode()==EFFECT_ACTIVATE_COST and ae:GetRange()&LOCATION_HAND~=0 then
						fcheck=true
						local e2_1=ae:Clone()
						if ae:GetRange()==0 then
							local lbrange=ae:GetLabel()
							if lbrange==0 then lbrange=0xff end
							e2_1:SetRange(lbrange)
						end
						e2_1:SetLabelObject(e1)
						e2_1:SetTarget(cm.HTAfactarget)
						local cost=ae:GetCost()
						if not cost then cost=aux.TRUE end
						e2_1:SetCost(cm.HTAfaccost(cost,te,zone))
						local op=ae:GetOperation()
						e2_1:SetOperation(cm.HTAfcostop(op,zone))
						e2_1:SetReset(RESET_EVENT+0xff0000)
						c:RegisterEffect(e2_1,true)
						local e3_1=Effect.CreateEffect(c)
						e3_1:SetType(EFFECT_TYPE_SINGLE)
						e3_1:SetCode(53765050)
						e3_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
						e3_1:SetLabelObject(e2_1)
						e3_1:SetReset(RESET_EVENT+0xff0000)
						c:RegisterEffect(e3_1,true)
					end
				end
				if not fcheck then
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetCode(EFFECT_ACTIVATE_COST)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
					e2:SetRange(LOCATION_HAND)
					e2:SetTargetRange(1,0)
					e2:SetTarget(cm.HTAfactarget)
					e2:SetCost(cm.HTAfaccost(aux.TRUE,te,zone))
					e2:SetOperation(cm.HTAfcostop(cm.HTAmvcostop,zone))
					e2:SetLabelObject(e1)
					e2:SetReset(RESET_EVENT+0xff0000)
					c:RegisterEffect(e2,true)
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(53765050)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
					e3:SetLabelObject(e2)
					e3:SetReset(RESET_EVENT+0xff0000)
					c:RegisterEffect(e3,true)
				end
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(53765097)
				e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e4:SetLabelObject(te)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e4,true)
				local e5=e4:Clone()
				e5:SetLabelObject(e1)
				c:RegisterEffect(e5,true)
				local e6=Effect.CreateEffect(c)
				e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e6:SetCode(EVENT_CHAIN_SOLVING)
				e6:SetCountLimit(1)
				e6:SetLabelObject(e1)
				e6:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return re==e:GetLabelObject()end)
				e6:SetOperation(cm.HTArsop)
				Duel.RegisterEffect(e6,tp)
				local e7=e6:Clone()
				e7:SetCode(EVENT_CHAIN_NEGATED)
				Duel.RegisterEffect(e7,tp)
			end
		end
	end
end
function cm.HTArsop(e,tp,eg,ep,ev,re,r,rp)
	local rse={re:GetHandler():IsHasEffect(53765050)}
	for _,v in pairs(rse) do
		if v:GetLabelObject():GetLabelObject() then v:GetLabelObject():GetLabelObject():Reset() end
		if v:GetLabelObject() then v:GetLabelObject():Reset() end
		v:Reset()
	end
	e:Reset()
end
function cm.HTAfaccost(_cost,fe,zone)
	return function(e,te,tp)
				ad_ht_zc=1
				local fcost=fe:GetCost()
				local ftg=fe:GetTarget()
				local check=false
				local code=fe:GetCode()
				if code==0 or code==EVENT_FREE_CHAIN then
					if (not fcost or fcost(fe,tp,nil,0,0,nil,0,0,0)) and (not ftg or ftg(fe,tp,nil,0,0,nil,0,0,0)) then check=true end
				else
					local cres,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(code,true)
					if (not fcost or fcost(fe,tp,teg,tep,tev,tre,tr,trp,0)) and (not ftg or ftg(fe,tp,teg,tep,tev,tre,tr,trp,0)) then check=true end
				end
				local pe={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ACTIVATE)}
				for _,v in pairs(pe) do
					local val=v:GetValue()
					if aux.GetValueType(val)=="number" or val(v,fe,tp) then check=false end
				end
				if not check then
					ad_ht_zc=0
					return false
				end
				ad_ht_zc=0
				local c=e:GetHandler()
				local xe={c:IsHasEffect(53765099)}
				for _,v in pairs(xe) do v:Reset() end
				if te:IsActiveType(TYPE_QUICKPLAY) and Duel.GetTurnPlayer()~=tp and not c:IsHasEffect(EFFECT_QP_ACT_IN_NTPHAND) then return false end
				if te:IsActiveType(TYPE_TRAP) and not c:IsHasEffect(EFFECT_TRAP_ACT_IN_HAND) then return false end
				if not c:CheckUniqueOnField(tp) then return false end
				ad_ht_zc=1
				if not Duel.IsExistingMatchingCard(cm.HTAmvfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,zone) then
					ad_ht_zc=0
					return false
				end
				local res=false
				if _cost(e,te,tp) then res=true end
				ad_ht_zc=0
				--Debug.Message(res)
				return res
			end
end
function cm.HTAfcostop(_op,zone)
	return function(e,tp,eg,ep,ev,re,r,rp)
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(53765000,15))
				local tc=Duel.SelectMatchingCard(tp,cm.HTAmvfilter,tp,LOCATION_SZONE,0,1,1,nil,e,tp,zone):GetFirst()
				local seq=tc:GetSequence()
				if seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then Duel.MoveSequence(tc,seq-1) else Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,1<<seq) end
				ad_ht_fr=1<<seq
				_op(e,tp,teg,tep,tev,tre,tr,trp)
				ad_ht_fr=nil
			end
end
function cm.HTAmvfilter(c,e,tp,zone)
	local seq=c:GetSequence()
	return c:IsHasEffect(53765000) and ((seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1)) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,1<<seq)) and (1<<seq)&zone~=0
end
function cm.HTAmvcostop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local typ=c:GetType()
	if te:IsActiveType(TYPE_PENDULUM) then typ=TYPE_PENDULUM+TYPE_SPELL end
	local xe1=cm.AASTregi(c,te)
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	xe1:SetLabel(c:GetSequence()+1,typ)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.HTAmvrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	ad_ht_fr=nil
end
function cm.HTAmvrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	if re then re:Reset() end
	--[[local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(re)
	e1:SetOperation(cm.AASTreset)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:Reset()--]]
end
function cm.HTAmvhint(code)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_SZONE) and c:IsPreviousLocation(LOCATION_SZONE) and (c:GetPreviousSequence()~=c:GetSequence() or c:GetPreviousControler()~=c:GetControler())) then return end
	local flag=c:GetFlagEffectLabel(code+50)
	if flag then
		flag=flag+1
		c:ResetFlagEffect(code+50)
		local hflag=flag-1
		if hflag>13 then hflag=13 end
		c:RegisterFlagEffect(code+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(53765000,hflag))
	else c:RegisterFlagEffect(code+50,RESET_EVENT+0x7e0000,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(53765000,0)) end
	end
end
function cm.DragoronActivate(c,code)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1,code+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return e:GetHandler():GetSequence()<5 end)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_ACTIVATE_COST)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(1,1)
	e3:SetLabelObject(e1)
	e3:SetTarget(cm.ADGDactarget)
	e3:SetOperation(cm.ADGDcostop)
	Duel.RegisterEffect(e3,0)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e5:SetLabelObject(c)
	e5:SetTarget(cm.ADGDreptarget)
	e5:SetValue(cm.ADGDrepval)
	e5:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e5,0)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6:SetTargetRange(1,1)
	e6:SetLabelObject(c)
	e6:SetTarget(cm.ADGDactarget2)
	e6:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e6,0)
	local e6_1=Effect.CreateEffect(c)
	e6_1:SetType(EFFECT_TYPE_FIELD)
	e6_1:SetCode(EFFECT_SSET_COST)
	e6_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e6_1:SetTargetRange(0xff,0xff)
	e6_1:SetLabelObject(c)
	e6_1:SetTarget(cm.ADGDactarget3)
	e6_1:SetOperation(cm.ADGDrepoperation)
	Duel.RegisterEffect(e6_1,0)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(53757000)
	e8:SetLabelObject(e1)
	e8:SetCondition(function(e)
		return e:GetHandler():IsLocation(LOCATION_SZONE)
	end)
	c:RegisterEffect(e8)
	if not Goron_Dimension_Check then
		Goron_Dimension_Check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.ADGDaccon)
		ge1:SetOperation(cm.ADGDacop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCondition(aux.TRUE)
		ge2:SetCode(4179255)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetProperty(EFFECT_FLAG_DELAY)
		ge3:SetCode(EVENT_MOVE)
		ge3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
			local g=Duel.GetMatchingGroup(nil,0,0xff,0xff,nil)
			g:ForEach(Card.ResetFlagEffect,53757050)
		end)
		Duel.RegisterEffect(ge3,0)
		ADGD_SSet=Duel.SSet
		Duel.SSet=function(tp,tg,tgp,...)
			Dragoron_SSet_Check=true
			if not tgp then tgp=tp end
			tg=Group.__add(tg,tg)
			if tg:IsExists(Card.IsType,1,nil,TYPE_FIELD) then
				local fc=Duel.GetFieldCard(tgp,LOCATION_FZONE,0)
				if fc and fc:IsHasEffect(53757000) and Duel.GetLocationCount(tgp,LOCATION_SZONE)-tg:FilterCount(aux.NOT(Card.IsType),nil,TYPE_FIELD)>0 then
					Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(tgp,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
				end
			end
			local ct=ADGD_SSet(tp,tg,tgp,...)
			Dragoron_SSet_Check=false
			return ct
		end
		ADGD_SendtoGrave=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoGrave(tg,reason)
		end
		ADGD_Destroy=Duel.Destroy
		Duel.Destroy=function(tg,reason,...)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_Destroy(tg,reason,...)
		end
		ADGD_DRemove=Duel.Remove
		Duel.Remove=function(tg,pos,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_DRemove(tg,pos,reason)
		end
		ADGD_SendtoHand=Duel.SendtoHand
		Duel.SendtoHand=function(tg,tp,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoHand(tg,tp,reason)
		end
		ADGD_SendtoDeck=Duel.SendtoDeck
		Duel.SendtoDeck=function(tg,tp,seq,reason)
			tg=Group.__add(tg,tg)
			local g=Group.__band(tg,Duel.GetFieldGroup(tp,LOCATION_FZONE,LOCATION_FZONE))
			for fc in aux.Next(g) do
				local p=fc:GetControler()
				if fc and fc:IsHasEffect(53757000) and reason&REASON_RULE~=0 and Duel.GetLocationCount(p,LOCATION_SZONE)>0 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
					local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
					Duel.MoveSequence(fc,math.log(mv,2)-8)
					if fc:IsFacedown() then Duel.ChangePosition(fc,POS_FACEUP) end
					cm.ADGDTypeChange(fc)
					tg:RemoveCard(fc)
				end
			end
			return ADGD_SendtoDeck(tg,tp,seq,reason)
		end
		ADGD_SetReset=Effect.SetReset
		Effect.SetReset=function(re,reset,...)
			if reset&RESET_TOFIELD~=0 then Dragoron_Reset_Check=true end
			return ADGD_SetReset(re,reset,...)
		end
		ADGD_CRegisterEffect=Card.RegisterEffect
		Card.RegisterEffect=function(rc,re,...)
			if Dragoron_Reset_Check then
				local e1=Effect.CreateEffect(rc)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_MOVE)
				e1:SetLabelObject(re)
				e1:SetCondition(cm.ADGDresetcon)
				e1:SetOperation(cm.ADGDresetop)
				Duel.RegisterEffect(e1,rp)
				Dragoron_Reset_Check=false
			end
			if re and re:GetCode()==117 and rc:GetType()==re:GetValue() then return end
			return ADGD_CRegisterEffect(rc,re,...)
		end
		ADGD_DRegisterEffect=Duel.RegisterEffect
		Duel.RegisterEffect=function(...)
			Dragoron_Reset_Check=false
			return ADGD_DRegisterEffect(...)
		end
		ADGD_MoveToField=Duel.MoveToField
		Duel.MoveToField=function(mc,p,tgp,dest,...)
			mc:ResetFlagEffect(53757050)
			local res=ADGD_MoveToField(mc,p,tgp,dest,...)
			if dest==LOCATION_FZONE then mc:RegisterFlagEffect(53757050,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) end
			if dest==LOCATION_SZONE and mc:IsHasEffect(53757000) then cm.ADGDTypeChange(mc) end
			return res
		end
		ADGD_MoveSequence=Duel.MoveSequence
		Duel.MoveSequence=function(mc,seq)
			mc:ResetFlagEffect(53757050)
			return ADGD_MoveSequence(mc,seq)
		end
		ADGD_GetActivateEffect=Card.GetActivateEffect
		Card.GetActivateEffect=function(ac)
			local re=ADGD_GetActivateEffect(ac)
			local le={ac:IsHasEffect(53757000)}
			if #le>0 then
				le=le[1]
				re=le:GetLabelObject()
			end
			return re
		end
		ADGD_GetOriginalType=Card.GetOriginalType
		Card.GetOriginalType=function(ac)
			if ac:IsHasEffect(53757000) then return 0x80002 else return ADGD_GetOriginalType(ac) end
		end
	end
	return e0,e1,e3,e5,e6,e6_1
end
function cm.ADGDresetfil(c,tc)
	return c==tc and ((c:IsPreviousLocation(LOCATION_FZONE) and not c:IsLocation(LOCATION_FZONE)) or (c:IsLocation(LOCATION_FZONE) and not c:IsPreviousLocation(LOCATION_FZONE)))
end
function cm.ADGDresetcon(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	if not re or aux.GetValueType(re)~="Effect" then
		e:Reset()
		return false
	end
	return eg:IsExists(cm.ADGDresetfil,1,nil,re:GetHandler())
end
function cm.ADGDresetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
function cm.ADGDaccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.ADGDacop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(rp,53757050)>0 then return end
	if Duel.GetCurrentChain()>0 then Duel.RegisterFlagEffect(rp,53757050,RESET_CHAIN,0,1) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetLabel(Duel.GetCurrentChain())
	e1:SetLabelObject(re)
	e1:SetOperation(cm.ADGDregop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,rp)
end
function cm.ADGDregop(e,tp,eg,ep,ev,re,r,rp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then Duel.RaiseSingleEvent(fc,EVENT_CUSTOM+53757099,e:GetLabelObject(),0,tp,tp,e:GetLabel()) end
	e:Reset()
end
function cm.ADGDrepfilter(c,tc)
	return c==tc and Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)>0 and c:IsLocation(LOCATION_FZONE)
end
function cm.ADGDreptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetLabelObject()
	if chk==0 then return eg:IsExists(cm.ADGDrepfilter,1,nil,c) end
	return true
end
function cm.ADGDrepval(e,c)
	return cm.ADGDrepfilter(c,e:GetLabelObject())
end
function cm.ADGDTypeChange(c)
	c:SetCardData(CARDDATA_TYPE,0x20002)
	local t={}
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():GetSequence()<5 then return end
		e:GetHandler():SetCardData(4,0x80002)
		for k,v in pairs(t) do v:Reset() end
	end)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return e:GetHandler():IsLocation(LOCATION_SZONE) and e:GetHandler():GetSequence()<5 end)
	c:RegisterEffect(e2,true)
	t={e1,e2}
end
function cm.ADGDrepoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if not c:IsLocation(LOCATION_FZONE) then return end
	local p=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
	local mv=Duel.SelectDisableField(p,1,LOCATION_SZONE,0,0)
	Duel.MoveSequence(c,math.log(mv,2)-8)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	cm.ADGDTypeChange(c)
end
function cm.ADGDactarget2(e,te,tp)
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return Duel.GetLocationCount(p,LOCATION_SZONE)>0 and te:IsActiveType(TYPE_FIELD) and te:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsLocation(LOCATION_FZONE) and c:IsControler(p) and p==tp and te:GetHandler()~=c
end
function cm.ADGDactarget3(e,tc,tp)
	if Dragoron_SSet_Check then return false end
	local c=e:GetLabelObject()
	local p=c:GetControler()
	return Duel.GetLocationCount(p,LOCATION_SZONE)>0 and tc:IsType(TYPE_FIELD) and c:IsLocation(LOCATION_FZONE) and c:IsControler(p) and tc:GetControler()==p and tc~=c
end
function cm.ADGDactarget(e,te,tp)
	local ce=e:GetLabelObject()
	return te:GetHandler()==e:GetOwner() and te==ce and ce:GetHandler():IsLocation(LOCATION_SZONE) and ce:GetHandler():GetSequence()<5
end
function cm.ADGDcostop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local p=te:GetHandlerPlayer()
	local c=te:GetHandler()
	local fc=Duel.GetFieldCard(p,LOCATION_FZONE,0)
	if fc then Duel.SendtoGrave(fc,REASON_RULE) end
	Duel.MoveSequence(c,5)
	if c:IsFacedown() then Duel.ChangePosition(c,POS_FACEUP) end
	c:SetStatus(STATUS_EFFECT_ENABLED,false)
	c:CreateEffectRelation(te)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.ADGDrsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,p)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,p)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	e3:SetProperty(EFFECT_FLAG_OATH+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_CHAIN)
	c:RegisterEffect(e3)
end
function cm.ADGDrsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetLabelObject(re)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not e:GetLabelObject():GetHandler():IsLocation(LOCATION_FZONE) then
			e:GetLabelObject():SetType(EFFECT_TYPE_IGNITION)
			e:Reset()
		end
	end)
	Duel.RegisterEffect(e1,tp)
	e:Reset()
end
function cm.GoronDimensionCopy(c,cd,tab)
	local cat,type,code,cost,con,tg,op,pro1,pro2=table.unpack(tab)
	if type&EFFECT_TYPE_SINGLE~=0 then return end
	if type&(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_QUICK_F)~=0 and code and code==EVENT_CHAINING then return end
	if not con then con=aux.TRUE end
	if not cost then cost=aux.TRUE end
	if not tg then tg=aux.TRUE end
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+53757099)
	e0:SetRange(0xff)
	e0:SetCountLimit(1)
	e0:SetOperation(cm.ADGDtrop(cd))
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(cd,1))
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+cd)
	e1:SetRange(0xff)
	e1:SetProperty(pro1|EFFECT_FLAG_DELAY,pro2)
	e1:SetCountLimit(1)
	if type&EFFECT_TYPE_IGNITION==0 and code and code~=EVENT_FREE_CHAIN and code~=EVENT_CHAINING then
		e1:SetCondition(cm.ADGDrecon(con,cd))
		e1:SetCost(cm.ADGDrecost(cost,cd))
		e1:SetTarget(cm.ADGDretg(tg,op,cd))
		local g=Group.CreateGroup()
		g:KeepAlive()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(code)
		e3:SetLabelObject(g)
		e3:SetOperation(cm.ADGDMergedDelayEventCheck1(cd))
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		e4:SetCode(EVENT_CHAIN_END)
		e4:SetOperation(cm.ADGDMergedDelayEventCheck2(cd))
		Duel.RegisterEffect(e4,0)
	else
		e1:SetCondition(con)
		e1:SetCost(cost)
		e1:SetTarget(tg)
		e1:SetOperation(op)
	end
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function cm.ADGDtrop(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_FZONE) then return end
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+cd,re,0,rp,ep,ev)
	e:Reset()
	end
end
function cm.ADGDrecon(_con,cd)
	return function(e,tp,eg,ep,ev,re,r,rp)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				return _con(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDrecost(_cost,cd)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				return _cost(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDretg(_tg,_op,cd)
	return function(e,tp,eg,ep,ev,re,r,rp,...)
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_CUSTOM+(cd+50),true)
				if not res then return false end
				e:SetOperation(cm.ADGDreop(_op,teg,tep,tev,tre,tr,trp))
				return _tg(e,tp,teg,tep,tev,tre,tr,trp,...)
			end
end
function cm.ADGDreop(_op,teg,tep,tev,tre,tr,trp)
	return function(e,tp,eg,ep,ev,re,r,rp)
				_op(e,tp,teg,tep,tev,tre,tr,trp)
			end
end
function cm.ADGDMergedDelayEventCheck1(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	g:Merge(eg)
	if Duel.GetCurrentChain()==0 and not Duel.CheckEvent(EVENT_CHAIN_END) then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(cd+50),re,r,rp,ep,ev)
		g:Clear()
	end
	end
end
function cm.ADGDMergedDelayEventCheck2(cd)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if #g>0 then
		local _eg=g:Clone()
		Duel.RaiseEvent(_eg,EVENT_CUSTOM+(cd+50),re,r,rp,ep,ev)
		g:Clear()
	end
	end
end
function cm.Select_1(g,tp,msg)
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,msg)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	return tc
end
function cm.Act(c,e)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.HTAfactarget)
	e1:SetOperation(cm.BaseActOp)
	return e1
end
function cm.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.BaseActReset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.BaseActReset(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVING and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
		if not rc:IsType(TYPE_CONTINUOUS+TYPE_EQUIP+TYPE_PENDULUM) and not rc:IsHasEffect(EFFECT_REMAIN_FIELD) then rc:CancelToGrave(false) end
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
		rc:CancelToGrave(false)
	end
end
function cm.AdvancedActOp(ctype,op)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local te=e:GetLabelObject()
	local c=te:GetHandler()
	local typ=c:GetType()
	if te:IsActiveType(TYPE_PENDULUM) then typ=TYPE_PENDULUM+TYPE_SPELL end
	local xe1=cm.AASTregi(c,te)
	if ctype&0x80000~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		if c:IsLocation(LOCATION_SZONE) and c:IsFacedown() then
			Duel.ChangePosition(c,POS_FACEUP)
			c:SetStatus(STATUS_EFFECT_ENABLED,false)
		elseif not c:IsLocation(LOCATION_SZONE) then
			Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		end
	end
	xe1:SetLabel(c:GetSequence()+1,typ)
	c:CreateEffectRelation(te)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return ev==ev0 end)
	e1:SetOperation(cm.BaseActReset)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
	end
end
function cm.Excavated_Check(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetCondition(cm.DimpthoxEregcon)
	e0:SetOperation(cm.DimpthoxEregop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(53766099)
	e1:SetRange(LOCATION_DECK)
	c:RegisterEffect(e1)
	if Dimpthox_Excavated_Check then return end
	Dimpthox_Excavated_Check=true
	local ge=Effect.GlobalEffect()
	ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge:SetCode(EVENT_ADJUST)
	ge:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)Dimpthox_E_Check=false end)
	Duel.RegisterEffect(ge,tp)
	cm.ConfirmDecktop=Duel.ConfirmDecktop
	Duel.ConfirmDecktop=function(tp,ct)
		local g=Duel.GetDecktopGroup(tp,ct)
		if g:IsExists(Card.IsHasEffect,1,nil,53766099) then Dimpthox_E_Check=true end
		return cm.ConfirmDecktop(tp,ct)
	end
end
function cm.DimpthoxEregcon(e,tp,eg,ep,ev,re,r,rp)
	return Dimpthox_E_Check
end
function cm.DimpthoxEregop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	c:RegisterFlagEffect(53766099,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,66)
end
function cm.GetCurrentPhase()
	local ph=Duel.GetCurrentPhase()
	if ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE then ph=PHASE_BATTLE end
	return ph
end
function cm.Not_Destroyed_Count(c)
	local flag=c:GetFlagEffectLabel(53766008) or 0
	if flag<15 and c:IsLocation(LOCATION_ONFIELD) then
		flag=flag+1
		c:ResetFlagEffect(53766008)
		c:RegisterFlagEffect(53766008,RESET_EVENT+0x1fc0000,EFFECT_FLAG_CLIENT_HINT,1,flag,aux.Stringid(53766008,flag))
	end
end
function cm.Not_Destroyed_Check(c)
	if Dimpthox_Not_Destroyed_Check then return end
	Dimpthox_Not_Destroyed_Check=true
	local ge1=Effect.GlobalEffect()
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_ADJUST)
	ge1:SetOperation(cm.DimpthoxDcheckop)
	Duel.RegisterEffect(ge1,0)
	local _Destroy=Duel.Destroy
	Duel.Destroy=function(g,rs,...)
		local ct=_Destroy(g,rs,...)
		if rs&0x60~=0 then Group.__add(g,g):ForEach(cm.Not_Destroyed_Count) Duel.RaiseEvent(Group.__add(g,g):Filter(Card.IsLocation,nil,LOCATION_MZONE),EVENT_CUSTOM+53766016,Effect.GlobalEffect(),0,0,0,0) end
		return ct
	end
end
cm.ndc_0=nil
cm.ndc_1=nil
cm.ndc_2=0
function cm.DimpthoxDcheckop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetCurrentPhase()~=PHASE_DAMAGE and Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL) or Duel.GetFlagEffect(0,53766098)>0 then return end
	cm.ndc_0=Duel.GetAttacker()
	cm.ndc_1=Duel.GetAttackTarget()
	if not cm.ndc_0 or not cm.ndc_1 then return end
	local at,bt=cm.ndc_0,cm.ndc_1
	if Duel.IsDamageCalculated() then
		if cm.ndc_2~=3 then
			local g=Group.CreateGroup()
			if cm.ndc_2~=0 then cm.Not_Destroyed_Count(at) g:AddCard(at) end
			if cm.ndc_2~=1 then cm.Not_Destroyed_Count(bt) g:AddCard(bt) end
			Duel.RaiseEvent(g:Filter(aux.NOT(Card.IsStatus),nil,STATUS_BATTLE_RESULT),EVENT_CUSTOM+53766016,Effect.GlobalEffect(),0,0,0,0)
		end
		Duel.RegisterFlagEffect(0,53766098,RESET_PHASE+PHASE_DAMAGE,0,1)
	else
		local getatk=function(c)
			local sete={c:IsHasEffect(EFFECT_SET_BATTLE_ATTACK)}
			local val=c:GetAttack()
			if #sete>0 then
				sete=sete[#sete]
				val=sete:GetValue()
				if aux.GetValueType(val)=="function" then val=val(e) end
			end
			return val
		end
		local getdef=function(c)
			local sete={c:IsHasEffect(EFFECT_SET_BATTLE_DEFENSE)}
			local val=c:GetDefense()
			if #sete>0 then
				sete=sete[#sete]
				val=sete:GetValue()
				if aux.GetValueType(val)=="function" then val=val(e) end
			end
			return val
		end
		local atk=getatk(at)
		local le={at:IsHasEffect(EFFECT_DEFENSE_ATTACK)}
		local val=0
		for _,v in pairs(le) do
			val=v:GetValue()
			if aux.GetValueType(val)=="function" then val=val(e) end
		end
		if val==1 then
			atk=getdef(at)
		end
		if bt:IsAttackPos() then
			if atk>getatk(bt) then cm.ndc_2=0 elseif getatk(bt)>atk then cm.ndc_2=1 else cm.ndc_2=2 end
		elseif atk>getdef(bt) then cm.ndc_2=0 else cm.ndc_2=3 end
	end
end
function cm.GetFlagEffectLabel(c,code)
	return c:GetFlagEffectLabel(code) or 0
end
function cm.ATTSeries(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53796175,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(cm.ATTSeriescondition)
	e1:SetTarget(cm.ATTSeriestarget)
	e1:SetOperation(cm.ATTSeriesoperation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function cm.ATTSeriescondition(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	if tc==e:GetHandler() or tc:IsFacedown() or tc:IsSummonPlayer(tp) then return false end
	e:SetLabel(tc:GetAttribute())
	return true
end
function cm.ATTSeriesfilter(c,e,tp,att)
	return c:IsAttribute(att) and c:IsLevel(4) and c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.ATTSeriestarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.ATTSeriesfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function cm.ATTSeriesoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.ATTSeriesfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
function cm.ATTSerieslockcon(n,att)
	return  function(e)
				return Duel.IsExistingMatchingCard(function(c,att)return c:IsFaceup() and c:IsAttribute(att)end,math.abs(e:GetHandlerPlayer()-n),LOCATION_MZONE,0,1,nil,att)
			end
end
function cm.BlackLotus(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(0xff)
	e1:SetOperation(cm.BlackLotusop)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end
function cm.BlackLotusop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	if not Party_time_random_seed then
		local result=0
		local g=Duel.GetDecktopGroup(0,5)
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			if code==90846359 then code=53799000 end
			result=result+code
			tc=g:GetNext()
		end
		local g=Duel.GetDecktopGroup(1,5)
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			if code==90846359 then code=53799000 end
			result=result+code
			tc=g:GetNext()
		end
		g:DeleteGroup()
		Party_time_random_seed=result
		function Party_time_roll(min,max)
			if min==max then return min end
			min=tonumber(min)
			max=tonumber(max)
			Party_time_random_seed=(Party_time_random_seed*16807)%2147484647
			if min~=nil then
				if max==nil then
					local random_number=Party_time_random_seed/2147484647
					return (random_number*min)
				else
					local random_number=Party_time_random_seed/2147484647
					if random_number<min then
						Party_time_random_seed=(Party_time_random_seed*16807)%2147484647
						random_number=Party_time_random_seed/2147484647
					end
					return ((max-min)*random_number)+min
				end
			end
			return Party_time_random_seed
		end
		for i=1,100 do Debug.Message(Party_time_roll(0,1.5)) end
	end
end
function cm.AozoraDisZoneGet(c)
	Adzg_cid=_G["c"..c:GetOriginalCode()]
	if not AozoraDisZoneGet_Check then
		AozoraDisZoneGet_Check=true
		local temp1=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			temp1(e,p)
		end
		local temp2=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),0,0
				if e:GetRange() then range=e:GetRange() end
				if e:GetCondition() then con=e:GetCondition() end
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					temp2(c,ex)
					Adzg_cid[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			temp2(c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(53734098)>0 then return end
	c:RegisterFlagEffect(53734098,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=Adzg_cid[e][1],Adzg_cid[e][2],Adzg_cid[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	if range~=0 then e1:SetRange(range) end
	if con~=0 then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
