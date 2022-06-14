local m=53796003
local cm=_G["c"..m]
cm.name="啦啦队女孩蠍媛"
function cm.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_MOVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	if not cm.Cheer_Girl_Ssrhm then
		cm.Cheer_Girl_Ssrhm=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CONTROL_CHANGED)
		ge2:SetLabelObject(ge1)
		ge2:SetOperation(cm.checkop2)
		Duel.RegisterEffect(ge2,0)
	end
end
cm[0x1],cm[0x2],cm[0x4],cm[0x8],cm[0x10],cm[0x20],cm[0x40],cm[0x10000],cm[0x20000],cm[0x40000],cm[0x80000],cm[0x100000]=0,0,0,0,0,0,0,0,0,0,0,0
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(0)
	if Duel.GetFlagEffect(0,m)==0 then return end
	for tc in aux.Next(eg) do
		local l,s,p=tc:GetPreviousLocation(),tc:GetPreviousSequence(),tc:GetPreviousControler()
		if l==LOCATION_MZONE then
			local z=1<<s
			if p==1 then if s<5 then z=((z&0xffff)<<16)|((z>>16)&0xffff) else z=1<<(11-s) end end
			local flag=Duel.GetFlagEffectLabel(0,m)
			if z&flag~=0 then
				e:SetLabel(z)
				cm[z]=cm[z]+1
			end
		end
	end
end
function cm.checkop2(e,tp,eg,ep,ev,re,r,rp)
	local z=e:GetLabelObject():GetLabel()
	if z~=0 then cm[z]=cm[z]-1 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_MZONE) or c:IsFacedown() then return end
	if Duel.GetFlagEffect(0,m)==0 then Duel.RegisterFlagEffect(0,m,0,0,0) end
	local z=1<<c:GetSequence()
	if tp==1 then if c:GetSequence()<5 then z=((z&0xffff)<<16)|((z>>16)&0xffff) else z=1<<(11-c:GetSequence()) end end
	local flag=Duel.GetFlagEffectLabel(0,m)
	if z&flag==0 then Duel.SetFlagEffectLabel(0,m,flag|z) else return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetLabel(z)
	e1:SetTarget(cm.tg)
	e1:SetValue(cm.val)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end
function cm.tg(e,c)
	local z=1<<c:GetSequence()
	if c:GetControler()==1 then if c:GetSequence()<5 then z=((z&0xffff)<<16)|((z>>16)&0xffff) else z=1<<(11-c:GetSequence()) end end
	return z==e:GetLabel()
end
function cm.val(e,c)
	return cm[e:GetLabel()]*300
end
