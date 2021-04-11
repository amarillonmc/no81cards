local m=15000173
local cm=_G["c"..m]
cm.name="精灵弓的族人·娜蓝多耶"
function cm.initial_effect(c)
	--synchro summon  
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e0:SetCountLimit(1)
	e0:SetRange(0xff)
	e0:SetOperation(cm.notop)
	c:RegisterEffect(e0)
end
function cm.notop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(cm.attg)
	e1:SetOperation(cm.atop)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(cm.mvcon)
	e2:SetTarget(cm.mvtg)
	e2:SetOperation(cm.mvop)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e2,1-tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CUSTOM+15000174)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.desop)
	e3:SetReset(RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e3)
end
function cm.mvcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	local ac=e:GetLabelObject()
	return d and d:IsControler(tp) and ac==Duel.GetAttacker()
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabelObject()
	local tc=Duel.GetAttackTarget()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		if Duel.NegateAttack() and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
			local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
			local nseq=math.log(s,2)
			local seq2=tc:GetSequence()
			Duel.MoveSequence(tc,nseq)
			ac:RegisterFlagEffect(15000173,RESET_PHASE+PHASE_BATTLE,0,1,seq2)
			Duel.RaiseSingleEvent(ac,EVENT_CUSTOM+15000174,e,r,rp,ep,ev)
		end
	end
end
function cm.attg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d and d:IsControler(1-tp) end
end
function cm.selffilter(c)
	local seq=c:GetSequence()
	return seq<5
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	local seq1=c:GetSequence()
	if Duel.GetMatchingGroupCount(cm.selffilter,tp,LOCATION_MZONE,0,nil)<5 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local fd=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		Duel.Hint(HINT_ZONE,tp,fd)
		local seq=math.log(fd,2)
		Duel.MoveSequence(c,seq)
	end
end
function cm.seqfilter(c,seq)
	return bit.band(c:GetSequence(),seq)~=0
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq1=c:GetSequence()
	local seq2=c:GetFlagEffectLabel(15000173)
	c:ResetFlagEffect(15000173)
	local seq3=cm.SeqCalculator(seq1,seq2)
	if c:GetEffectCount(15000174)==0 then
		if seq3==1919810 then return end
		if seq3==114514 then Duel.Damage(1-tp,c:GetAttack(),REASON_EFFECT) end
		if seq3~=1919810 and seq3~=114514 then
			local g=Duel.GetMatchingGroup(cm.seqfilter,1-tp,LOCATION_SZONE,0,nil,seq3)
			if g:GetCount()==0 then Duel.Damage(1-tp,c:GetAttack(),REASON_EFFECT) end
			if g:GetCount()~=0 then Duel.Destroy(g,REASON_EFFECT) end
		end
	end
	if c:GetEffectCount(15000174)~=0 and Duel.IsExistingMatchingCard(cm.efffilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,c) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local tc=Duel.SelectMatchingCard(tp,cm.efffilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,c):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		local m=_G["c"..tc:GetCode()]
		local te=m.spirit_bow_effect
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function cm.efffilter(c,sc)
	local m=_G["c"..c:GetCode()]
	if not m then return false end
	local te=m.spirit_bow_effect
	return te and c:GetEquipTarget()==sc
end
function cm.SeqCalculator(seq1,seq2)
	if seq1==0 then
		if seq2==5 then return 1919810 end
		if seq2==0 then return 1919810 end
		if seq2==1 then return 1919810 end
		if seq2==2 then return 9 end
		if seq2==3 then return 114514 end
		if seq2==4 then return 12 end
		if seq2==6 then return 9 end
	end
	if seq1==1 then
		if seq2==5 then return 1919810 end
		if seq2==0 then return 1919810 end
		if seq2==1 then return 8 end
		if seq2==2 then return 114514 end
		if seq2==3 then return 11 end
		if seq2==4 then return 1919810 end
		if seq2==6 then return 11 end
	end
	if seq1==2 then
		if seq2==5 then return 1919810 end
		if seq2==0 then return 1919810 end
		if seq2==1 then return 114514 end
		if seq2==2 then return 10 end
		if seq2==3 then return 114514 end
		if seq2==4 then return 1919810 end
		if seq2==6 then return 1919810 end
	end
	if seq1==3 then
		if seq2==5 then return 9 end
		if seq2==0 then return 1919810 end
		if seq2==1 then return 9 end
		if seq2==2 then return 114514 end
		if seq2==3 then return 12 end
		if seq2==4 then return 1919810 end
		if seq2==6 then return 1919810 end
	end
	if seq1==4 then
		if seq2==5 then return 11 end
		if seq2==0 then return 8 end
		if seq2==1 then return 114514 end
		if seq2==2 then return 11 end
		if seq2==3 then return 1919810 end
		if seq2==4 then return 1919810 end
		if seq2==6 then return 1919810 end
	end
	return 1919810
end