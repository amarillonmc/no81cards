--波动武士·热辐射爆弹
local m=11451455
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--boom
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(cm.recon)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local num=g:GetSum(Card.GetLevel)
	return Duel.GetMZoneCount(tp)>0 and (num%10)==0 and num~=0 and Duel.GetDecktopGroup(tp,5):FilterCount(Card.IsAbleToRemoveAsCost,nil,POS_FACEDOWN)==5
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.DisableShuffleCheck()
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
end
function cm.recon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc and rc:IsRace(RACE_PSYCHO) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 and c:IsControlerCanBeChanged() and Duel.GetFlagEffect(tp,m)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local fd=Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0)
	Duel.Hint(HINT_ZONE,tp,fd)
	Duel.Hint(HINT_ZONE,1-tp,fd>>16)
	fd=fd>>16
	e:SetLabel(fd)
	local seq=math.log(fd,2)
	local dg=Group.CreateGroup()
	local g=nil
	for i=math.max(0,seq-1),math.min(4,seq+1) do
		g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD,nil,1-tp,i)
		dg:Merge(g)
	end
	dg:AddCard(c)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,dg,#dg,0,0)
end
function cm.reop(e,tp,eg,ep,ev,re,r,rp)
	local fd=e:GetLabel()
	local seq=math.log(fd,2)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsControler(tp) or not Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) or not c:IsFaceup() then return end
	Duel.GetControl(c,1-tp,0,0,fd)
	if c:GetSequence()==seq then
		local dg=Group.CreateGroup()
		local g=nil
		for i=math.max(0,seq-1),math.min(4,seq+1) do
			g=Duel.GetMatchingGroup(cm.rmfilter,tp,0,LOCATION_ONFIELD,nil,1-tp,i)
			dg:Merge(g)
		end
		if #dg>0 then
			Duel.HintSelection(dg)
			Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function cm.rmfilter(c,tp,seq)
	return aux.GetColumn(c,tp)==seq
end