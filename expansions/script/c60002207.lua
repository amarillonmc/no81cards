--紫水晶雄狮
local m=60002207
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsCanRemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_COST)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,1,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	local num={}
	local i=1
	while i<=count do
		num[i]=i
		i=i+1
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	count=Duel.AnnounceNumber(tp,table.unpack(num))
	Duel.RemoveCounter(tp,LOCATION_ONFIELD,0,0x625,count,REASON_COST)
end