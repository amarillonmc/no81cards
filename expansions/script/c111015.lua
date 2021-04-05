--幻术师·幻梦
local m=111015
local cm=_G["c"..m]
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,cm.stfilter,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(cm.sycon)
	e1:SetOperation(cm.syop)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCost(cm.mccost)
	e2:SetCondition(cm.mccon)
	e2:SetTarget(cm.mctg)
	e2:SetOperation(cm.mcop)
	c:RegisterEffect(e2)
	Chain_Count={}
	Chain_Count[1]=0 
end
function cm.stfilter(c)
	return c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP)
end
function cm.stfilter1(c,tc)
	return c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilter2(c,tc)
	return not c:IsSynchroType(TYPE_TUNER) and c:IsPosition(POS_FACEUP) and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilterg(g,tp,tc,lv,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	return g1:GetCount()==1 and g2:GetCount()==count-1 and g:GetSum(Card.GetLevel)==lv-1 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local lv=e:GetLabel()
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(Card.IsLevelAbove,tp,LOCATION_MZONE,0,nil,1)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,e:GetHandler():GetLevel(),smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,e:GetHandler():GetLevel(),nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local lv=e:GetLabel()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,e:GetHandler():GetLevel(),smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,e:GetHandler():GetLevel(),nil))
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function cm.mccost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.retop)
		Duel.RegisterEffect(e1,tp)
		e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.mccon(e,tp,eg,ep,ev,re,r,rp)
	return (rp==1-tp or re:GetHandler():IsCode(m)) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.mctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.mcop(e,tp)
	e:GetHandler():RegisterFlagEffect(m+1,0,0,1)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)~=0 then 
		if Duel.ReturnToField(e:GetLabelObject()) and c:GetFlagEffect(m+1)~=0 then
			c:ResetFlagEffect(m+1)
			--Debug.Message("This max chain count "..Chain_Count[1])
			local num=Chain_Count[1]
			local g=Duel.GetDecktopGroup(1-tp,math.min(num,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)))
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function cm.op(e,tp)
	if e:GetHandler():GetFlagEffect(m)~=0 then
		Chain_Count[1]=Duel.GetCurrentChain()
	end
end