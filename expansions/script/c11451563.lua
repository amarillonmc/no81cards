--诡雷战术 潜伏诱捕
--21.04.22
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--trap
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	--e3:SetCountLimit(1,m)
	--e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(cm.trcon)
	e3:SetCost(cm.trcost)
	e3:SetTarget(cm.trtg)
	e3:SetOperation(cm.trop)
	c:RegisterEffect(e3)
	local e31=e3:Clone()
	e31:SetType(EFFECT_TYPE_QUICK_O)
	e31:SetCondition(function(e,...) return e:GetHandler():IsFacedown() and cm.trcon(e,...) end)
	e31:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e31)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e41=e4:Clone()
	e41:SetType(EFFECT_TYPE_QUICK_O)
	e41:SetCondition(function(e,...) return e:GetHandler():IsFacedown() and cm.trcon(e,...) end)
	e41:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e41)
	local e5=e3:Clone()
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCondition(cm.con)
	e5:SetTarget(cm.trtg2)
	c:RegisterEffect(e5)
	local e51=e3:Clone()
	e51:SetDescription(aux.Stringid(m,2))
	e51:SetCode(EVENT_CUSTOM+m)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCondition(function(e,tp,eg,ep,...) return ep==1-tp and e:GetHandler():IsFacedown() and #eg>0 end)
	e51:SetTarget(cm.trtg3)
	e51:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	c:RegisterEffect(e51)
	if not cm.global_check then
		cm.global_check=true
		local g=Group.CreateGroup()
		g:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAIN_SOLVED)
		ge2:SetLabelObject(g)
		ge2:SetCondition(cm.clearcon)
		ge2:SetOperation(cm.clear)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge2:Clone()
		ge3:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(ge3,0)
		local ge4=ge1:Clone()
		ge4:SetCode(EVENT_CHAIN_NEGATED)
		ge4:SetCondition(cm.rscon)
		ge4:SetOperation(cm.reset)
		Duel.RegisterEffect(ge4,0)
	end
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	local tf=re:GetHandler():IsRelateToEffect(re)
	local cid=re:GetHandler():GetRealFieldID()
	cm[ev]={re,tf,cid,p,loc}
	re:GetHandler():RegisterFlagEffect(m+1,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
end
function cm.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()>1
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	cm[ev]={re,false,0,0,0}
	re:GetHandler():ResetFlagEffect(m+2)
end
function cm.clearcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	if e:GetCode()==EVENT_CHAIN_NEGATED then cm.reset(e,tp,eg,ep,ev,re,r,rp) end
	local i=1
	local g0=Group.CreateGroup()
	local g1=Group.CreateGroup()
	while cm[i] do
		if type(cm[i])=="table" then
			local te,tf,cid,p,loc=table.unpack(cm[i])
			local tc=te:GetHandler()
			if (tf and p==0 and loc&LOCATION_MZONE~=0 and tc:GetFlagEffect(m+1)>0) then g0:AddCard(tc) end
			if (tf and p==1 and loc&LOCATION_MZONE~=0 and tc:GetFlagEffect(m+1)>0) then g1:AddCard(tc) end
			i=i+1
		end
		cm[i]=nil
		i=i+1
	end
	Duel.RaiseEvent(g0,EVENT_CUSTOM+m,re,r,rp,0,ev)
	Duel.RaiseEvent(g1,EVENT_CUSTOM+m,re,r,rp,1,ev)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local p,loc=Duel.GetChainInfo(0,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	local tc=re:GetHandler()
	return p==1-tp and loc&LOCATION_MZONE~=0
end
function cm.tgfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
end
function cm.trcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.tgfilter,1,nil,1-tp)
end
function cm.trcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:GetEquipTarget() end
	if c:IsFacedown() and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11451561,3)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.SetChainLimit(function(e,ep,tp) return tp==ep end)
	end
	e:SetLabelObject(c:GetEquipTarget())
	Duel.SendtoGrave(c,REASON_COST)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsCanTurnSet()
end
function cm.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) end
	local g=eg:Filter(cm.filter,nil,tp)
	Duel.HintSelection(g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function cm.trtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=re:GetHandler()
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) end
	Duel.HintSelection(eg)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,eg,1,0,0)
end
function cm.trtg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(cm.filter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=eg:Filter(cm.filter,nil,tp)
	if #g>1 then
		g=eg:FilterSelect(cm.filter,1,1,nil,tp)
	end
	Duel.HintSelection(g)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.sfilter(c,e,tp)
	return c:IsSetCard(0x97e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.trop(e,tp,eg,ep,ev,re,r,rp)
	local spg=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if #spg>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(11451561,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=spg:Select(tp,1,1,nil)
		if sg and #sg>0 then
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	Duel.AdjustAll()
	local c=e:GetHandler()
	local rc=e:GetLabelObject()
	local g=Group.CreateGroup()
	if e:GetCode()==EVENT_CHAINING then
		g=Group.FromCards(re:GetHandler()):Filter(Card.IsRelateToEffect,nil,e)
	else
		g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	end
	if Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)~=0 and rc:IsLocation(LOCATION_MZONE) and rc:IsFaceup() then
		local og=Duel.GetOperatedGroup():Filter(Card.IsFacedown,nil)
		local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ft<=0 then return elseif ft>#og then ft=#og end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		for i=1,ft do
			local tc=og:GetFirst()
			if #og>1 then tc=og:Select(tp,1,1,nil):GetFirst() end
			og:RemoveCard(tc)
			if Duel.Equip(tp,tc,rc,false,true) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetLabelObject(rc)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(cm.eqlimit)
				tc:RegisterEffect(e1)
			end
		end
		Duel.EquipComplete()
	end
end