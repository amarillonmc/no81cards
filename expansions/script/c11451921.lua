--龙宫城的尖兵 巡海夜叉
local cm,m=GetID()
function cm.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e0:SetCondition(cm.ttcon)
	e0:SetOperation(cm.ttop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	--sp
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	cm.hand_effect=cm.hand_effect or {}
	cm.hand_effect[c]=e1
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCountLimit(1,m+1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(cm.chktg)
		ge0:SetOperation(cm.check0)
		Duel.RegisterEffect(ge0,0)
	end
end
function cm.chktg(e,te,tp)
	e:SetLabelObject(te)
	return true
end
function cm.check0(e,tp,eg,ep,ev,re,r,rp)
	local re=e:GetLabelObject()
	local rc=re:GetOwner()
	if rc:IsOriginalSetCard(0x6978) and rc.hand_effect then
		local te=rc.hand_effect[rc]
		if te:GetOperation()==re:GetOperation() then cm[rc.hand_effect]=Duel.GetTurnCount() end
	end
end
function cm.tbfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsFaceup()
end
function cm.ttcon(e,c,minc)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(cm.tbfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	return minc<=1 and Duel.CheckTribute(c,1,1,g,c:GetControler())
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.tbfilter,tp,LOCATION_MZONE,0,nil)
	local tg=Duel.SelectTribute(tp,c,1,1,g)
	c:SetMaterial(tg)
	Duel.Release(tg,REASON_SUMMON+REASON_MATERIAL)
end
function cm.lfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) --and c:GetReasonPlayer()==1-tp
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(cm.lfilter,1,nil,tp)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local c=e:GetHandler()
	if chk==0 then return ct>0 and Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.acfilter(c,tp,eg,ep,ev,re,r,rp)
	if not c:IsSetCard(0x6978) then return end
	if c:IsType(TYPE_SPELL+TYPE_TRAP) and ((c:CheckActivateEffect(false,false,false)~=nil and c:GetActivateEffect():GetCode()~=EVENT_CHAINING and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)) or (c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true))) then return true end
	local te=c.hand_effect
	if not te or (te[c]:GetCode()==EVENT_CHAINING and te[c]:IsHasType(EFFECT_TYPE_QUICK_O)) or (c:IsType(TYPE_MONSTER) and cm[te] and cm[te]==Duel.GetTurnCount()) then return false end
	te=te[c]
	local con=te:GetCondition() or aux.TRUE
	if te:IsHasType(EFFECT_TYPE_TRIGGER_O) then con=aux.TRUE end
	local cons=false
	local _GetTurnPlayer=Duel.GetTurnPlayer
	local _GetCurrentPhase=Duel.GetCurrentPhase
	for i=0,1 do
		for j=PHASE_MAIN1,PHASE_BATTLE do
			Duel.GetTurnPlayer=function() return i end
			Duel.GetCurrentPhase=function() return j end
			if con(te,tp,eg,ep,ev,re,r,rp) then cons=true break end
		end
	end
	Duel.GetTurnPlayer=_GetTurnPlayer
	Duel.GetCurrentPhase=_GetCurrentPhase
	local cost=te:GetCost() or aux.TRUE
	local tg=te:GetTarget() or aux.TRUE
	return cons and cost(te,tp,eg,ep,ev,re,r,rp,0) and tg(te,tp,eg,ep,ev,re,r,rp,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	if Duel.Draw(tp,ct,REASON_EFFECT)>0 then
		local g=Duel.GetOperatedGroup()
		Duel.ConfirmCards(tp,g)
		local sg=g:Filter(cm.acfilter,nil,tp,eg,ep,ev,re,r,rp)
		if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local c=sg:Select(tp,1,1,nil):GetFirst()
			g:RemoveCard(c)
			local b1,b2=false,false
			if c:IsType(TYPE_SPELL+TYPE_TRAP) and ((c:CheckActivateEffect(false,false,false)~=nil and c:GetActivateEffect():GetCode()~=EVENT_CHAINING and Duel.GetLocationCount(tp,LOCATION_SZONE)>0) or (c:IsType(TYPE_CONTINUOUS) and c:GetActivateEffect():IsActivatable(tp)) or (c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true))) then b1=true end
			local te=c.hand_effect
			if te and not (te[c]:GetCode()==EVENT_CHAINING and te[c]:IsHasType(EFFECT_TYPE_QUICK_O)) and not (c:IsType(TYPE_MONSTER) and cm[te] and cm[te]==Duel.GetTurnCount()) then
				te=te[c]
				local con=te:GetCondition() or aux.TRUE
				if te:IsHasType(EFFECT_TYPE_TRIGGER_O) then con=aux.TRUE end
				local cons=false
				local _GetTurnPlayer=Duel.GetTurnPlayer
				local _GetCurrentPhase=Duel.GetCurrentPhase
				for i=0,1 do
					for j=PHASE_MAIN1,PHASE_BATTLE do
						Duel.GetTurnPlayer=function() return i end
						Duel.GetCurrentPhase=function() return j end
						if con(te,tp,eg,ep,ev,re,r,rp) then cons=true break end
					end
				end
				Duel.GetTurnPlayer=_GetTurnPlayer
				Duel.GetCurrentPhase=_GetCurrentPhase
				local cost=te:GetCost() or aux.TRUE
				local tg=te:GetTarget() or aux.TRUE
				b2=cons and cost(te,tp,eg,ep,ev,re,r,rp,0) and tg(te,tp,eg,ep,ev,re,r,rp,0)
			end
			if b1 and b2 then
				local op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
				if op==0 then b2=false else b1=false end
			end
			local tc=c
			if b1 then
				if tc:CheckActivateEffect(false,false,false)~=nil and c:GetActivateEffect():GetCode()~=EVENT_CHAINING and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
					local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,false,true)
					te:UseCountLimit(tp,1,true)
					local cost=te:GetCost()
					local target=te:GetTarget()
					local operation=te:GetOperation()
					e:SetCategory(te:GetCategory())
					e:SetProperty(te:GetProperty())
					Duel.ClearTargetCard()
					if not tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD) and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then tc:CancelToGrave(false) end
					tc:CreateEffectRelation(te)
					if cost then cost(te,tp,ceg,cep,cev,cre,cr,crp,1) end
					local _GetTurnPlayer=Duel.GetTurnPlayer
					Duel.GetTurnPlayer=function() return 1-tp end
					if target then target(te,tp,ceg,cep,cev,cre,cr,crp,1) end
					Duel.GetTurnPlayer=_GetTurnPlayer
					local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
					if g then
						for fc in aux.Next(g) do
							fc:CreateEffectRelation(te)
						end
					end
					if operation then operation(te,tp,ceg,cep,cev,cre,cr,crp) end
					tc:ReleaseEffectRelation(te)
					if g then
						for fc in aux.Next(g) do
							fc:ReleaseEffectRelation(te)
						end
					end
				elseif tc:IsType(TYPE_FIELD) then
					local te=tc:GetActivateEffect()
					local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
					if fc then
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
					Duel.DisableShuffleCheck()
					Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
					te:UseCountLimit(tp,1,true)
					local tep=tc:GetControler()
					local cost=te:GetCost()
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
					Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
				elseif tc:IsType(TYPE_CONTINUOUS) then
					local te=tc:GetActivateEffect()
					Duel.DisableShuffleCheck()
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					te:UseCountLimit(tp,1,true)
					local tep=tc:GetControler()
					local cost=te:GetCost()
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				end
			end
			if b2 then
				Duel.ConfirmCards(1-tp,tc)
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				local te=tc.hand_effect[tc]
				te:UseCountLimit(tp,1)
				local cost=te:GetCost()
				local target=te:GetTarget()
				local operation=te:GetOperation()
				e:SetCategory(te:GetCategory())
				e:SetProperty(te:GetProperty())
				Duel.ClearTargetCard()
				tc:CreateEffectRelation(te)
				if cost then cost(te,tp,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tp,eg,ep,ev,re,r,rp,1,false,true) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					for fc in aux.Next(g) do
						fc:CreateEffectRelation(te)
					end
				end
				if operation then operation(te,tp,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if g then
					for fc in aux.Next(g) do
						fc:ReleaseEffectRelation(te)
					end
				end
			end
		end
		g=g:Filter(Card.IsControler,nil,tp):Filter(Card.IsLocation,nil,LOCATION_HAND)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE_STEP)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if g and #g>0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	else
		e:SetCategory(CATEGORY_TOHAND)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 and c:IsLocation(LOCATION_HAND) and g and #g>0 then
		local tc=g:GetFirst()
		if tc:IsFaceup() and tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA) and tc:IsReason(REASON_SUMMON) and tc:GetReasonCard()==c and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)>0 then tc:CompleteProcedure() end
	end
end