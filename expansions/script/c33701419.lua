--虚拟YouTuber 夜乃空
local m=33701419
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,3,false)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.sprcon)
	e1:SetOperation(cm.sprop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(cm.atop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.attarget1)
	e3:SetValue(cm.atval1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_REMOVE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.rccon)
	e4:SetTarget(cm.rctg)
	e4:SetOperation(cm.rcop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e12:SetValue(cm.fuslimit)
	c:RegisterEffect(e12)
	local e13=e11:Clone()
	e13:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e13)
	local e14=e11:Clone()
	e14:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e14)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		cm[2]=0
		cm[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_RECOVER)
		ge2:SetOperation(cm.checkop1)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function cm.ffilter(c,fc,sub,mg,sg)
	return not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
end
function cm.sprfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end
function cm.matfilter(c)
	return c:GetAttribute()>0
end
function cm.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.CheckRemoveOverlayCard(tp,1,1,3,REASON_COST) then return false end
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local mg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		mg:Merge(tc:GetOverlayGroup():Filter(cm.matfilter,nil))
		tc=g:GetNext()
	end
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and mg:CheckSubGroup(cm.fselect,3,3,tp,c)
end
function cm.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(cm.sprfilter,tp,LOCATION_MZONE,LOCATION_MZONE,0,nil)
	local mg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		mg:Merge(tc:GetOverlayGroup():Filter(cm.matfilter,nil))
		tc=g:GetNext()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
	local sg=mg:SelectSubGroup(tp,cm.fselect,false,3,mg:GetCount(),tp,c)
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_COST+REASON_MATERIAL)
end
function cm.atop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	local atk=0
	if g then
		atk=g:GetCount()*800
	else atk=0 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.attarget1(e,c)
	return c~=e:GetHandler()
end
function cm.atval1(e,c)
	return e:GetHandler():GetAttack()
end
function cm.rccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1
end
function cm.rctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,c,1,0,0)
end
function cm.rcop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	Duel.Recover(tp,c:GetAttack(),REASON_EFFECT)
	if Duel.Remove(c,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1,fid)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(c)
		e1:SetCondition(cm.retcon)
		e1:SetOperation(cm.retop)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.retcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local tc=e:GetLabelObject()
	if not tc:GetFlagEffectLabel(m)==e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(cm[tp+2])
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	cm[ep]=cm[ep]+ev
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[2]=cm[0]
	cm[3]=cm[1]
	cm[0]=0
	cm[1]=0
end
function cm.fuslimit(e,c,sumtype)
	return sumtype==SUMMON_TYPE_FUSION
end
