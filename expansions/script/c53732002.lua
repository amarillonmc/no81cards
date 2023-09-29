local m=53732002
local cm=_G["c"..m]
cm.name="测试区域2"
cm.Snnm_Ef_Rst=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	if not cm.Aozora_Check then
		cm.Aozora_Check=true
		cm[0]=Duel.RegisterEffect
		Duel.RegisterEffect=function(e,p)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local pro,pro2=e:GetProperty()
				pro=pro|EFFECT_FLAG_PLAYER_TARGET
				e:SetProperty(pro,pro2)
				e:SetTargetRange(1,1)
			end
			cm[0](e,p)
		end
		cm[1]=Card.RegisterEffect
		Card.RegisterEffect=function(c,e,bool)
			if e:GetCode()==EFFECT_DISABLE_FIELD then
				local op,range,con=e:GetOperation(),e:GetRange(),e:GetCondition()
				if op then
					local ex=Effect.CreateEffect(c)
					ex:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					ex:SetCode(EVENT_ADJUST)
					ex:SetRange(range)
					ex:SetOperation(cm.exop)
					cm[1](c,ex)
					cm[ex]={op,range,con}
					e:SetOperation(nil)
				else
					local pro,pro2=e:GetProperty()
					pro=pro|EFFECT_FLAG_PLAYER_TARGET
					e:SetProperty(pro,pro2)
					e:SetTargetRange(1,1)
				end
			end
			cm[1](c,e,bool)
		end
	end
end
function cm.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 then return end
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY,0,0)
	local op,range,con=cm[e][1],cm[e][2],cm[e][3]
	local val=op(e,tp)
	if tp==1 then val=((val&0xffff)<<16)|((val>>16)&0xffff) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(range)
	if con then e1:SetCondition(con) end
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_OVERLAY)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=0
		local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
		for _,te in ipairs(ce) do
			local con=te:GetCondition()
			local val=te:GetValue()
			if (not con or con(te)) then
				if val then if aux.GetValueType(val)=="function" then zone=zone+val(te) else zone=zone+val end end
			end
		end
		if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
		return zone&0x1f>0
		--return zone&0x4bb0f>0
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local zone=0
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local con=te:GetCondition()
		local val=te:GetValue()
		if (not con or con(te)) then
			if val then if aux.GetValueType(val)=="function" then zone=zone+val(te) else zone=zone+val end end
		end
	end
	if tp==1 then zone=((zone&0xffff)<<16)|((zone>>16)&0xffff) end
	if zone&0x1f==0 then return end
	--if zone&0x4bb0f==0 then return end
	local z=Duel.SelectField(tp,1,LOCATION_MZONE,0,(~zone)|0xe000e0)
	--local z=Duel.SelectField(tp,1,LOCATION_MZONE,LOCATION_MZONE,(~zone)|0xe000e0)
	Duel.Hint(HINT_ZONE,tp,z)
	if tp==1 then z=((z&0xffff)<<16)|((z>>16)&0xffff) end
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,te in ipairs(ce) do
		local val=te:GetValue()
		if val then
			if aux.GetValueType(val)=="function" then
				cm[te]={val}
				local zone=val(te)
				val=zone
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_ADJUST)
				e1:SetLabel(zone)
				e1:SetLabelObject(te)
				e1:SetOperation(cm.retop)
				Duel.RegisterEffect(e1,tp)
			end
			if z&val~=0 then val=val-z end
			te:SetValue(val)
		end
	end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local zone,te=e:GetLabel(),e:GetLabelObject()
	if not te then
		e:Reset()
		return
	end
	local val=cm[te][1]
	local eval=val(te)
	local res=true
	local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_DISABLE_FIELD)}
	for _,ke in ipairs(ce) do
		if ke==te then res=false end
	end
	if zone~=eval or res then
		te:SetValue(val)
		e:Reset()
	end
end
