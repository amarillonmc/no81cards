-- 织巢断缘 空间斩
local s,id=GetID()
local CARD_RYOSHU=33310451
s.VHisc_WEAVENEST=true

function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
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
	return  c:IsCanBeEffectTarget(e) --and c:IsType(TYPE_MONSTER) 
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		return  chkc:IsLocation(LOCATION_ONFIELD) and s.tgfilter(chkc,e) -- and chkc:IsControler(1-tp) 
	end
	local c=e:GetHandler()
	local maxct=s.getmaxct(tp)
	if chk==0 then
		return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,e)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,maxct,c,e)
	local ct=Duel.GetFlagEffect(tp,id)
	if ct>1 then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
	end
	if ct>2 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	end
	if ct>3 then
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
	end
	if ct>4 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,0,0)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if #g==0 then return end

	local ng=g:Filter(Card.IsFaceup,nil)
	local ct=Duel.GetFlagEffect(tp,id)
	
	aux.SelectFromOptions(tp,{true,aux.Stringid(id,1)})
	for tc in aux.Next(ng) do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		--1次以上：怪兽的攻守变为0
			if tc:IsType(TYPE_MONSTER) then
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_SET_ATTACK_FINAL)
				e0:SetValue(0)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e0)
				local e1=e0:Clone()
				e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
				tc:RegisterEffect(e1)
			end
			--2次以上：那些卡的效果无效化
			if ct>1 then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
				local e3=e2:Clone()
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetValue(RESET_TURN_SET)
				tc:RegisterEffect(e3)
			end
		end
	end
	
	--3次以上：适用解场效果
	if ct>=3 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		if #ng>0 then Duel.BreakEffect() end
		local sc=0--记录选择哪项解场效果
		if ct ==3 then
			sc=aux.SelectFromOptions(tp,{true,aux.Stringid(id,3)})
		elseif ct==4  then  
			sc=aux.SelectFromOptions(tp,{true,aux.Stringid(id,3)},{true,aux.Stringid(id,4)})
		elseif ct>=5 then
			sc=aux.SelectFromOptions(tp,{true,aux.Stringid(id,3)},{true,aux.Stringid(id,4)},{true,aux.Stringid(id,5)})
		end
		if sc==1 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif sc==2 then
			Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		elseif sc==3 then
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
