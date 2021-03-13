if not pcall(function() require("expansions/script/c33700650") end) then require("script/c33700650") end
--破天神狐 ～危险的计划，热情的鼓动带来的无上时机之卷
local m=33700658
local cm=_G["c"..m]
cm.named_with_ptsh=true
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target1)
	e2:SetOperation(cm.operation1)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return sr_ptsh.check_set_ptsh(c) and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_ONFIELD,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_ONFIELD,0,1,1,c)
	local seq=g:GetFirst():GetSequence()
	Duel.SendtoGrave(g,REASON_COST)
	g:KeepAlive()
	e:SetLabelObject(g:GetFirst())
	if not g:GetFirst():IsType(TYPE_MONSTER) then
		e:SetLabel(seq)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_MONSTER) then
		e:SetCategory(CATEGORY_ATKCHANGE)
	else
		e:SetCategory(CATEGORY_DISABLE)
	end
end
function cm.val(c)
	return sr_ptsh.check_set_ptsh(c) and c:IsFaceup()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc:IsType(TYPE_MONSTER) then
		local atk=tc:GetAttack()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESET_PHASE+PHASE_END)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(cm.val)
		e2:SetValue(atk)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		Duel.RegisterEffect(e3,tp)
	else
	   local seq=e:GetLabel()
	   local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
			e4:SetTarget(cm.distg)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(seq)
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(cm.disop)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(seq)
			Duel.RegisterEffect(e5,tp)
			local e6=Effect.CreateEffect(c)
			e6:SetType(EFFECT_TYPE_FIELD)
			e6:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e6:SetTarget(cm.distg)
			e6:SetReset(RESET_PHASE+PHASE_END)
			e6:SetLabel(c:GetSequence())
			Duel.RegisterEffect(e6,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(cm.distg1)
			e2:SetTargetRange(0,LOCATION_MZONE)
			e2:SetCode(EFFECT_SET_ATTACK)
			e2:SetValue(0)
			c:RegisterEffect(e2)
	end
end
function cm.distg(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.GetColumn(c,tp)==seq
end
function cm.distg1(e,c)
	local seq=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and aux.GetColumn(c,tp)==seq
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local tseq=e:GetLabel()
	local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
	if loc&LOCATION_SZONE~=0 and seq<=4 and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
		and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
		Duel.NegateEffect(ev)
	end
end
function cm.filter1(c,e,tp)
	return sr_ptsh.check_set_ptsh(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.filter1,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter1,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
	end
end