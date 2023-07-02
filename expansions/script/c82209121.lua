--混沌No.88 机关傀儡-命运狮子·嘲笑命运
local m=82209121
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon  
	aux.AddXyzProcedure(c,nil,9,3,cm.ovfilter,aux.Stringid(m,0),3,cm.xyzop)  
	c:EnableReviveLimit()
	--register
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetCondition(cm.rgcon)
	e0:SetOperation(cm.rgop)
	Duel.RegisterEffect(e0,tp)
	--cannot announce  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)  
	e1:SetTargetRange(LOCATION_MZONE,0)  
	e1:SetTarget(cm.antarget)  
	c:RegisterEffect(e1) 
	--attack all  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_SINGLE)  
	e2:SetCode(EFFECT_ATTACK_ALL)  
	e2:SetValue(1)  
	c:RegisterEffect(e2)  
	--destroy replace  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)  
	e3:SetCode(EFFECT_DESTROY_REPLACE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetTarget(cm.reptg)  
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)  
	e4:SetCode(EVENT_BATTLE_DESTROYING)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCondition(cm.wincon)  
	e4:SetOperation(cm.winop)  
	c:RegisterEffect(e4)   
end
cm.xyz_number=88  
function cm.ovfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x1083) and c:IsRankBelow(8)
end  
function cm.xyzop(e,tp,chk)  
	if chk==0 then return Duel.GetFlagEffect(tp,m)~=0 and Duel.GetFlagEffect(tp,m+10000)==0 end  
	Duel.RegisterFlagEffect(tp,m+10000,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)  
end  
function cm.rgfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1083) and c:IsControler(tp)
end
function cm.rgcon(e,tp,eg,ep,ev,re,r,rp)  
	return rp==1-tp and bit.band(r,REASON_EFFECT)~=0 and eg:IsExists(cm.rgfilter,1,nil,tp)
end  
function cm.rgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end 
function cm.antarget(e,c)  
	return c~=e:GetHandler()  
end  
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)  
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end  
	if Duel.SelectEffectYesNo(tp,c,96) then  
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)  
		return true  
	else return false end  
end  
function cm.wincon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local bc=c:GetBattleTarget()
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and bc:GetOwner()==1-tp and not bc:IsType(TYPE_TOKEN)
end  
function cm.winop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	c:RegisterFlagEffect(m+20000,RESET_EVENT+RESETS_STANDARD,0,0)  
	if c:GetFlagEffect(m+20000)>4 then 
		Duel.Win(tp,0x4)  
	end  
end  