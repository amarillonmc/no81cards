SNNM=SNNM or {}
local cm=SNNM
--
function cm.AllGlobalCheck(c)
	if not cm.global_check then
		cm.global_check=true
		local x=c:GetOriginalCodeRule()
		if x>=53707000 and x<=53707099 then
			local alle1=Effect.CreateEffect(c)
			alle1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle1:SetCode(EFFECT_SEND_REPLACE)
			alle1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle1:SetTarget(cm.PeacechoToDeckTarget1)
			alle1:SetValue(function(e,c) return false end)
			Duel.RegisterEffect(alle1,0)
			local alle2=Effect.CreateEffect(c)
			alle2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle2:SetCode(EFFECT_SEND_REPLACE)
			alle2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			alle2:SetTarget(cm.PeacechoToDeckTarget2)
			alle2:SetValue(function(e,c) return c:GetFlagEffect(53707099)>0 end)
			Duel.RegisterEffect(alle2,0)
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
		end
		if x>=53713000 and x<=53713099 then
			local alle3=Effect.CreateEffect(c)
			alle3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle3:SetCode(EVENT_SSET)
			alle3:SetOperation(cm.ALCYakuCheck)
			Duel.RegisterEffect(alle3,0)
		end
		if x>=53703000 and x<=53703099 then
			local alle4=Effect.CreateEffect(c)
			alle4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			alle4:SetCode(EVENT_SPSUMMON_SUCCESS)
			alle4:SetOperation(cm.OSCheck)
			Duel.RegisterEffect(alle4,0)
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
function cm.UpConfirm()
	local UCg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_DECK,0,nil)
	if #UCg>0 then Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(53702500,2)) end
	if #UCg==1 then UCg:Select(tp,1,1,nil) elseif #UCg>1 then Duel.ConfirmCards(tp,UCg) end
end
function cm.Peacecho(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DECK_REVERSE_CHECK)
	if c:GetOriginalType()&TYPE_MONSTER~=0 then
		local e4=Effect.CreateEffect(c)
		e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e4:SetCode(EVENT_DRAW)
		e4:SetTarget(cm.PeacechoDrawTarget)
		e4:SetOperation(cm.PeacechoDrawOperation)
		c:RegisterEffect(e4)
	end
	if c:GetOriginalType()&0x20004~=0 then
		local e5=Effect.CreateEffect(c)
		e5:SetCategory(CATEGORY_DRAW)
		e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e5:SetCode(EVENT_DRAW)
		e5:SetTarget(cm.PeacechoDrawTarget2)
		e5:SetOperation(cm.PeacechoDrawOperation2)
		c:RegisterEffect(e5)
	end
	if c:GetOriginalType()&TYPE_FIELD~=0 then
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_DRAW)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e6:SetCode(EVENT_DRAW)
		e6:SetTarget(cm.PeacechoDrawTarget3)
		e6:SetOperation(cm.PeacechoDrawOperation3)
		c:RegisterEffect(e6)
	end
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e9:SetRange(LOCATION_HAND+LOCATION_DECK)
	e9:SetOperation(cm.UpRegi)
	c:RegisterEffect(e9)
end
function cm.PeacechoRepFilter(c)
	return c:GetDestination()==LOCATION_GRAVE and c:IsOriginalSetCard(0x3537) and not c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT) and c:GetOriginalType()&TYPE_PENDULUM==0
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
function cm.FanippetTrap(c,lpc,code,atk,def,rac,att)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53702500,0))
	e1:SetCode(EVENT_CUSTOM+code)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.FanippetTrapSPCondition)
	e1:SetCost(cm.FanippetTrapSPCost(code))
	e1:SetTarget(cm.FanippetTrapSPTarget(code,atk,def,rac,att))
	e1:SetOperation(cm.FanippetTrapSPOperation(lpc,code,atk,def,rac,att))
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	c:RegisterEffect(e2)
	local e21=e1:Clone()
	e21:SetCode(EVENT_FREE_CHAIN)
	e21:SetProperty(0)
	e21:SetCondition(function(e)return false end)
	c:RegisterEffect(e21)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetCost(cm.GraveActCostchk)
	e4:SetTarget(cm.GraveActCostTarget)
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
function cm.GraveActCostTarget(e,te,tp)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.GraveActCostOp(e,tp,eg,ep,ev,re,r,rp)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
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
	end
end
function cm.FanippetTrapSPTarget(code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c:IsLocation(LOCATION_HAND) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x353b,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att)) end
		if not c:IsPreviousLocation(LOCATION_HAND) then
			e:SetCategory(CATEGORY_SPECIAL_SUMMON)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
		end
		e:SetLabel(c:GetPreviousLocation())
	end
end
function cm.FanippetTrapSPOperation(lpc,code,atk,def,rac,att)
	return
	function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or e:GetLabel()==LOCATION_HAND then return end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,code,0x353b,TYPES_NORMAL_TRAP_MONSTER,atk,def,4,rac,att) then
			c:AddMonsterAttribute(TYPE_NORMAL+TYPE_TRAP)
			if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
				Duel.SetLP(tp,Duel.GetLP(tp)-lpc)
				if e:GetLabel()==LOCATION_GRAVE then
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(53702500,5))
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
					e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					e1:SetValue(LOCATION_REMOVED)
					c:RegisterEffect(e1,true)
				end
			end
		end
	end
end
--
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
			Debug.Message("注：宣言的数字对应确认的卡的顺序（顺序与消息记录相同）")
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
function cm.HTFPlacePZone(c,lv,loc,lab,event,code)
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
	local e0=Effect.CreateEffect(c)
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
	c:RegisterEffect(e02)
	local e03=e02:Clone()
	e03:SetLabelObject(e01)
	c:RegisterEffect(e03)
	--local e04=Effect.CreateEffect(c)
	--e04:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	--e04:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	--e04:SetCode(EVENT_ADJUST)
	--e04:SetRange(LOCATION_HAND)
	--e04:SetOperation(cm.SorisonAntiRepeat)
	--c:RegisterEffect(e04)
end
function cm.Sorisonsynfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function cm.Sorisonsynfilter2(c,syncard,tuner,f)
	return c:IsOriginalSetCard(0xa531) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
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
	return c:IsOriginalSetCard(0xa531) and c:IsNotTuner(syncard)
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
		e2:SetCondition(cm.SRoverDrawCon)
		e2:SetOperation(cm.SRoverDrawOp)
		c:RegisterEffect(e2)
	end
end
function cm.SRoverDrawCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsPreviousPosition(POS_FACEUP)
end
function cm.SRoverDrawOp(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetDrawCount(tp)
	if ct>3 then return end
	local c=e:GetHandler()
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
				if te then
					Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
				else
					Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
				end
				tc=sg:GetNext()
			end
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local sg=Duel.SelectMatchingCard(tp,cm.MRSYakuspfilter1,tp,LOCATION_HAND+LOCATION_GRAVE,0,num,num,c,e,tp,typ)
			local tc=sg:GetFirst()
			while tc do
				local te=tc:IsHasEffect(53711009,tp)
				if te then
					Duel.Remove(tc,POS_FACEUP,REASON_COST+REASON_REPLACE)
				else
					Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
				end
				tc=sg:GetNext()
			end
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
function cm.HartrazLink(c,marker)
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
		c:SetMaterial(sg2)
		Duel.SendtoGrave(sg2,REASON_MATERIAL+REASON_LINK)
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
		Debug.Message(c:GetLinkMarker())
	end
end
