--异宇宙燃烧龙
local s,id,o=GetID()
function s.initial_effect(c)
s.code=29010550
s.side_code=29010551
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot side
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_TURN_SET)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.poscon1)
	c:RegisterEffect(e0)
	local e0_1=Effect.CreateEffect(c)
	e0_1:SetType(EFFECT_TYPE_SINGLE)
	e0_1:SetCode(EFFECT_CANNOT_TURN_SET)
	e0_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0_1:SetCondition(s.poscon2)
	c:RegisterEffect(e0_1)
	--change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(s.bdocon)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetDescription(aux.Stringid(id,0))
	e2_1:SetCategory(CATEGORY_DAMAGE)
	e2_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2_1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2_1:SetRange(LOCATION_MZONE)
	e2_1:SetCountLimit(1)
	e2_1:SetCondition(s.evocon)
	e2_1:SetCost(s.evocost)
	e2_1:SetTarget(s.evotg)
	e2_1:SetOperation(s.evoop)
	c:RegisterEffect(e2_1)
	local e3_1=Effect.CreateEffect(c)
	e3_1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3_1:SetRange(LOCATION_MZONE)
	e3_1:SetCode(EFFECT_SEND_REPLACE)
	e3_1:SetTarget(s.reptg)
	e3_1:SetValue(s.repval)
	e3_1:SetOperation(s.repop)
	c:RegisterEffect(e3_1)
	if not s.Side_Check then
		s.Side_Check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_UNCOPYABLE)
		ge0:SetCondition(s.backon)
		ge0:SetOperation(s.backop)
		Duel.RegisterEffect(ge0,tp)
	end
end
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()~=LOCATION_OVERLAY
end
function s.repfilter2(c,e)
	return c:IsLocation(LOCATION_ONFIELD) and c:GetDestination()~=LOCATION_OVERLAY and c~=e:GetHandler()
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.repfilter,1,nil,tp) and e:GetHandler():GetFlagEffect(29010549)>0 end
	local g=eg:Filter(s.repfilter2,nil,e)
	e:SetLabelObject(g)
	return true
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=e:GetLabelObject()
	if not c:IsLocation(LOCATION_MZONE) then return end
	if #g>0 then
		Duel.Overlay(c,Group.FromCards(g))
	end
end
function s.poscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():GetFlagEffect(29010549)==0
end
function s.poscon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_MZONE) and e:GetHandler():GetFlagEffect(29010549)>0
end
function s.checkitside(c)
	return c.code and c.side_code and c:GetFlagEffect(29010549)==0 and c:GetOriginalCode()==c.side_code
end
function s.backon(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.checkitside,tp,0x7f,0x7f,nil)
	return dg:GetCount()>0
end
function s.backop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(s.checkitside,tp,0x7f,0x7f,nil)
	for c in aux.Next(dg) do
		local tcode=c.code
		c:SetEntityCode(tcode)
		if c:IsFacedown() then
			Duel.ConfirmCards(1-tp,Group.FromCards(c))
		end
		c:ReplaceEffect(tcode,0,0)
		Duel.Hint(HINT_CARD,0,tcode)
		if c:IsLocation(LOCATION_HAND) then
			local sp=c:GetControler()
			Duel.ShuffleHand(sp)
		end
	end
	Duel.Readjust()
end
function s.bdocon(e,tp,eg,ep,ev,re,r,rp)
	return aux.bdocon(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():GetFlagEffect(29010549)==0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:GetFlagEffect(29010549)==0 and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() then
		Duel.Hint(HINT_CARD,0,29010551)
		local sidecode=c.side_code
		c:SetEntityCode(sidecode)
		c:RegisterFlagEffect(29010549,RESET_EVENT+0x7e0000,0,0)
	end
	if not (bc:IsLocation(LOCATION_GRAVE) or bc:IsFaceup() and bc:IsLocation(LOCATION_EXTRA+LOCATION_REMOVED)) then return end
	if c:IsType(TYPE_XYZ) and bc:IsCanOverlay() and not bc:IsImmuneToEffect(e) then
		Duel.Overlay(c,bc)
	end
end
function s.evocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(29010549)>0
end
function s.evocost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,tp,HINTMSG_OPERATECARD)
	local ct2=e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
	e:SetLabel(ct2)
end
function s.evotg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function s.evoop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local bc=c:GetBattleTarget()
	if c:GetFlagEffect(29010549)>0 then
		Duel.Hint(HINT_CARD,0,29010550)
		local sidecode=c.code
		c:SetEntityCode(sidecode)
		c:ResetFlagEffect(29010549)
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end