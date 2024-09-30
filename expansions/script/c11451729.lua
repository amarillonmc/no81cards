--璇心救世军-“残雪”
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(cm.indcon)
	e1:SetTarget(cm.indtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetCondition(cm.indcon)
	e2:SetValue(cm.effectfilter)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetValue(cm.effectfilter2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_DISABLE)
	e4:SetTargetRange(LOCATION_ONFIELD,0)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCondition(cm.indcon)
	e4:SetTarget(cm.indtg)
	c:RegisterEffect(e4)
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetCondition(cm.indcon2)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsFaceup))
	e5:SetValue(3000)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCondition(cm.indcon2)
	e6:SetValue(cm.efilter)
	c:RegisterEffect(e6)
	--cannot be link material
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e9)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.mfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()==1-c:GetPreviousControler()
end
function cm.sfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousTypeOnField()&(TYPE_SPELL+TYPE_TRAP)~=0 and (c:IsPreviousPosition(POS_FACEUP) or c:IsPreviousLocation(LOCATION_SZONE)) and c:GetReasonPlayer()==1-c:GetPreviousControler()
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(cm.mfilter,nil)
	for tc in aux.Next(g1) do
		if Duel.GetFlagEffect(tc:GetPreviousControler(),m)==0 then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),m,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,m)>0 and Duel.GetFlagEffect(1,m)>0 then break end
	end
	local g2=eg:Filter(cm.sfilter,nil)
	for tc in aux.Next(g2) do
		if Duel.GetFlagEffect(tc:GetPreviousControler(),m-1)==0 then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),m-1,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,m-1)>0 and Duel.GetFlagEffect(1,m-1)>0 then break end
	end
end
function cm.indcon(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m-1)>0
end
function cm.indcon2(e)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)>0
end
function cm.indtg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.effectfilter(e,ct)
	local te,tp,typ,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TYPE,CHAININFO_TRIGGERING_LOCATION)
	return loc&LOCATION_ONFIELD>0 and tp==e:GetHandlerPlayer() and typ&0x6>0 and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.effectfilter2(e,ct)
	local te,tp,typ,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TYPE,CHAININFO_TRIGGERING_LOCATION)
	return loc&LOCATION_ONFIELD>0 and tp==e:GetHandlerPlayer() and typ&0x6>0
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end