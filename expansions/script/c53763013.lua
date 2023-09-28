local m=53763013
local cm=_G["c"..m]
cm.name="本能抑制"
cm.Snnm_Ef_Rst=true
if not require and Duel.LoadScript then
    function require(str)
        local name=str
        for word in string.gmatch(str,"%w+") do
            name=word
        end
        Duel.LoadScript(name..".lua")
        return true
    end
end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	Duel.RegisterFlagEffect(0,m,0,0,0)
	SNNM.AllEffectReset(c)
	aux.AddCodeList(c,53763001)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.cecon)
	e2:SetTarget(cm.cetg)
	e2:SetOperation(cm.ceop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(sc,se,bool)
			if se:GetCode()==EFFECT_DESTROY_REPLACE then
				local tg=se:GetTarget()
				se:SetTarget(function(e,tp,eg,ep,ev,re,...)
					if re:GetFieldID()==Duel.GetFlagEffectLabel(0,m) then return false end
					return tg(e,tp,eg,ep,ev,re,...)
				end)
			end
			return cm[1](sc,se,bool)
		end
		cm[2]=Duel.RegisterEffect
		Duel.RegisterEffect=function(se,sp)
			if se:GetCode()==EFFECT_DESTROY_REPLACE then
				local tg=se:GetTarget()
				se:SetTarget(function(e,tp,eg,ep,ev,re,...)
					if re:GetFieldID()==Duel.GetFlagEffectLabel(0,m) then return false end
					return tg(e,tp,eg,ep,ev,re,...)
				end)
			end
			return cm[2](se,sp)
		end
	end
end
function cm.cecon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsCode(53763001)
end
function cm.cetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and Duel.IsExistingMatchingCard(cm.desfilter,rp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cm.ceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.repop)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if not tc then return end
	local le1={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_EFFECT)}
	local le2={tc:IsHasEffect(EFFECT_INDESTRUCTABLE)}
	local le3={tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)}
	local ret1,ret2={},{}
	for _,v in pairs(le1) do
		local val=v:GetValue()
		if not val then val=aux.TRUE end
		table.insert(ret1,v)
		table.insert(ret2,val)
		v:SetValue(cm.chval(val,e))
	end
	for _,v in pairs(le2) do
		local val=v:GetValue()
		if not val then val=aux.TRUE end
		table.insert(ret1,v)
		table.insert(ret2,val)
		v:SetValue(cm.chval(val,e))
	end
	for _,v in pairs(le3) do
		local val=v:GetValue()
		if not val then val=aux.TRUE end
		table.insert(ret1,v)
		table.insert(ret2,val)
		v:SetValue(cm.chval(val,e))
	end
	Duel.SetFlagEffectLabel(0,m,e:GetFieldID())
	Duel.Destroy(Group.FromCards(e:GetHandler(),tc),REASON_EFFECT)
	for i=1,#ret1 do ret1[i]:SetValue(ret2[i]) end
	Duel.SetFlagEffectLabel(0,m,0)
end
function cm.chval(_val,ce)
	return function(e,te,...)
				if te==ce then return false end
				return _val(e,te,...)
			end
end
