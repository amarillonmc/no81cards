--码丽丝<龙>炸脖龙
local m=70000902
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,cm.lcheck)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCondition(cm.atkcon)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetValue(3000)
	c:RegisterEffect(e1)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.costchange)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1,m+1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(cm.discost)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
end
	function cm.cfilter(c)
	return c:IsSetCard(0x1bf) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
	function cm.atkcon(e)
	local g=Duel.GetMatchingGroup(cm.cfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>=3
end
	function cm.atktg(e,c)
	return c:IsSetCard(0x1bf) and c:IsType(TYPE_LINK)
end
	function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x1bf)
end
	function cm.costchange(e,re,rp,val)
	if re and re:GetHandler():IsSetCard(0x1bf) then
		return 0
	else
		return val
	end
end
	function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,900) end
	Duel.PayLPCost(tp,900)
end
	function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
	function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	Duel.Recover(tp,1500,REASON_EFFECT)
end
	function cm.cfilter(c)
	return c:IsSetCard(0x1bf) and c:IsType(TYPE_MONSTER)
end
	function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,cm.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end
	function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
	function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) and rc:IsDestructable() then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end