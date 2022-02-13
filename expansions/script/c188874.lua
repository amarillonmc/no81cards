local m=188874
local cm=_G["c"..m]
cm.name="星魅伴龙"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.mvtg)
	e1:SetOperation(cm.mvop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e)return e:GetHandler():GetSequence()==0 or e:GetHandler():GetSequence()==4 end)
	e2:SetValue(TYPE_TUNER)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_LEVEL)
	e3:SetCondition(function(e)return e:GetHandler():GetSequence()==2 end)
	e3:SetValue(3)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCondition(function(e)return e:GetHandler():GetSequence()==1 or e:GetHandler():GetSequence()==3 end)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
function cm.mvfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xca2)
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(g:GetFirst(),nseq)
	end
end
