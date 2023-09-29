local m=53733008
local cm=_G["c"..m]
cm.name="黄昏凝滞之园"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm.flp=Duel.GetLP(0)
		cm.slp=Duel.GetLP(1)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
cm.toss_dice=true
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsSetCard(0xa530) and rc:IsType(TYPE_TOKEN) then
		Duel.RegisterFlagEffect(0,m+rc:GetCode(),0,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetLabel(rc:GetCode())
		e1:SetLabelObject(re)
		e1:SetOperation(cm.reset)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,rp)
	end
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local ct=Duel.GetFlagEffect(0,m+code)-1
	Duel.ResetFlagEffect(0,m+code)
	for i=1,ct do Duel.RegisterFlagEffect(0,m+code,0,0,0) end
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,3))
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,m+1,0,TYPES_TOKEN_MONSTER,0,0,1,RACE_FIEND,ATTRIBUTE_DARK) then return end
	local fid=e:GetHandler():GetFieldID()
	local token=Duel.CreateToken(tp,m+1)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	token:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(token)
	e1:SetCondition(cm.descon)
	e1:SetOperation(cm.desop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetLabel(3)
	e2:SetValue(cm.effectfilter)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetLabel(4)
	Duel.RegisterEffect(e3,tp)
	e2:SetLabelObject(e3)
	e3:SetLabelObject(token)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e0:SetLabelObject(e2)
	e0:SetOperation(cm.chk)
	token:RegisterEffect(e0,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e4,true)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(3)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(cm.eqtg)
	e5:SetOperation(cm.eqop)
	e5:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e5,true)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetLabelObject(e5)
	--e6:SetCondition(cm.costcon)
	e6:SetCost(cm.costchk)
	e6:SetTarget(cm.costtg)
	e6:SetOperation(cm.costop)
	e6:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e6,true)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_EQUIP)
	e7:SetOperation(cm.count)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e7,true)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,2))
	e8:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_CHAINING)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(cm.tdcon)
	e8:SetTarget(cm.tdtg)
	e8:SetOperation(cm.tdop)
	token:RegisterEffect(e8,true)
	if not token:IsType(TYPE_EFFECT) then
		local e9=Effect.CreateEffect(c)
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_ADD_TYPE)
		e9:SetValue(TYPE_EFFECT)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e9,true)
	end
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(m,3))
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c,ec)return c:GetEquipTarget()==ec end,nil,e:GetHandler())
	for tc in aux.Next(g) do e:GetHandler():RegisterFlagEffect(m+tc:GetCode(),RESET_EVENT+RESETS_STANDARD,0,0) end
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc
	if e:GetLabel()==3 then tc=e:GetLabelObject():GetLabelObject() else tc=e:GetLabelObject() end
	return tc and tc==te:GetHandler()
end
function cm.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	local te=c:GetReasonEffect()
	if c:GetFlagEffect(m)==0 or not te or not te:IsActivated() or te:GetHandler()~=c then
		e3:Reset()
		e4:Reset()
	else
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_CHAIN_END)
		e0:SetLabelObject(e3)
		e0:SetOperation(cm.resetop)
		Duel.RegisterEffect(e0,tp)
	end
end
function cm.resetop(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e4=e3:GetLabelObject()
	e3:Reset()
	e4:Reset()
	e:Reset()
end
function cm.eqfilter(c,tc)
	return c:IsSetCard(0xa530) and not c:IsForbidden()
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local dc=Duel.TossDice(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=g:SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EQUIP_LIMIT)
		e0:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		e0:SetValue(cm.eqlimit)
		tc:RegisterEffect(e0)
		if tc:GetOriginalLevel()==dc and c:GetFlagEffect(m+tc:GetCode())==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	end
end
function cm.eqlimit(e,c)
	return e:GetOwner()==c
end
function cm.cfilter(c)
	return c:IsSetCard(0xa530) and c:IsAbleToDeckAsCost() and c:IsFaceup()
end
function cm.costcon(e)
	return Duel.IsExistingMatchingCard(cm.cfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.costchk(e,te_or_c,tp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function cm.costtg(e,te,tp)
	return te==e:GetLabelObject()
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsSetCard(0xa530) and rc:IsType(TYPE_TOKEN)
end
function cm.tdfilter(c)
	if c:IsLocation(LOCATION_EXTRA) and c:IsFacedown() then return false end
	if c:IsLocation(LOCATION_DECK+LOCATION_EXTRA) and c:GetOwner()==c:GetControler() then return false end
	return c:IsAbleToDeck()
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(0,m+rc:GetCode())==11 end
	e:SetLabel(rc:GetCode())
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0x7f,0x7f,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0x7f)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(cm.tdfilter,tp,0x7f,0x7f,nil)
	if aux.NecroValleyNegateCheck(sg) then return end
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if #g==0 then return end
	local cg=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	if cg:IsExists(Card.IsControler,1,nil,tp) then Duel.ShuffleDeck(tp) end
	if cg:IsExists(Card.IsControler,1,nil,1-tp) then Duel.ShuffleDeck(1-tp) end
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
	Duel.SetLP(0,cm.flp)
	Duel.SetLP(1,cm.slp)
	Duel.RegisterFlagEffect(0,e:GetCode()+50,0,0,0)
end
