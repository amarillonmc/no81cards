--奇术人形 跳伞小可爱
local m=40010396
local cm=_G["c"..m]
cm.named_with_MagiaDoll=1
function cm.MagiaDoll(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagiaDoll
end
function cm.MagiaDollD(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_MagiaDollD
end
function cm.Harri(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Harri
end
function cm.initial_effect(c)
	aux.AddCodeList(c,40009730)
	--pendulum summon
	aux.EnablePendulumAttribute(c) 
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.pencon)
	e1:SetTarget(cm.pentg)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	--e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.drcon)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2) 
	
end
function cm.filter0(c)
	return cm.MagiaDoll(c)
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_PZONE,0,1,e:GetHandler())
end
function cm.check(e,tp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return false end
	local g=Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if #g==0 then return false end
	local pcon=aux.PendCondition()
	return pcon(e,lpz,g)
end
function cm.penfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)==2 and cm.check(e,tp)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local lpz=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if lpz==nil then return end
	local g=Duel.GetMatchingGroup(cm.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil)
	if #g==0 then return end
	--the summon should be done after the chain end
	local sg=Group.CreateGroup()
	local pop=aux.PendOperation()
	pop(e,tp,eg,ep,ev,re,r,rp,lpz,sg,g)
	local dg=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	if Duel.SpecialSummon(sg,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_EXTRA)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.ptfilter)
	e1:SetValue(aux.tgoval)
	Duel.RegisterEffect(e1,tp)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(cm.ptfilter)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
end
function cm.ptfilter(e,c)
	return aux.IsCodeListed(c,40009730) or cm.MagiaDollD(c) or cm.MagiaDoll(c) or cm.Harri(c)
end
