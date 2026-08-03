--卡名待定
local s,id=GetID()
local CARD_PAPER_SHADOW_CIRCUS=33202208

function s.initial_effect(c)
	--①：变成陷阱怪兽特殊召唤，将场上其他1张卡回到手卡
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--相同纵列有对方卡存在时，盖放的回合也能发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e0:SetCondition(s.setcon)
	c:RegisterEffect(e0)

	--②：丢弃自身，从卡组·墓地发动「纸影剧马戏团」
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id)
	--e3:SetCondition(s.fscon)
	e3:SetCost(s.fscost)
	e3:SetTarget(s.fstg)
	e3:SetOperation(s.fsop)
	c:RegisterEffect(e3)
end

function s.columnfilter(c,p)
	return c:IsControler(p)
end
function s.hasopponentcolumn(c)
	local tp=c:GetControler()
	return c:GetColumnGroup():IsExists(s.columnfilter,1,nil,1-tp)
end

--相同纵列的对方卡
function s.colfilter(c,tc)
	return c~=tc
end

function s.setcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:GetColumnGroup():IsExists(s.colfilter,1,nil,c)
end

--①：可以回到手卡的其他卡
function s.thfilter(c,sc)
	return c~=sc and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_TRAP,
				2000,1500,4,RACE_DRAGON,ATTRIBUTE_LIGHT)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c)
	end

	local cg=c:GetColumnGroup():Filter(s.colfilter,nil,tp)
	for tc in aux.Next(cg) do
		tc:CreateEffectRelation(e)
	end
	cg:KeepAlive()
	e:SetLabelObject(cg)

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
	if #cg>0 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,cg,#cg,1-tp,LOCATION_ONFIELD)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=e:GetLabelObject()
	if not c:IsRelateToEffect(e) then
		if cg then cg:DeleteGroup() end
		return
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
		if cg then cg:DeleteGroup() end
		return
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT+TYPE_TRAP,
		2000,1500,4,RACE_DRAGON,ATTRIBUTE_LIGHT) then
		if cg then cg:DeleteGroup() end
		return
	end

	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)

	--选这张卡以外的场上1张卡回到手卡
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end

	--发动时同纵列有对方卡的场合，可以将那些卡的效果无效
	if cg then
		local ng=cg:Filter(Card.IsRelateToEffect,nil,e)
		if #ng>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			for tc in aux.Next(ng) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)

				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)

				local e2=e1:Clone()
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e2)
			end
		end
		cg:DeleteGroup()
	end
end

--②：对方回合
function s.fscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsTurnPlayer(1-tp)
end

function s.fscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

--可以发动的「纸影剧马戏团」
function s.fsfilter(c,tp)
	return c:IsCode(CARD_PAPER_SHADOW_CIRCUS) and not c:IsForbidden()
		and c:CheckUniqueOnField(tp) and c:GetActivateEffect()
end

function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.fsfilter),
			tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp)
	end
end

function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.fsfilter),
		tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local te=tc:GetActivateEffect()
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc then
		Duel.SendtoGrave(fc,REASON_RULE)
		Duel.BreakEffect()
	end
	Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
	te:UseCountLimit(tp,1,true)
	local tep=tc:GetControler()
	local cost=te:GetCost()
	if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
	Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
end