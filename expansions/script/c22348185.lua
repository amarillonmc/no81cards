--遥 远 之 民 回 响 幻 歌
local m=22348185
local cm=_G["c"..m]
function cm.initial_effect(c)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c22348185.sprcon)
	c:RegisterEffect(e0)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22348185,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22348185.xyzcon0)
	e1:SetTarget(c22348185.tgtg)
	e1:SetOperation(c22348185.tgop)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c22348185.xyzcon)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c22348185.eftg)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)
	--effect gain
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetValue(1)
	e7:SetCondition(c22348185.tgcon2)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_UPDATE_ATTACK)
	e8:SetValue(1000)
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
function c22348185.xyzcon0(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_XYZ)
end
function c22348185.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_XYZ)
end
function c22348185.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c22348185.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsContains(c)
end
function c22348185.regop(e,tp,eg,ep,ev,re,r,rp)
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
function c22348185.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	local tp=c:GetControler()
	local bbb=seq+10*tp
	local ct=c:GetFlagEffectLabel(bbb)
	return ct
end
function c22348185.tgcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<4
end
function c22348185.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()==4
end
function c22348185.eftg(e,c)
	local seq=c:GetSequence()
	return c:IsType(TYPE_EFFECT) and c:IsOriginalSetCard(0x706)
		and seq<5 and e:GetHandler():GetSequence()<seq
end
function c22348185.tgfilter(c)
	return c:IsSetCard(0x706) and c:IsAbleToDeck()
end
function c22348185.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(c22348185.tgfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c22348185.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=Duel.SelectMatchingCard(tp,c22348185.tgfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	if tg:GetCount()>0 then
		Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local g=Duel.GetOperatedGroup()
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if ct>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end











