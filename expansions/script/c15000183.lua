local m=15000183
local cm=_G["c"..m]
cm.name="上古星龙"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf3)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCountLimit(1,15000183+EFFECT_COUNT_CODE_DUEL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.RkXyzCondition(cm.sprfilter,nil,cm.sprop))
	e0:SetTarget(cm.RkXyzTarget(cm.sprfilter,nil,cm.sprop))
	e0:SetOperation(cm.RkXyzOperation(cm.sprfilter,nil,cm.sprop))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--add counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_MOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.ctcon)
	e1:SetOperation(cm.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.Clone(e1)
	e2:SetCode(EVENT_FLIP)
	e2:SetCondition(cm.ct2con)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetTarget(cm.rtg)
	e3:SetValue(cm.rval)
	c:RegisterEffect(e3,true)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CUSTOM+15000184)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetOperation(cm.atop)
	c:RegisterEffect(e4,true)
	--Recover
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_RECOVER)
	e5:SetCondition(cm.rccon)
	e5:SetOperation(cm.rcop)
	c:RegisterEffect(e5)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(m,2))
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FREE_CHAIN)
		ge1:SetCondition(cm.debugcon)
		ge1:SetOperation(cm.debug)
		Duel.RegisterEffect(ge1,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(m,2))
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_FREE_CHAIN)
		ge1:SetCondition(cm.debugcon)
		ge1:SetOperation(cm.debug)
		Duel.RegisterEffect(ge1,1)
	end
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsCanOverlay() and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRank(10)
end
function cm.RkXyzFilter(c,alterf,xyzc,e,tp,op)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0 and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c))
end
function cm.RkXyzCondition(alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(cm.RkXyzFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
			end
end
function cm.RkXyzTarget(alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local b2=(not min or min<=1) and mg:IsExists(cm.RkXyzFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,cm.RkXyzFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.RkXyzOperation(alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local mg=e:GetLabelObject()
				local mg2=mg:GetFirst():GetOverlayGroup()
				if mg2:GetCount()~=0 then
					Duel.Overlay(c,mg2)
				end
				c:SetMaterial(mg)
				Duel.Overlay(c,mg)
				mg:DeleteGroup()
			end
end
function cm.ctcon(e)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousLocation(),LOCATION_MZONE)==0 and c:IsLocation(LOCATION_MZONE)
end
function cm.ct2con(e)
	local c=e:GetHandler()
	return true
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	c:AddCounter(0xf3,12)
end
function cm.defilter(c)
	return c:IsCode(15000183) and c:IsFaceup()
end
function cm.debugcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(cm.defilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetTurnPlayer()==tp
end
function cm.debug(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local x=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local tc=Duel.SelectMatchingCard(tp,cm.defilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc:GetFlagEffectLabel(15000185) then
		x=tc:GetFlagEffectLabel(15000185)
	end
	Debug.Message("查询的「上古星龙」累计的附加伤害值为："..x)
end
function cm.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return (bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetCounter(0xf3)~=0 and c:IsCanRemoveCounter(tp,0xf3,1,REASON_REPLACE) end
	if c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetCounter(0xf3)~=0 and c:IsCanRemoveCounter(tp,0xf3,1,REASON_REPLACE) then
		c:RemoveCounter(tp,0xf3,1,REASON_REPLACE)
		Duel.BreakEffect()
		Duel.Recover(tp,300,REASON_EFFECT)
		if c:GetCounter(0xf3)==0 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+15000184,e,0,0,0,0)
		end
		return true
	else return false end
end
function cm.rval(e,c)
	return false
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	c:RegisterFlagEffect(15000183,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.attcon)
	e1:SetTarget(cm.atttg)
	e1:SetOperation(cm.attop)
	e1:SetReset(RESET_PHASE+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.rccon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local x=0
	if c:GetFlagEffectLabel(15000185) then
		x=c:GetFlagEffectLabel(15000185)
		c:ResetFlagEffect(15000185)
	end
	x=x+ev
	c:RegisterFlagEffect(15000185,RESET_EVENT+RESETS_STANDARD+RESET_CONTROL,0,1,x)
end
function cm.attcon(e)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsAbleToRemove() and c:GetFlagEffectLabel(15000185) and c:GetFlagEffectLabel(15000185)~=0
end
function cm.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return true end
	local x=c:GetFlagEffectLabel(15000185)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(x)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,x)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Damage(p,d,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end