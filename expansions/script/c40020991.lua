--勇劫神王 卡俄斯
local s,id=GetID()
s.named_with_Soldier=1

function s.Soldier(c)
	local m = _G["c"..c:GetCode()]
	return m and m.named_with_Soldier
end

function s.initial_effect(c)
	aux.AddCodeList(c,40020965)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,10,2)
	
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_GRAVE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e0:SetCondition(s.sprcon)
	e0:SetOperation(s.sprop)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id+1)
	e1:SetTarget(s.efftg)
	e1:SetOperation(s.effop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetCost(s.atkcost)
	e2:SetTarget(s.atktg)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end

function s.sprfilter(c,tp)
	return s.Soldier(c) and c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
end

function s.sprcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetFlagEffect(tp,id)==0 
		and eg:IsExists(s.sprfilter,1,nil,tp)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end

function s.sprop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	local c=e:GetHandler()
	local g=eg:Filter(s.sprfilter,nil,tp)
	if #g==0 then return end
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
			c:SetMaterial(g)
			Duel.Overlay(c,g)
			Duel.SpecialSummon(c,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			c:CompleteProcedure()
		end
	end
end


function s.efffilter(c,e,tp,eg,ep,ev,re,r,rp)
	local m=_G["c"..c:GetCode()]
	if not (s.Soldier(c) and c:IsFaceup() and m and m.soldier_field_effect) then return false end
	local te=m.soldier_field_effect
	local tg=te:GetTarget()
	return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
end

function s.pzone_check(tp)
	local pc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local pc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	return (pc1 and pc1:IsCode(40020965)) or (pc2 and pc2:IsCode(40020965))
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.efffilter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then 
		return s.pzone_check(tp)
			and Duel.IsExistingTarget(s.efffilter,tp,LOCATION_ONFIELD,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.efffilter,tp,LOCATION_ONFIELD,0,1,99,nil,e,tp,eg,ep,ev,re,r,rp)
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local pg=Duel.GetMatchingGroup(function(bc) return bc:IsCode(40020965) and bc:IsFaceup() end,tp,LOCATION_PZONE,0,nil)
	if #pg>0 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local tc=pg:Select(tp,1,1,nil):GetFirst()
		Duel.Overlay(c,tc)
	end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg==0 then return end
	local queue = {}
	for tc in aux.Next(tg) do
		local m=_G["c"..tc:GetCode()]
		if m and m.soldier_field_effect then
			local desc = m.soldier_field_effect:GetDescription()
			table.insert(queue, { card=tc, effect=m.soldier_field_effect, desc=desc })
		end
	end
	while #queue > 0 do
		local idx = 1
		if #queue > 1 then
			local descs = {}
			for i,v in ipairs(queue) do table.insert(descs, v.desc) end
			idx = Duel.SelectOption(tp, table.unpack(descs)) + 1
		end
		local item = queue[idx]
		local te = item.effect
		local tc = item.card
		Duel.ClearTargetCard()
		e:SetLabelObject(tc)
		local tg_func = te:GetTarget()
		if tg_func then tg_func(e,tp,eg,ep,ev,re,r,rp,1) end
		local op_func = te:GetOperation()
		if op_func then op_func(e,tp,eg,ep,ev,re,r,rp) end
		Duel.ClearOperationInfo(0) 
		table.remove(queue, idx)
	end
end

function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler()==e:GetHandler() then return true end
	local rc=re:GetHandler()
	if s.Soldier(rc) then
		local m=_G["c"..rc:GetCode()]
		if m and m.soldier_field_effect and re:GetDescription()==m.soldier_field_effect:GetDescription() then
			return true
		end
	end
	return false
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.Soldier(chkc) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(function(c) return c:IsFaceup() and s.Soldier(c) end,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,function(c) return c:IsFaceup() and s.Soldier(c) end,tp,LOCATION_MZONE,0,1,1,nil)
end

function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(4000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e2)
	end
end
