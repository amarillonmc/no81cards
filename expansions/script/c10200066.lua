--午夜战栗·天顶巨星
function c10200066.initial_effect(c)
	c:EnableReviveLimit()
	--融合素材设定
	aux.AddFusionProcMix(c,true,true,10200046,c10200066.matfilter)
	--接触融合
	aux.AddContactFusionProcedure(c,c10200066.contactfilter,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST,c10200066.contactop)
	--特殊召唤条件
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10200066.splimit)
	c:RegisterEffect(e1)
	--①：检索午夜战栗卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200066,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10200066)
	e2:SetTarget(c10200066.thtg)
	e2:SetOperation(c10200066.thop)
	c:RegisterEffect(e2)
	--②：额外怪兽区域存在，移动或表示形式变更时变里侧守备
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200066,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+0xe25)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,10200067)
	e3:SetCondition(c10200066.poscon)
	e3:SetTarget(c10200066.postg)
	e3:SetOperation(c10200066.posop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_CHANGE_POS)
	e3b:SetCondition(c10200066.poscon2)
	c:RegisterEffect(e3b)
	--③：送去墓地时除外回卡组
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200066,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,10200068)
	e4:SetCost(c10200066.tdcost)
	e4:SetTarget(c10200066.tdtg)
	e4:SetOperation(c10200066.tdop)
	c:RegisterEffect(e4)
end
--融合素材过滤
function c10200066.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end
--接触融合
function c10200066.contactfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe25) and c:IsAbleToGraveAsCost()
end
function c10200066.contactop(g,tp)
	return #g>=2 and g:IsExists(Card.IsCode,1,nil,10200046)
end
--特殊召唤条件
function c10200066.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
--①效果
function c10200066.thfilter(c)
	return c:IsSetCard(0xe25) and c:IsAbleToHand()
end
function c10200066.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200066.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10200066.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10200066.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--②效果
function c10200066.poscfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp)
end
function c10200066.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()<5 then return false end
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c10200066.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()<5 then return false end
	return eg:IsExists(c10200066.poscfilter,1,nil,tp)
end
function c10200066.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10200066.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200066.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c10200066.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c10200066.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c10200066.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
--③效果
function c10200066.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemove() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
function c10200066.tdchkfilter(c)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c10200066.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c10200066.tdchkfilter,tp,LOCATION_GRAVE,0,nil)
		if #g<4 then return false end
		if not g:IsExists(Card.IsCode,1,nil,10200046) then return false end
		local codes={}
		local count=0
		local tc=g:GetFirst()
		while tc do
			local code=tc:GetCode()
			if not codes[code] then
				codes[code]=true
				count=count+1
			end
			tc=g:GetNext()
		end
		return count>=4
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,4,tp,LOCATION_GRAVE)
end
function c10200066.tdfilter(c,selected)
	if not c:IsSetCard(0xe25) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToDeck() then return false end
	local tc=selected:GetFirst()
	while tc do
		if tc:GetCode()==c:GetCode() then return false end
		tc=selected:GetNext()
	end
	return true
end
function c10200066.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10200066.tdchkfilter),tp,LOCATION_GRAVE,0,nil)
	if #g<4 then return end
	local g1=g:Filter(Card.IsCode,nil,10200046)
	if #g1==0 then return end
	local selected=Group.CreateGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg1=g1:Select(tp,1,1,nil)
	selected:Merge(sg1)
	for i=1,3 do
		local ng=g:Filter(c10200066.tdfilter,nil,selected)
		if #ng==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=ng:Select(tp,1,1,nil):GetFirst()
		selected:AddCard(tc)
	end
	if #selected==4 then
		Duel.SendtoDeck(selected,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
