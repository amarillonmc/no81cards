if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765009
local cm=_G["c"..m]
cm.name="枷狱最高检察官 审判"
cm.Snnm_Ef_Rst=true
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	SNNM.HelltakerActivate(c,m)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,4))
	e7:SetCategory(CATEGORY_REMOVE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e7:SetCountLimit(1)
	e7:SetTarget(cm.uptg)
	e7:SetOperation(cm.upop)
	c:RegisterEffect(e7)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(m+50) or 0
	if ct==0 or ct>10 then return end
	local eset={c:IsHasEffect(m)}
	local res=true
	for _,v in pairs(eset) do if v:GetLabel()==tp then res=false end end
	if not res then return end
	local eset={c:IsHasEffect(m)}
	for _,v in pairs(eset) do
		v:GetLabelObject():GetLabelObject():GetLabelObject():Reset()
		v:GetLabelObject():GetLabelObject():Reset()
		v:GetLabelObject():Reset()
		v:Reset()
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local zone=Duel.SelectField(tp,ct,0,LOCATION_ONFIELD,0x20e020e0)
	Duel.Hint(HINT_ZONE,tp,zone)
	Duel.Hint(HINT_ZONE,1-tp,zone>>16)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_ONFIELD)
	e1:SetTarget(cm.disable)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabel(zone)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.dis2op)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetLabel(zone)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2,true)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(cm.disable)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	e3:SetLabel(zone)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3,true)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(m)
	e4:SetLabel(tp)
	e4:SetLabelObject(e3)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e4,true)
end
function cm.disable(e,c)
	local zone=e:GetLabel()
	local b1,b2=false,false
	if bit.band(zone,0x1f001f)~=0 then b1=zone&((2^c:GetSequence())*0x10000)~=0 end
	if bit.band(zone,0x1f001f00)~=0 then b2=zone&((2^c:GetSequence())*0x1000000)~=0 end
	return c:IsFaceup() and (b1 or b2)
end
function cm.dis2op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetLabel()
	local loca,seq,p=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE,CHAININFO_TRIGGERING_CONTROLER)
	if bit.band(zone,0x1f001f)~=0 then b1=zone&((2^seq)*0x10000)~=0 end
	if bit.band(zone,0x1f001f00)~=0 then b2=zone&((2^seq)*0x1000000)~=0 end
	if loca&LOCATION_ONFIELD~=0 and p~=tp and re:IsActivated() and (b1 or b2) then
		Duel.NegateEffect(ev)
	end
end
function cm.upfilter(c)
	return aux.nzatk(c) or aux.nzdef(c)
end
function cm.uptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and (aux.nzatk(chkc) or aux.nzdef(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(cm.upfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cm.upfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function cm.upop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel:GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(tc:GetBaseDefense()/2)
		c:RegisterEffect(e2)
		local g=c:GetColumnGroup()
		if tc:IsControler(1-tp) and g:IsContains(tc) then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
	end
end
