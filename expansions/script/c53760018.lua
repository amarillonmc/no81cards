local m=53760018
local cm=_G["c"..m]
cm.name="永远的黄粱梦"
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53760000)
	aux.AddSetNameMonsterList(c,0x9538)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(cm.chcon)
	e2:SetOperation(cm.chop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.destg)
	e3:SetOperation(cm.desop)
	c:RegisterEffect(e3)
end
function cm.ctfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL)
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1,ct2=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_MZONE,0,nil),Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_MZONE,nil)
	if ct1==ct2 then return false end
	local p=tp
	if ct1>ct2 then p=1-tp end
	return ep==p and re:IsActiveType(TYPE_MONSTER) and Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&(LOCATION_MZONE+LOCATION_GRAVE)~=0 and SNNM.DressamLocCheck(p,p,0xff) and Duel.IsPlayerCanSpecialSummonMonster(p,53760000,0x9538,TYPES_TOKEN_MONSTER,0,3000,1,RACE_FIEND,re:GetHandler():GetAttribute())
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	if not SNNM.DressamLocCheck(tp,tp,0xff) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,53760000,0x9538,TYPES_TOKEN_MONSTER,0,3000,1,RACE_FIEND,e:GetHandler():GetAttribute()) then
		local token=Duel.CreateToken(tp,53760000)
		SNNM.DressamSPStep(token,tp,tp,POS_FACEUP,0xff)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetValue(e:GetHandler():GetAttribute())
		token:RegisterEffect(e1,true)
		Duel.SpecialSummonComplete()
	end
end
function cm.filter(c)
	return c:IsType(TYPE_TOKEN) and c:IsFaceup()
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:GetFlagEffect(m)==0 end
	c:RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	if e:GetActivateLocation()==LOCATION_SZONE then c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1) end
	if c:GetFlagEffect(m+50)~=1 then Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0) end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) and c:GetFlagEffect(m+50)~=1 then Duel.Remove(c,POS_FACEUP,REASON_EFFECT) end
end
