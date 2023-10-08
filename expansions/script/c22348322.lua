--白之独角兽 尤妮丝
local cm,m=GetID()
--破绽指示物 0x3223

function cm.initial_effect(c)
	c:EnableCounterPermit(0x3223)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--imm
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(0x04)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
	--battle indes
	local e4=e1:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(cm.indes)
	c:RegisterEffect(e4)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_START)
	e2:SetCondition(cm.adcon)
	e2:SetTarget(cm.adtg)
	e2:SetOperation(cm.adop)
	c:RegisterEffect(e2)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetRange(0x04)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(0x04)
	e3:SetCondition(cm.lfcon)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(0x04)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.mvtg)
	e5:SetOperation(cm.mvop)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.discon)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetCounter(0x1041)>0
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end


function cm.abcd(a,b,vala,valb)
	return (a==vala and b==valb) or (b==vala and a==valb)
end

function cm.seqfilter(ctp,cloc,cseq,etp,eloc,eseq)
	if (eloc==0x08 and eseq==5) or cloc~=0x04 then return false end
	if ctp==etp then
		return (cseq<=4 and cseq==eseq) or (eloc==0x04 and (cm.abcd(cseq,eseq,1,5) or cm.abcd(cseq,eseq,3,6)))
	else
		return (cseq<=4 and cseq==4-eseq) or (eloc==0x04 and (cm.abcd(cseq,eseq,1,6) or cm.abcd(cseq,eseq,3,5)))
	end
end

function cm.efilter(e,te,ev)
	local c=e:GetHandler()
	if te:IsActivated() then
		local etp,eloc,eseq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
		return eloc&0x0c~=0 and not cm.seqfilter(e:GetHandlerPlayer(),0x04,c:GetSequence(),etp,eloc,eseq)
	else
		local tc=te:GetHandler()
		return tc:IsOnField() and not c:GetColumnGroup():IsContains(tc)
	end
end

function cm.indes(e,c)
	return c:IsLocation(0x04) and not e:GetHandler():GetColumnGroup():IsContains(c)
end

function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:GetCounter(0x3223)>0
end

function cm.cfilter(c)
	return c:IsLocation(0x04) and c:GetCounter(0x3223)>0
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end

function cm.lfcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetLabel()==1
end

function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT) then
		local c=e:GetHandler()
		if c:IsRelateToChain() and c:IsFaceup() then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetRange(0x04)
			e1:SetValue(500)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
	end
end

function cm.tgmcfilterg(c,tcseq)
	local cseq=c:GetSequence()
	return c:IsCanAddCounter(0x3223,1) and ((cseq<=4 and cseq==4-tcseq) or (cseq==6 and tcseq==1) or (cseq==5 and tcseq==3))
end

function cm.tgmcfilter(tp,seq,c)
	return Duel.CheckLocation(tp,0x04,seq) and Duel.IsExistingMatchingCard(cm.tgmcfilterg,tp,0,0x04,1,c,seq) and (tp==c:GetControler() or (c:CheckUniqueOnField(tp) and c:IsControlerCanBeChanged()))
end

function cm.tgmfilter(c,tp,cseq)
	if cseq<=4 then
		return (cseq>0 and cm.tgmcfilter(tp,cseq-1,c)) or (cseq<4 and cm.tgmcfilter(tp,cseq+1,c))
	else
		if cseq==5 then
			return cm.tgmcfilter(tp,1,c) or cm.tgmcfilter(1-tp,3,c)
		elseif cseq==6 then
			return cm.tgmcfilter(tp,3,c) or cm.tgmcfilter(1-tp,1,c)
		end
	end
end

function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return cm.tgmfilter(c,c:GetControler(),c:GetSequence()) end
end

function cm.opcfilter(c,g)
	return g:IsContains(c) and c:IsFaceup() and c:IsCanAddCounter(0x3223,1)
end

function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and c:IsOnField() and not c:IsImmuneToEffect(e) then
		local cp,cseq,flag,czone=c:GetControler(),c:GetSequence(),0,0
		if cseq<=4 then
			if cseq>0 and cm.tgmcfilter(cp,cseq-1,c) then flag=flag|(1<<(cseq-1)) end
			if cseq<4 and cm.tgmcfilter(cp,cseq+1,c) then flag=flag|(1<<(cseq+1)) end
		else
			if cseq==5 then
				if cm.tgmcfilter(cp,1,c) then flag=flag|(1<<1) end
				if cm.tgmcfilter(1-cp,3,c) then czone=1<<3 end
			elseif cseq==6 then
				if cm.tgmcfilter(tp,3,c) then flag=flag|(1<<3) end
				if cm.tgmcfilter(1-cp,1,c) then czone=1<<1 end
			end
		end
		if flag==0 and czone==0 then return false end
		if czone~=0 and (flag==0 or Duel.SelectYesNo(tp,aux.Stringid(m,1))) then
			Duel.GetControl(c,1-tp,0,0,czone)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,0x04,0,~flag)
			Duel.MoveSequence(c,math.log(s,2))
		end
		local g=Duel.GetMatchingGroup(cm.opcfilter,c:GetControler(),0,0x04,nil,c:GetColumnGroup())
		if #g>0 then
			for tc in aux.Next(g) do
				tc:AddCounter(0x3223,1)
			end
		end
	end
end