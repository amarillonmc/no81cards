--赛法利娅-捷足的羁客-
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290201)
	--①这张卡可以不用解放作召唤
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	c:RegisterEffect(e1)
	--②丢弃1张手卡：从手卡特招1只7星以上怪兽，记述怪则抽1张
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	--③这张卡可以直接攻击
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--泰坦权能「扎格列斯-翻飞之币-」：1回合1次猜拳，平局重猜，赢的玩家抽2张（需自身code flag）
	local t1=Effect.CreateEffect(c)
	t1:SetDescription(aux.Stringid(m,1))
	t1:SetCategory(CATEGORY_DRAW)
	t1:SetType(EFFECT_TYPE_IGNITION)
	t1:SetRange(LOCATION_MZONE)
	t1:SetCountLimit(1,m+100)
	t1:SetCondition(cm.titancon)
	t1:SetTarget(cm.t1tg)
	t1:SetOperation(cm.t1op)
	t1:SetLabel(0)
	c:RegisterEffect(t1)
	--献予「诡计」之诗：升级版——自己是赢的玩家的场合，抽2张
	local t2=t1:Clone()
	t2:SetDescription(aux.Stringid(m,2))
	t2:SetCondition(cm.upcon)
	t2:SetLabel(1)
	c:RegisterEffect(t2)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and aux.IsCodeListed(tc,71290201) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.titancon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)==0
end
function cm.upcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
		and Duel.GetFlagEffect(e:GetHandlerPlayer(),71290201)~=0
end
function cm.t1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function cm.t1op(e,tp,eg,ep,ev,re,r,rp)
	--和对方玩家进行猜拳，平局的场合重新猜拳（参考c10173087：Duel.RockPaperScissors返回赢家玩家编号）
	local res=Duel.RockPaperScissors()
	while res~=0 and res~=1 do
		res=Duel.RockPaperScissors()
	end
	if e:GetLabel()==1 then
		--献予「诡计」之诗：自己是赢的玩家的场合，抽2张
		if res==tp then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	else
		--基础版：赢的玩家抽2张
		Duel.Draw(res,2,REASON_EFFECT)
	end
end
