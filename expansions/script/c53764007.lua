local m=53764007
local cm=_G["c"..m]
cm.name="天土神 本查尔"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRIBUTE_LIMIT)
	e2:SetValue(function(e,c)return not c:IsSummonType(SUMMON_TYPE_ADVANCE)end)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.adjustop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1104)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(aux.SpiritReturnConditionForced)
	e5:SetTarget(aux.SpiritReturnTargetForced)
	e5:SetOperation(aux.SpiritReturnOperation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCondition(aux.SpiritReturnConditionOptional)
	e6:SetTarget(aux.SpiritReturnTargetOptional)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetOperation(cm.win)
	c:RegisterEffect(e7)
	if not cm.global_check then
		cm.global_check=true
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(sc,se,bool)
			if se:GetCode()==EVENT_PHASE+PHASE_END and se:GetCategory()&CATEGORY_TOHAND~=0 and se:GetRange()&LOCATION_MZONE~=0 then
				local ex1=Effect.CreateEffect(sc)
				ex1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				ex1:SetCode(EVENT_CHAINING)
				ex1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				ex1:SetRange(LOCATION_MZONE)
				ex1:SetLabelObject(se)
				ex1:SetCondition(cm.condition)
				ex1:SetOperation(cm.count)
				cm[1](sc,ex1,true)
				local ex2=Effect.CreateEffect(sc)
				ex2:SetType(EFFECT_TYPE_SINGLE)
				ex2:SetCode(m)
				ex2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				ex2:SetRange(LOCATION_MZONE)
				ex2:SetLabelObject(se)
				ex2:SetCondition(cm.condition2)
				cm[1](sc,ex2,true)
			end
			return cm[1](sc,se,bool)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	if not se then
		e:Reset()
		return false
	end
	return re==se and re:GetHandler()==e:GetHandler() and e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():IsFaceup()
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local se=e:GetLabelObject()
	if not se then
		e:Reset()
		return false
	end
	return se
end
function cm.count(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW,0,1)
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m+25)>0 then return end
	c:RegisterFlagEffect(m+25,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW,0,1)
	c:RegisterFlagEffect(m+50,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DRAW)
	e1:SetOperation(cm.reset)
	c:RegisterEffect(e1,true)
end
function cm.reset(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m+50)>0 then return end
	e:Reset()
	local g=Duel.GetMatchingGroup(function(c)return c:IsHasEffect(m) and c:GetFlagEffect(m)==0 and c:IsType(TYPE_SPIRIT)end,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_CARD,0,m)
	for tc in aux.Next(g) do
		if tc:AddCounter(0x153e,2) and tc:GetFlagEffect(m+75)==0 then
			tc:RegisterFlagEffect(m+75,RESET_EVENT+RESETS_STANDARD,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(cm.immval)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.immval(e,te)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local eset={c:IsHasEffect(m+50)}
	local res=te:GetOwner()~=e:GetOwner() and c:IsCanRemoveCounter(tp,0x153e,1,REASON_EFFECT)
	local ctns=false
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		for _,se in pairs(eset) do
			if se:GetLabelObject()==te then ctns=true end
		end
	end
	if res and not ctns then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(m+50)
		e1:SetLabelObject(te)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetLabelObject(c)
		e2:SetOperation(cm.imcop)
		Duel.RegisterEffect(e2,tp)
	end
	return res
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():RemoveCounter(tp,0x153e,1,REASON_EFFECT)
	e:Reset()
end 
function cm.win(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCounter(tp,1,0,0x153e)>9 then Duel.Win(tp,0x17) end
end
