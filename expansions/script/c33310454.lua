-- 织巢斩缚 天杀
--织巢斩缚 天杀
local s,id=GetID()
local CARD_RYOSHU=33310451
s.VHisc_WEAVENEST=true

function s.initial_effect(c)
	--卡名的卡1回合只能发动1张
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.tgtg)
	e1:SetOperation(s.tgop)
	c:RegisterEffect(e1)

	--②：结束阶段破坏「织巢」怪兽并抽卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
end

s.listed_names={CARD_RYOSHU}
s.listed_series={SET_WEAVENEST}

--①：可以从卡组送去墓地的「斩烬织巢之刃 良秀」
function s.tgfilter(c)
	return c:IsCode(CARD_RYOSHU) and c:IsAbleToGrave()
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	end
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then return end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

--②：自己场上的「斩烬织巢之刃 良秀」
function s.ryoshufilter(c)
	return c:IsFaceup() and c:IsCode(CARD_RYOSHU)
end

function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.ryoshufilter,tp,LOCATION_MZONE,0,1,nil)
end

--自己场上·额外卡组中可以破坏的「织巢」怪兽
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end

--自己墓地的「织巢」连接怪兽
function s.linkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_LINK)
end

function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsPlayerCanDraw(tp,1)
			and Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,1,nil)
	end

	local ct=1
	if Duel.IsExistingMatchingCard(s.linkfilter,tp,LOCATION_GRAVE,0,1,nil) then
		ct=2
	end

	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,ct,tp,LOCATION_MZONE+LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	if #g==0 then return end

	local ct=1
	if Duel.IsExistingMatchingCard(s.linkfilter,tp,LOCATION_GRAVE,0,1,nil) then
		ct=math.min(2,#g)
	end

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,ct,nil)
	if #dg>0 and Duel.Destroy(dg,REASON_EFFECT)>0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end