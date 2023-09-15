local m=189136
local cm=_G["c"..m]
cm.name="卡莉斯塔工作室"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(189133,4))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1150)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--look
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.hcon)
	e2:SetOperation(cm.hop)
	c:RegisterEffect(e2)
end
function cm.handcon(e)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),189133)~=0
end
--tp：自 己
--p：破 坏 的 怪 兽 存 在 过 的 玩 家
--seq：破 坏 的 怪 兽 存 在 过 的 序 号
--arrow：准 备 检 查 的 方 向
function cm.seqfilter(c,seq,tp,p,arrow,loc)
	--local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and loc==LOCATION_SZONE then return false end
	if seq==7 and loc==LOCATION_MZONE then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	local cp=c:GetControler()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and seq<5 and loc==LOCATION_MZONE then
		if arrow=="up" and cp==p and cp==tp and ((seq==1 and cseq==5) or (seq==3 and cseq==6)) then return true end
		if arrow=="up" and cp~=p and cp~=tp and ((seq==1 and cseq==6) or (seq==3 and cseq==5)) then return true end
		if arrow=="down" and cp==p and cp~=tp and ((seq==1 and cseq==5) or (seq==3 and cseq==6) or seq==cseq) then return true end
		if arrow=="down" and cp~=p and cp==tp and ((seq==1 and cseq==6) or (seq==3 and cseq==5) or seq==cseq) then return true end
		if arrow=="left" or arrow=="right" then return false end
	end
	if cloc==LOCATION_MZONE and seq>=5 and cseq<5 and loc==LOCATION_MZONE then
		if arrow=="up" and cp==p and cp~=tp and ((seq==5 and cseq==1) or (seq==6 and cseq==3)) then return true end
		if arrow=="up" and cp~=p and cp~=tp and ((seq==5 and cseq==3) or (seq==6 and cseq==1)) then return true end
		if arrow=="down" and cp==p and cp==tp and ((seq==5 and cseq==1) or (seq==6 and cseq==3)) then return true end
		if arrow=="down" and cp~=p and cp==tp and ((seq==5 and cseq==3) or (seq==6 and cseq==1)) then return true end
		if arrow=="left" or arrow=="right" then return false end
	end
	if arrow=="left" and cp==p and cp==tp then return loc==cloc and cseq==seq-1 end
	if arrow=="right" and cp==p and cp==tp then return loc==cloc and cseq==seq+1 end
	if arrow=="left" and cp==p and cp~=tp then return loc==cloc and cseq==seq+1 end
	if arrow=="right" and cp==p and cp~=tp then return loc==cloc and cseq==seq-1 end
	if cloc==LOCATION_MZONE and seq<5 and cseq<5 and loc==LOCATION_SZONE then
		if arrow=="up" and cp==p and cp==tp and cseq==seq then return true end
		if arrow=="down" and cp==p and cp~=tp and cseq==seq then return true end
		if arrow=="left" or arrow=="right" then return false end
	end
	if cloc==LOCATION_SZONE and seq<5 and cseq<5 and loc==LOCATION_MZONE then
		if arrow=="up" and cp==p and cp~=tp and cseq==seq then return true end
		if arrow=="down" and cp==p and cp==tp and cseq==seq then return true end
		if arrow=="left" or arrow=="right" then return false end
	end
	return false
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e))
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local list={}
		table.insert(list,aux.Stringid(m,1))
		table.insert(list,aux.Stringid(m,2))
		table.insert(list,aux.Stringid(m,3))
		table.insert(list,aux.Stringid(m,4))
		local ct=4
		while #list~=0 and list~={0,0,0,0} and tc and ct>0 do
			local loc=tc:GetLocation()
			local slist={}
			table.insert(slist,aux.Stringid(m,1)) --up
			table.insert(slist,aux.Stringid(m,2)) --down
			table.insert(slist,aux.Stringid(m,3)) --left
			table.insert(slist,aux.Stringid(m,4)) --right
			local p=tc:GetControler()
			local seq=tc:GetSequence()
			if table.concat(list,nil,4,4)+1==1 or not Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,seq,tp,p,"right",loc) then
				table.remove(slist,4)
			end
			if table.concat(list,nil,3,3)+1==1 or not Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,seq,tp,p,"left",loc) then
				table.remove(slist,3)
			end
			if table.concat(list,nil,2,2)+1==1 or not Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,seq,tp,p,"down",loc) then
				table.remove(slist,2)
			end
			if table.concat(list,nil,1,1)+1==1 or not Duel.IsExistingMatchingCard(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,seq,tp,p,"up",loc) then
				table.remove(slist,1)
			end
			--if #slist==0 then Duel.Destroy(tc,REASON_EFFECT) break end
			if Duel.Destroy(tc,REASON_EFFECT)~=0 and #slist~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
				local opt=Duel.SelectOption(tp,table.unpack(slist))
				local arrow="0"
				if table.concat(slist,nil,opt+1,opt+1)+1==aux.Stringid(m,4)+1 then
					arrow="right"
					table.insert(list,4,0)
					table.remove(list,5)
				end
				if table.concat(slist,nil,opt+1,opt+1)+1==aux.Stringid(m,3)+1 then
					arrow="left"
					table.insert(list,3,0)
					table.remove(list,4)
				end
				if table.concat(slist,nil,opt+1,opt+1)+1==aux.Stringid(m,2)+1 then
					arrow="down"
					table.insert(list,2,0)
					table.remove(list,3)
				end
				if table.concat(slist,nil,opt+1,opt+1)+1==aux.Stringid(m,1)+1 then
					arrow="up"
					table.insert(list,1,0)
					table.remove(list,2)
				end
				ct=ct-1
				local tg=Duel.GetMatchingGroup(cm.seqfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,seq,tp,p,arrow,loc)
				Duel.HintSelection(tg)
				tc=tg:GetFirst()
			else break
			end
		end
	end
end
function cm.hfilter(c)
	return not c:IsPublic()
end
function cm.bfilter(c)
	return aux.IsCodeListed(c,189131) and c:IsFaceup()
end
function cm.hcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.hfilter,tp,0,LOCATION_HAND,1,nil) and Duel.IsExistingMatchingCard(cm.bfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.hfilter,tp,0,LOCATION_HAND,nil)
	if g:GetCount()~=0 then
		local ct=1
		if Duel.IsPlayerAffectedByEffect(tp,189137) and Duel.GetFlagEffect(tp,189137)==0 and g:GetCount()>=2 and Duel.SelectYesNo(tp,aux.Stringid(189137,2)) then
			ct=2
			Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+189138,e,REASON_EFFECT,tp,1-tp,ev)
			Duel.RegisterFlagEffect(tp,189137,RESET_PHASE+PHASE_END,0,1)
		end
		local ag=g:RandomSelect(tp,ct)
		local ac=ag:GetFirst()
		while ac do
			ac:RegisterFlagEffect(189133,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_PUBLIC)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
			ac=ag:GetNext()
		end
		Duel.ConfirmCards(tp,ag)
	end
end