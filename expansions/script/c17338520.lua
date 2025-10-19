--莎缇拉 嫉妒魔女
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337870,17337400)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--win
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(s.winop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.actcon_ign)
	e5:SetCost(s.cost)
	e5:SetTarget(s.tg)
	e5:SetOperation(s.op)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetCondition(s.actcon_quick)
	c:RegisterEffect(e6)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsCanRemoveCounter(tp,1,0,0x9f50,10,REASON_COST) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.RemoveCounter(c:GetControler(),1,0,0x9f50,10,REASON_COST)
end
function s.winop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_SATELLA=0x9f5e
	local p=e:GetHandler():GetSummonPlayer()
	Duel.Win(p,WIN_REASON_SATELLA)
end
function s.actcon_ign(e,tp)
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	return math.abs(lp1-lp2)<7000
end
function s.actcon_quick(e,tp)
	local lp1,lp2=Duel.GetLP(tp),Duel.GetLP(1-tp)
	return math.abs(lp1-lp2)>=7000
end
function s.relfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and (c:IsCode(17337870,17337400) or aux.IsCodeListed(c,17337870) or aux.IsCodeListed(c,17337400))
	and Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,0,1,c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.CheckReleaseGroupEx(tp,s.relfilter,1,REASON_COST,true,nil,tp) and not c:IsPublic() end
	Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,s.relfilter,1,1,REASON_COST,true,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f52,0x5f50) and c:IsCanAddCounter(0x9f50,1)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectMatchingCard(tp,s.ctfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:AddCounter(0x9f50,1)
	end
end