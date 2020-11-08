--灰黯音核「启」
local m=11451462
local cm=_G["c"..m]
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m-40)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(cm.spcost2)
	c:RegisterEffect(e4)
end
function cm.lvplus(c)
	if c:GetLevel()>=1 and c:IsType(TYPE_MONSTER) then return c:GetLevel() else return 2 end
end
function cm.filter(c,tp)
	return c:IsSetCard(0x97a) and c:IsType(TYPE_SPELL) and c:CheckActivateEffect(false,false,false)~=nil and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.filter2(c)
	return c:IsSetCard(0x97a) and ((c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD)) or (c:IsPublic() and c:IsLocation(LOCATION_HAND)) or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToRemove()
end
function cm.filter3(c,e,tp)
	return c:IsSetCard(0x97a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter4(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_TUNER)
end
function cm.filter5(c)
	if Duel.IsPlayerAffectedByEffect(c:GetControler(),11451461) and ((c:IsOnField() and c:IsStatus(STATUS_EFFECT_ENABLED)) or c:IsLocation(LOCATION_HAND)) then return true end
	return false
end
function cm.filter6(c,e)
	return c:GetFlagEffectLabel(m)==e:GetLabel()
end
function cm.fselect(g,lv,tp)
	return g:GetSum(cm.lvplus)==lv and g:IsExists(cm.filter4,1,nil) and Duel.GetMZoneCount(tp,g,tp,0,0x1f)>0
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local tg=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tg then
		local t=tg:GetType()
		if t==0x2 or t==0x82 or t==0x10002 or t==0x40002 then
			Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.Hint(HINT_CARD,0,tg:GetOriginalCode())
			local te,ceg,cep,cev,cre,cr,crp=tg:CheckActivateEffect(false,false,true)
			te:UseCountLimit(tp,1,true)
			local tep=tg:GetControler()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if t~=0x40002 then tg:CancelToGrave(false) end
			tg:CreateEffectRelation(te)
			if cost then cost(te,tep,ceg,cep,cev,cre,cr,crp,1) end
			if target then target(te,tep,ceg,cep,cev,cre,cr,crp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g and g:GetCount()>0 then
				local fg=g:GetFirst()
				while fg do
					fg:CreateEffectRelation(te)
					fg=g:GetNext()
				end
			end
			tg:SetStatus(STATUS_ACTIVATED,true)
			if operation then operation(te,tep,ceg,cep,cev,cre,cr,crp) end
			tg:ReleaseEffectRelation(te)
			if g and g:GetCount()>0 then
				fg=g:GetFirst()
				while fg do
					fg:ReleaseEffectRelation(te)
					fg=g:GetNext()
				end
			end
			Duel.RaiseEvent(tg,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		elseif t==0x80002 then
			local te=tg:GetActivateEffect()
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tg,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tg:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tg,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			tg:RegisterFlagEffect(m-3,RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END,0,2)
		elseif t==0x20002 then
			local te=tg:GetActivateEffect()
			Duel.MoveToField(tg,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tg:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			tg:RegisterFlagEffect(m-3,RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END,0,2)
		end
	end
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) or Duel.GetTurnPlayer()==tp end
	if Duel.GetTurnPlayer()~=tp then Duel.PayLPCost(tp,2000) end
end
function cm.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPublic() and Duel.GetFlagEffect(tp,11451466)>0 and (Duel.CheckLPCost(tp,2000) or Duel.GetTurnPlayer()==tp) end
	Duel.ResetFlagEffect(tp,11451466)
	if Duel.GetTurnPlayer()~=tp then Duel.PayLPCost(tp,2000) end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local sg=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_DECK,0,nil,e,tp)
	local tg=Group.CreateGroup()
	for sc in aux.Next(sg) do
		local tc=mg:CheckSubGroup(cm.fselect,1,#mg,cm.lvplus(sc),tp)
		if tc then tg:AddCard(sc) end
	end
	if not tg or #tg==0 or not Duel.SelectYesNo(tp,aux.Stringid(11451461,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=tg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=mg:SelectSubGroup(tp,cm.fselect,false,1,#mg,cm.lvplus(tc),tp)
	Card.SetMaterial(tc,rg)
	local tg=rg:Filter(cm.filter5,nil)
	if not tg or #tg==0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)
	else
		Duel.Hint(HINT_CARD,0,11451461)
		local te0=Duel.IsPlayerAffectedByEffect(0,11451461)
		local te1=Duel.IsPlayerAffectedByEffect(1,11451461)
		local tg0=tg:Filter(Card.IsControler,nil,0)
		local tg1=tg:Filter(Card.IsControler,nil,1)
		rg:Sub(tg)
		if te0 and tg0 then
			te0:GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local tg0f=tg0:Filter(Card.IsOnField,nil)
			local tg0h=tg0:Filter(Card.IsLocation,nil,LOCATION_HAND)
			if tg0f and Duel.Remove(tg0f,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_TEMPORARY)>0 then
				tg0f:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tg0f)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,tp)
			end
			if tg0h and Duel.Remove(tg0h,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)>0 then
				Duel.ShuffleHand(tp)
				local fid=c:GetFieldID()
				tg0h:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tg0h:KeepAlive()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(11451461,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(tg0h)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetOperation(cm.retop2)
				Duel.RegisterEffect(e2,tp)
			end
		end
		if te1 and tg1 then
			te1:GetHandler():RegisterFlagEffect(11451468,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local tg1f=tg1:Filter(Card.IsOnField,nil)
			local tg1h=tg1:Filter(Card.IsLocation,nil,LOCATION_HAND)
			if tg1f and Duel.Remove(tg1f,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_TEMPORARY)>0 then
				tg1f:KeepAlive()
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(11451461,0))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_END)
				e1:SetReset(RESET_PHASE+PHASE_END)
				e1:SetLabelObject(tg1f)
				e1:SetCountLimit(1)
				e1:SetOperation(cm.retop1)
				Duel.RegisterEffect(e1,tp)
			end
			if tg1h and Duel.Remove(tg1h,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL)>0 then
				Duel.ShuffleHand(tp)
				local fid=c:GetFieldID()
				tg1h:ForEach(Card.RegisterFlagEffect,m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
				tg1h:KeepAlive()
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetDescription(aux.Stringid(11451461,1))
				e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e2:SetCode(EVENT_PHASE+PHASE_END)
				e2:SetCountLimit(1)
				e2:SetLabel(fid)
				e2:SetLabelObject(tg1h)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetOperation(cm.retop2)
				Duel.RegisterEffect(e2,tp)
			end
		end
		if rg then Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL) end
	end
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
end
function cm.retop1(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
	g:DeleteGroup()
end
function cm.retop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(cm.filter6,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	e:GetLabelObject():DeleteGroup()
end