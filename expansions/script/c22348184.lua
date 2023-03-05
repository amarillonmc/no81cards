--遥 远 之 民 回 响 幻 歌
local m=22348184
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c22348184.sprcon)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348184,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348184.xyzcon0)
	e1:SetTarget(c22348184.tgtg)
	e1:SetOperation(c22348184.tgop)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348184.xyzcon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c22348184.eftg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--effect gain
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_INACTIVATE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(1)
	e6:SetCondition(c22348184.tgcon1)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_DISEFFECT)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	e7:SetCondition(c22348184.tgcon2)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(500)
	local e9=e3:Clone()
	e9:SetLabelObject(e6)
	c:RegisterEffect(e9)
	local e10=e3:Clone()
	e10:SetLabelObject(e7)
	c:RegisterEffect(e10)
	local e11=e3:Clone()
	e11:SetLabelObject(e8)
	c:RegisterEffect(e11)
end
function c22348184.xyzcon0(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_XYZ)
end
function c22348184.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function c22348184.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c22348184.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function c22348184.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tp=c:GetControler()
	local aaa=seq+10*tp
	local flag=c:GetFlagEffectLabel(aaa)
	 if flag then
		 c:SetFlagEffectLabel(aaa,flag+1)
	 else
		 c:RegisterFlagEffect(aaa,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,1)
	 end
end
function c22348184.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tp=c:GetControler()
	local bbb=seq+10*tp
	local ct=c:GetFlagEffectLabel(bbb)
	return ct
end
function c22348184.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<4
end
function c22348184.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348184.eftg(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and c:IsOriginalSetCard(0x706) 
		and seq<5 and e:GetHandler():GetSequence()<seq
end
function c22348184.tgfilter(c)
	return c:IsSetCard(0x706)
end
function c22348184.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(c22348184.tgfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348184.tgop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c22348184.tgfilter,1,1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end









