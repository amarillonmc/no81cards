if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetOperation(s.sumop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER+HINTMSG_DESTROY+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_PHASE+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.sdcon)
	e3:SetTarget(s.sdtg)
	e3:SetOperation(s.sdop)
	c:RegisterEffect(e3)
	s.self_destroy_effect=e3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,5))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e4:SetCountLimit(1)
	e4:SetOperation(s.acop)
	c:RegisterEffect(e4)
	local e4_1=e4:Clone()
	e4_1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
	c:RegisterEffect(e4_1)
	local e4_2=e4:Clone()
	e4_2:SetCode(EVENT_PHASE_START+PHASE_MAIN1)
	c:RegisterEffect(e4_2)
	local e4_3=e4:Clone()
	e4_3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	c:RegisterEffect(e4_3)
	local e4_4=e4:Clone()
	e4_4:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
	c:RegisterEffect(e4_4)
	local e4_5=e4:Clone()
	e4_5:SetCode(EVENT_PHASE_START+PHASE_END)
	c:RegisterEffect(e4_5)
	--[[local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(id)
	e4:SetRange(0xff)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e3:SetCondition(s.sdcon)
	e3:SetTarget(s.sdtg)
	e3:SetOperation(s.sdop)
	c:RegisterEffect(e3)
	s.self_destroy_effect=e3
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c)return not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD)end,nil)
	if #g==0 then return end
	g:ForEach(Card.ResetFlagEffect,id+33)
	local phase=Duel.GetCurrentPhase()
	if phase>0x8 and phase<0x100 then phase=0x8 end
	local turn=Duel.GetTurnCount()
	g:ForEach(Card.RegisterFlagEffect,id+33,0,0,0,(turn<<16)|phase)--]]
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac1=Duel.AnnounceCard(tp)
	getmetatable(c).announce_filter={ac1,OPCODE_ISCODE,OPCODE_NOT}
	local ac2=Duel.AnnounceCard(tp,table.unpack(getmetatable(c).announce_filter))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(id)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabel(ac1,ac2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+Duel.GetCurrentPhase())
	c:RegisterEffect(e1,true)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END,0,1)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(id)~=0
end
function s.ctfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:GetBaseAttack()==0 and c:IsCanAddCounter(0x153f,1)
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x153f)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		tc:AddCounter(0x153f,1)
		if tc:GetFlagEffect(53766000)==0 and not tc:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EFFECT_DESTROY_REPLACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetTarget(s.reptg)
			e1:SetOperation(s.repop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			tc:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
		end
		local rg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp):Filter(Card.IsLocation,nil,LOCATION_MZONE)
		if #rg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			local rc=SNNM.Select_1(rg,tp,HINTMSG_DESTROY)
			local atk=rc:GetBaseAttack()
			if Duel.Destroy(rc,REASON_EFFECT)==0 or not c:IsRelateToEffect(e) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
			c:RegisterEffect(e1)
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,3))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end
function s.desfilter(c,tp,ac1,ac2)
	return not c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsCode(ac1,ac2)
end
function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local le={e:GetHandler():IsHasEffect(id)}
	if #le==0 then return false end
	le=le[1]
	return eg:IsExists(s.desfilter,1,nil,tp,le:GetLabel())
end
--[[function s.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	local rc=re:GetHandler()
	local label=rc:GetFlagEffectLabel(id+33) or 0
	local phase=Duel.GetCurrentPhase()
	if phase>0x8 and phase<0x100 then phase=0x8 end
	local turn=Duel.GetTurnCount()
	return rc:IsControler(tp) and loc&LOCATION_ONFIELD~=0 and rc:GetOriginalType()&TYPE_MONSTER~=0 and label~=((turn<<16)|phase)
end--]]
function s.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.filter(c,tc,e,tp,eg,ep,ev,re,r,rp)
	if not (c:IsSetCard(0x5534) and c:IsType(TYPE_TRAP) and c:IsFaceupEx() and c:IsAbleToHand()) then return false end
	--local ce={tc:IsHasEffect(id)}
	--for _,v in pairs(ce) do if c:IsCode(v:GetLabel()) then return false end end
	local le={c:GetActivateEffect()}
	for _,v in pairs(le) do
		local tg=v:GetTarget()
		if not tg or tg(e,tp,eg,ep,ev,re,r,rp,0) then return true end
	end
	return false
end
function s.sdop(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e:GetHandler(),e,tp,eg,ep,ev,re,r,rp):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		local le={tc:GetActivateEffect()}
		--[[local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(id)
		e1:SetLabel(tc:GetCode())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+Duel.GetCurrentChain())
		e:GetHandler():RegisterEffect(e1)
		while res do
			res=false
			for k,v in pairs(le) do
				local gtg=v:GetTarget()
				if gtg and not gtg(e,tp,eg,ep,ev,re,r,rp,0) then table.remove(le,k) res=true break end
			end
		end--]]
		local te=le[1]
		local sel={}
		if #le>1 then
			for k,v in pairs(le) do
				local t=v:GetTarget()
				local t={not t or t(e,tp,eg,ep,ev,re,r,rp,0),v:GetDescription(),v}
				table.insert(sel,t)
			end
			te=aux.SelectFromOptions(tp,table.unpack(sel))
		end
		local tg=te:GetTarget()
		local op=te:GetOperation()
		local pr1,pr2=e:GetProperty()
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then for etc in aux.Next(g) do etc:CreateEffectRelation(te) end end
		if op then op(e,tp,ceg,cep,cev,cre,cr,crp) end
		if g then for etc in aux.Next(g) do etc:ReleaseEffectRelation(te) end end
		e:SetProperty(pr1,pr2)
		--end
	end
	if e:GetHandler():IsRelateToEffect(e) then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
	--[[local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_END)
	e4:SetOperation(s.limop)
	Duel.RegisterEffect(e4,tp)
end
function s.limop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(s.chainlm)
	e:Reset()
end
function s.chainlm(e,rp,tp)
	local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,0xff,0xff,nil,id)
	local t={}
	for tc in aux.Next(g) do
		local le={tc:IsHasEffect(id)}
		local te=le[1]
		table.insert(t,te:GetLabelObject())
	end
	return not SNNM.IsInTable(e,t)--]]
end
