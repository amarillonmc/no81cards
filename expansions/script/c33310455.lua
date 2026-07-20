-- 织巢断缘 空间斩
local s,id=GetID()
local CARD_RYOSHU=33310451
s.VHisc_WEAVENEST=true

function s.initial_effect(c)
	--这个卡名的卡1回合只能发动1张
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.ctcost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	--自己场上有「斩烬织巢之刃 良秀」存在时，盖放的回合也能发动
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCondition(s.setcon)
	c:RegisterEffect(e2)
end

s.listed_names={CARD_RYOSHU}
s.listed_series={SET_WEAVENEST}

--盖放回合发动条件
function s.ryoshufilter(c)
	return c:IsFaceup() and c:IsCode(CARD_RYOSHU)
end

function s.setcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.ryoshufilter,tp,LOCATION_MZONE,0,1,nil)
end

--记录这次决斗中这个卡名的卡发动的次数
function s.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.RegisterFlagEffect(tp,id,0,0,1)
end

--墓地中不同种类的「织巢」连接怪兽
function s.lkfilter(c)
	return c.VHisc_WEAVENEST and c:IsType(TYPE_LINK)
end

function s.getmaxct(tp)
	local g=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)+1
end

--对方场上可以成为对象的怪兽
function s.tgfilter(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeEffectTarget(e)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and s.tgfilter(chkc,e)
	end
	local maxct=s.getmaxct(tp)
	if chk==0 then
		return Duel.IsExistingTarget(s.tgfilter,tp,0,LOCATION_MZONE,1,nil,e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,0,LOCATION_MZONE,1,maxct,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)

	local ct=Duel.GetFlagEffect(tp,id)
	if ct==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	elseif ct>=3 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g==0 then return end

	--1次以上：那些怪兽的效果无效化
	local ng=g:Filter(Card.IsFaceup,nil)
	for tc in aux.Next(ng) do
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)

		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
	end

	local ct=Duel.GetFlagEffect(tp,id)

	--2次：那些怪兽送去墓地
	if ct==2 then
		if #ng>0 then Duel.BreakEffect() end
		Duel.SendtoGrave(g,REASON_EFFECT)

	--3次以上：那些怪兽里侧表示除外
	elseif ct>=3 then
		if #ng>0 then Duel.BreakEffect() end
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
