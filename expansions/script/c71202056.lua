--拥簇 迷失耀斑
local s,id,o=GetID()
function s.initial_effect(c)
	--①：可以从以下选择1个发动
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--②：这张卡在墓地存在的状态，自己场上的「迷失耀斑」怪兽被除外的场合才能发动。这张卡在自己场上盖放。这个效果盖放的卡从场上离开的场合除外
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
-- ① target
function s.rmcountfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x089d) and c:IsType(TYPE_MONSTER)
end
function s.op1filter(c)
	return c:IsFaceup()
end
function s.op2filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x089d) and c:IsType(TYPE_XYZ)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(s.rmcountfilter,tp,LOCATION_REMOVED,0,nil)
	local b1=ct>0 and Duel.IsExistingMatchingCard(s.op1filter,tp,0,LOCATION_MZONE,1,nil)
	local b2=Duel.IsExistingTarget(s.op2filter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(id,2)
		opval[off]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,3)
		opval[off]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op+1]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,s.op2filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		s.op1(e,tp,eg,ep,ev,re,r,rp)
	else
		s.op2(e,tp,eg,ep,ev,re,r,rp)
	end
end
-- option 1: opponent's monsters lose ATK/DEF
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.rmcountfilter,tp,LOCATION_REMOVED,0,nil)
	if ct==0 then return end
	local val=-ct*200
	local g=Duel.GetMatchingGroup(s.op1filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
-- option 2: target 迷失耀斑 Xyz, attach materials, boost others
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	-- attach materials
	local mg=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=Duel.SelectMatchingCard(tp,s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,2,nil)
		if #sg>0 then
			Duel.Overlay(tc,sg)
		end
	end
	-- boost other 迷失耀斑
	local ct=Duel.GetMatchingGroupCount(s.rmcountfilter,tp,LOCATION_REMOVED,0,nil)
	if ct>0 then
		local g=Duel.GetMatchingGroup(s.atkfilter,tp,LOCATION_MZONE,0,tc)
		local atc=g:GetFirst()
		while atc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(ct*200)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			atc:RegisterEffect(e1)
			atc=g:GetNext()
		end
	end
end
function s.matfilter(c)
	return c:IsSetCard(0x089d) and not c:IsCode(id) and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x089d)
end
-- ②: GY trigger when 迷失耀斑 banished
function s.setconfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:IsSetCard(0x089d)
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.setconfilter,1,nil,tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SSet(tp,c)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
