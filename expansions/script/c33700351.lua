--虚拟YouTuber 萌实
local m=33700350
local cm=_G["c"..m]
function c33700351.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetCondition(cm.lvcon)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetLabel(6)
	e1:SetCondition(cm.sycon)
	e1:SetOperation(cm.syop)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.incon)
	e4:SetValue(cm.inefil)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(57579381,0))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.condition)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.operation)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_PHASE+PHASE_END)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(57579381,0))
	e7:SetCategory(CATEGORY_RECOVER)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCost(cm.cost1)
	e7:SetTarget(cm.target1)
	e7:SetOperation(cm.operation1)
	c:RegisterEffect(e7)
end
function cm.lvcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function cm.stfilter1(c,tc)
	return c:IsCode(33700350) and c:IsSynchroType(TYPE_TUNER) and c:IsFaceup() and c:IsLevelAbove(1)
		and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilter2(c,tc)
	return not c:IsSynchroType(TYPE_TUNER) and c:IsFaceup() and c:IsLevelAbove(1)
		and c:IsCanBeSynchroMaterial(tc)
end
function cm.stfilterg(g,tp,tc,smat)
	if smat then
		g:AddCard(smat)
	end
	local g1=g:Filter(cm.stfilter1,nil,tc)
	local g2=g:Filter(cm.stfilter2,nil,tc)
	local count=g:GetCount()
	return g1:GetCount()==1 and g2:GetCount()==count-1 and Duel.GetLocationCountFromEx(tp,tp,g,tc)>0
end
function cm.sycon(e,c,smat,mg)
	if c==nil then return true end
	local tp=c:GetControler()
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	if smat then
		mg:RemoveCard(smat)
		return mg:CheckSubGroup(cm.stfilterg,1,nil,tp,c,smat)
	else
		return mg:CheckSubGroup(cm.stfilterg,2,nil,tp,c,nil)
	end
end
function cm.syop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	if not mg then
		mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)
	end
	local g=Group.CreateGroup()
	if smat then
		mg:RemoveCard(smat)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,1,nil,tp,c,lv,smat))
		g:AddCard(smat)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		g:Merge(mg:SelectSubGroup(tp,cm.stfilterg,false,2,nil,tp,c,lv,nil))
	end
	c:SetMaterial(g)
	local lv=g:GetSum(Card.GetLevel)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	e:GetLabelObject():SetValue(lv)
end
function cm.incon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==1
end
function cm.inefil(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetHandler():GetLevel()*250)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Recover(p,c:GetLevel()*250,REASON_EFFECT)
	end
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,0,REASON_COST)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3000)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,3000)
end
function cm.operation1(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
