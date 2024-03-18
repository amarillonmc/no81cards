if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.BoLiuTuiMi(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.dcon)
	e1:SetTarget(s.dtg)
	e1:SetOperation(s.dop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e2:SetCondition(s.con)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	for i=1,ev do
		local te,rp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if te and te:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return true end
	end
	return false
end
function s.costfilter(c,tp)
	return c:IsCode(id) and Duel.IsExistingTarget(Card.IsType,tp,0x34,0,1,c,TYPE_MONSTER)
end
function s.dtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(0x34) and chkc:IsControler(tp) and chkc:IsType(TYPE_MONSTER) end
	if chk==0 then return e:IsCostChecked() and Duel.CheckReleaseGroup(tp,s.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,s.costfilter,1,99,nil)
	aux.UseExtraReleaseCount(sg,tp)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(Duel.GetOperatedGroup():GetCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,nil,tp,0x34,0,1,1,nil,tp):GetFirst()
	Duel.SetTargetParam(e:GetLabel()*2000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel()*2000)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local c=e:GetHandler()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_DISABLE)
		e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e3:SetRange(0xff)
		e3:SetValue(s.efilter)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
		tc:RegisterEffect(e3)
	end
	Duel.Recover(tp,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM),REASON_EFFECT)
end
function s.efilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	return te:GetHandler()==e:GetHandler()
end
function s.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil) and not eg:IsContains(e:GetHandler())
end
function s.rfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeckAsCost() and c:IsFaceupEx()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.rfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	local cg=Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(cg)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local codes={}
	local nt={}
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	while ct>0 do
		local ac=Duel.AnnounceCard(tp,table.unpack(nt))
		table.insert(codes,ac)
		table.insert(nt,ac)
		table.insert(nt,OPCODE_ISCODE)
		table.insert(nt,OPCODE_NOT)
		if ct<e:GetLabel() then table.insert(nt,OPCODE_AND) end
		ct=ct-1
	end
	getmetatable(e:GetHandler()).announce_filter=nt
	Duel.SetTargetParam(codes[#codes])
	table.remove(codes)
	if #codes==0 then e:SetLabel(0) else e:SetLabel(table.unpack(codes)) end
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local t={e:GetLabel()}
	if t[1]==0 then t={Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)} else table.insert(t,Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetLabel(table.unpack(t))
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+SNNM.GetCurrentPhase())
	Duel.RegisterEffect(e1,tp)
end
function s.aclimit(e,re,tp)
	return not (re:GetHandler():IsOnField() or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and re:GetHandler():IsCode(e:GetLabel())
end
