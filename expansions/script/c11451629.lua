--龙宫城的反逆者 哪吒
--21.12.15
local cm,m=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,22702055)
	c:SetUniqueOnField(1,1,11451419)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(POS_FACEUP,0)
	e2:SetCondition(cm.rule)
	e2:SetValue(function() return 0,0x1f001f end)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetTargetRange(POS_FACEUP,1)
	e3:SetCondition(cm.rule2)
	c:RegisterEffect(e3)
	--control
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetOperation(cm.check)
	c:RegisterEffect(e0)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CUSTOM+m)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(cm.target)
	e4:SetOperation(cm.operation)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.check(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+m,re,r,1-c:GetControler(),1-c:GetControler(),0)
end
function cm.chainfilter(re,tp,cid)
	return not re:GetHandler():IsSetCard(0x6978)
end
function cm.rule(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c,0x1f)>0 and Duel.GetCustomActivityCount(m,1-tp,ACTIVITY_CHAIN)~=0
end
function cm.rule2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(1-tp,tp,nil,c,0x1f)>0 and Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)~=0
end
function cm.tdfilter(c)
	return (c:IsSetCard(0x6978) or c:IsCode(22702055)) and c:IsFaceup() and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local op=0
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	if #g>0 then
		op=Duel.SelectOption(tp,aux.Stringid(m,4),aux.Stringid(m,5))+1
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,5))+2
	end
	if op==1 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	else
		e:SetCategory(0)
	end
	e:SetLabel(op)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		local g=Duel.GetMatchingGroup(cm.tdfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
		if #g>0 then Duel.SendtoDeck(g,nil,2,REASON_EFFECT) end
	elseif e:GetLabel()==2 then
		local p=Duel.GetTurnPlayer()
		for _,ph in pairs({PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}) do
			Duel.SkipPhase(p,ph,RESET_PHASE+PHASE_END,1)
		end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,p)
	end
end