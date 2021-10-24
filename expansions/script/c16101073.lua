--精神的指名者
local m=16101073
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)  
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_ACTIVATE_COST)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetCost(cm.costchk)
	e1:SetTarget(cm.costtg)
	e1:SetOperation(cm.costop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_COST)
	e2:SetTarget(cm.costtg)
	e2:SetTargetRange(0x7f,0x7f)
	e2:SetCost(cm.costchk2)
	e2:SetOperation(cm.costop2)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SPSUMMON_COST)
	Duel.RegisterEffect(e3,tp)
end
function cm.costchk(e,te_or_c,tp)
	return true
end
function cm.costtg(e,te_or_c,tp)
	e:SetLabelObject(te_or_c)
	return true
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local ce=e:GetLabelObject()
	for i=1,3 do
		Duel.AnnounceCard(tp,ce:GetHandler():GetCode(),OPCODE_ISCODE)
		if i~=3 and Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,2))==0 then
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
			return false
		else
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
		end
	end
end
function cm.costchk2(e,te_or_c,tp)
	return true
end
function cm.costop2(e,tp,eg,ep,ev,re,r,rp,te_or_c)
	local rc=e:GetLabelObject()
	for i=1,3 do
		Duel.AnnounceCard(tp,rc:GetCode(),OPCODE_ISCODE)
		if i~=3 and Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,2))==0 then
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,1))
			return false
		else
			Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(m,3))
		end
	end 
end