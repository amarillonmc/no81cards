local m=15000110
local cm=_G["c"..m]
cm.name="跨越世界的足迹·植"
function cm.initial_effect(c)
	--Recording Zone
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_MOVE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(cm.rzcon)
	e0:SetOperation(cm.rzop)
	c:RegisterEffect(e0)
	--Move
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetOperation(cm.moop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.tgcon)
	e2:SetTarget(cm.tgtg)
	e2:SetOperation(cm.tgop)
	c:RegisterEffect(e2)
	--Zone cannot use
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+15000111)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.zntg)
	e3:SetOperation(cm.znop)
	c:RegisterEffect(e3)
end
function cm.rzcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsLocation(LOCATION_MZONE) and (c:GetPreviousSequence()~=c:GetSequence() or tp~=c:GetPreviousControler())
end
function cm.rzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if tp~=c:GetPreviousControler() then
		if c:GetFlagEffect(0)~=0 then c:ResetFlagEffect(0) end
		if c:GetFlagEffect(1)~=0 then c:ResetFlagEffect(1) end
		if c:GetFlagEffect(2)~=0 then c:ResetFlagEffect(2) end
		if c:GetFlagEffect(3)~=0 then c:ResetFlagEffect(3) end
		if c:GetFlagEffect(4)~=0 then c:ResetFlagEffect(4) end
	end
	local seq=c:GetSequence()
	if seq==0 then
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,5))
	end
	if seq==1 then
		c:RegisterFlagEffect(1,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,6))
	end
	if seq==2 then
		c:RegisterFlagEffect(2,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,7))
	end
	if seq==3 then
		c:RegisterFlagEffect(3,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,8))
	end
	if seq==4 then
		c:RegisterFlagEffect(4,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,9))
	end
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=0
	if c:GetFlagEffect(0)~=0 then zone=zone+0x1 end
	if c:GetFlagEffect(1)~=0 then zone=zone+0x2 end
	if c:GetFlagEffect(2)~=0 then zone=zone+0x4 end
	if c:GetFlagEffect(3)~=0 then zone=zone+0x8 end
	if c:GetFlagEffect(4)~=0 then zone=zone+0x10 end
	local zone2=0x1f~zone
	local x=1
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,LOCATION_REASON_TOFIELD,zone2)<=0 then x=2 end
	if x==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
		local nseq=math.log(s,2)
		Duel.MoveSequence(c,nseq)
	end
	if x==2 then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(15000110)==0 and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
	c:RegisterFlagEffect(15000110,RESET_CHAIN+RESET_EVENT+RESETS_STANDARD,0,1)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 or Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	Duel.ConfirmDecktop(1-tp,1)
	local ac=Duel.GetDecktopGroup(tp,1):GetFirst()
	local bc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	local x=2
	if (ac:IsType(TYPE_MONSTER) and bc:IsType(TYPE_MONSTER)) or (ac:IsType(TYPE_SPELL) and bc:IsType(TYPE_SPELL)) or (ac:IsType(TYPE_TRAP) and bc:IsType(TYPE_TRAP)) then x=1 end
	if x==1 then
		if Duel.SendtoGrave(Group.FromCards(ac,bc),REASON_EFFECT)~=0 then
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+15000111,e,0,0,0,0)
		end
	end
	if x==2 then
		local opt=Duel.SelectOption(1-tp,aux.Stringid(m,1),aux.Stringid(m,2))
		if opt==1 then
			Duel.MoveSequence(bc,opt)
		end
		local opt=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		if opt==1 then
			Duel.MoveSequence(ac,opt)
		end
	end
end
function cm.zntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	local zone=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	Duel.Hint(HINT_ZONE,tp,zone)
	if tp==1 then
		zone=((zone&0xffff)<<16)|((zone>>16)&0xffff)
	end
	e:SetLabel(zone)
end
function cm.znop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local zone=e:GetLabel()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetValue(zone)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end