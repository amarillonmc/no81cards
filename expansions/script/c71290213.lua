--丹恒·腾荒-腾飞的荒龙-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①双方场上的怪兽被战斗·效果破坏：从手卡·墓地特殊召唤，之后这个回合记述怪兽不会被对方效果取对象
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.descon)
	e1:SetTarget(cm.sstg)
	e1:SetOperation(cm.ssop)
	c:RegisterEffect(e1)
	--②从场上离开：选自己墓地5张其他卡回到卡组，自己抽1张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.rettg)
	e2:SetOperation(cm.retop)
	c:RegisterEffect(e2)
	--泰坦权能「吉奥里亚-磐岩之脊-」：1回合1次，对方把效果发动时无效（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,2))
	t1:SetCategory(CATEGORY_DISABLE)
	t1:SetType(EFFECT_TYPE_QUICK_O)
	t1:SetCode(EVENT_CHAINING)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1)
	t1:SetCondition(cm.negcon)
	t1:SetTarget(cm.negtg)
	t1:SetOperation(cm.negop1)
	c:RegisterEffect(t1)
	--献予「大地」之诗：升级版——那个效果无效并除外
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,3))
	t2:SetCategory(CATEGORY_DISABLE+CATEGORY_REMOVE)
	t2:SetCondition(cm.upcon)
	t2:SetTarget(cm.negtg2)
	t2:SetOperation(cm.negop2)
	c:RegisterEffect(t2)
end
function cm.desfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT))
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.desfilter,1,nil)
end
function cm.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_ATTACK+POS_FACEUP_DEFENSE)
	end
	--那之后：这个回合，自己场上的记述怪兽不会成为对方效果的对象
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.rectg)
	e1:SetValue(cm.tgval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.rectg(e,c)
	return aux.IsCodeListed(c,71290201)
end
function cm.tgval(e,re,rp)
	return rp==1-e:GetHandlerPlayer()
end
function cm.retfilter(c)
	return c:IsAbleToDeck()
end
function cm.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetMatchingGroup(cm.retfilter,tp,LOCATION_GRAVE,0,e:GetHandler()):GetCount()>=5
			and Duel.IsPlayerCanDraw(tp,1)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,5,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.retfilter,tp,LOCATION_GRAVE,0,5,5,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
	Duel.Draw(tp,1,REASON_EFFECT)
end
--泰坦权能：对方把效果发动时无效（基础），升级版除外
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,71290201)==0
		and Duel.IsChainNegatable(ev)
end
function cm.upcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and e:GetHandler():GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,71290201)~=0
		and Duel.IsChainNegatable(ev)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.negtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
end
function cm.negop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
function cm.negop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
