--虚拟YouTuber 有栖与莓
function GetID()
	local str=string.match(debug.getinfo(2,'S')['source'],"c%d+%.lua")
	str=string.sub(str,1,string.len(str)-4)
	local scard=_G[str]
	local s_id=tonumber(string.sub(str,2))
	return scard,s_id
end
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.Tuner(nil),aux.Tuner(nil),nil,aux.NonTuner(nil),2,99)
	c:EnableReviveLimit()
	--matcheck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.valcheck)
	c:RegisterEffect(e1)
	--stats
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(2)
	e2:SetLabelObject(e1)
	e2:SetCondition(s.numcon)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	local e2x=e2:Clone()
	e2x:SetCode(EFFECT_UPDATE_ATTACK)
	e2x:SetLabel(3)
	e2x:SetLabelObject(e1)
	c:RegisterEffect(e2x)
	--battle effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetLabel(4)
	e3:SetLabelObject(e1)
	e3:SetCondition(s.numcon)
	e3:SetTarget(s.drytg)
	e3:SetOperation(s.dryop)
	c:RegisterEffect(e3)
	--dragoon protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(ATTRIBUTE_FIRE)
	e4:SetLabelObject(e1)
	e4:SetCondition(s.attrcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetLabel(ATTRIBUTE_WATER)
	e5:SetLabelObject(e1)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	local attr=0
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if attr&tc:GetAttribute()==0 then
			attr=(attr|tc:GetAttribute())
		end
	end
	local list={ATTRIBUTE_EARTH,ATTRIBUTE_WATER,ATTRIBUTE_FIRE,ATTRIBUTE_WIND,ATTRIBUTE_LIGHT,ATTRIBUTE_DARK,ATTRIBUTE_DIVINE}
	for i=1,#list do
		if attr&list[i]>0 then
			ct=ct+1
		end
	end
	e:SetLabel(ct,attr)
	--hints
	if ct>=4 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	end
	if attr&ATTRIBUTE_WATER>0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,1))
	end
	if attr&ATTRIBUTE_FIRE>0 then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end
function s.numcon(e)
	local n=e:GetLabelObject():GetLabel()
	return n and n>=e:GetLabel()
end
function s.attrcon(e)
	local _,attr=e:GetLabelObject():GetLabel()
	return attr and attr&e:GetLabel()>0
end
--battle effect
function s.drytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetDefense())
end
function s.dryop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		local def=tc:GetDefense()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,def,REASON_EFFECT)
		end
	end
end