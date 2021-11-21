--里魂的显化
local m=16108100
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ANNOUNCE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local code=e:GetHandler():GetCode()
	--c:IsSetCard(0x51) and not c:IsCode(code)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FLIP,OPCODE_ISTYPE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	--effect gain
	local cp={}
	local func=Card.RegisterEffect
	Card.RegisterEffect=function(tc,e,f)
		if e:GetType()&EFFECT_TYPE_FLIP~=0 or (e:GetCode()&EVENT_FLIP~=0 and (e:GetType()&EFFECT_TYPE_QUICK_O~=0 or e:GetType()&EFFECT_TYPE_TRIGGER_O~=0) and e:GetType()&EFFECT_TYPE_SINGLE~=0 ) then
			table.insert(cp,e:Clone())
		end
		return func(tc,e,f)
	end
	Duel.CreateToken(tp,ac)
	for i,v in ipairs(cp) do
		local pro=v:GetProperty()
		if pro&EFFECT_FLAG_DELAY~=0 then
			v:SetProperty(pro-EFFECT_FLAG_DELAY)
		end
		v:SetCode(EVENT_FREE_CHAIN)
		v:SetType(EFFECT_TYPE_QUICK_O)
		v:SetRange(LOCATION_MZONE)
		v:SetCountLimit(1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetLabel(ac)
		e1:SetTarget(cm.eftg)
		e1:SetLabelObject(v)
		Duel.RegisterEffect(e1,tp)
	end
	Card.RegisterEffect=func
end
function cm.eftg(e,c)
	return c:IsOriginalCodeRule(e:GetLabel())
end