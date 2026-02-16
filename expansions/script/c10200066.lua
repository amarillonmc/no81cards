-- 午夜战栗·天顶巨星
function c10200066.initial_effect(c)
	c:EnableReviveLimit()
	-- 融合素材设定
	aux.AddFusionProcMix(c,true,true,10200046,c10200066.matfilter)
	-- 接触融合
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10200066.spcon)
	e1:SetTarget(c10200066.sptg)
	e1:SetOperation(c10200066.spop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	-- 效果1
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200066,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,{10200066,1})
	e2:SetTarget(c10200066.thtg)
	e2:SetOperation(c10200066.thop)
	c:RegisterEffect(e2)
	-- 效果2
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200066,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+0xe25)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{10200066,2})
	e3:SetCondition(c10200066.poscon)
	e3:SetTarget(c10200066.postg)
	e3:SetOperation(c10200066.posop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_CHANGE_POS)
	e3b:SetCondition(c10200066.poscon2)
	c:RegisterEffect(e3b)
	-- 效果3
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10200066,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,{10200066,3})
	e4:SetCost(c10200066.tdcost)
	e4:SetTarget(c10200066.tdtg)
	e4:SetOperation(c10200066.tdop)
	c:RegisterEffect(e4)
end
-- 1
function c10200066.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0xe25) and c:IsType(TYPE_MONSTER,fc,sumtype,tp)
end
-- 2
function c10200066.spfilter1(c,tp)
	return c:IsCode(10200046) and c:IsFaceup() and c:IsAbleToGraveAsCost() and c:IsControler(tp)
end
function c10200066.spfilter2(c,tp)
	return c:IsSetCard(0xe25) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and c:IsControler(tp)
end
function c10200066.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g1=Duel.GetMatchingGroup(c10200066.spfilter1,tp,LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c10200066.spfilter2,tp,LOCATION_MZONE,0,nil,tp)
	return #g1>0 and #g2>1
end
function c10200066.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g1=Duel.GetMatchingGroup(c10200066.spfilter1,tp,LOCATION_MZONE,0,nil,tp)
	local g2=Duel.GetMatchingGroup(c10200066.spfilter2,tp,LOCATION_MZONE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=g1:Select(tp,1,1,nil)
	g2:Sub(sg1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if sg1:GetCount()<2 then return false end
	sg1:KeepAlive()
	e:SetLabelObject(sg1)
	return true
end
function c10200066.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
-- 3
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
-- 4
function c10200066.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()<5 then return false end
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function c10200066.poscon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetSequence()<5 then return false end
	return eg:IsExists(function(c,tp) return c:IsFaceup() and c:IsControler(tp) end,1,nil,tp)
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
-- 5
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
function c10200066.tdfilter(c,sg)
	if not c:IsSetCard(0xe25) or not c:IsType(TYPE_MONSTER) or not c:IsAbleToDeck() then return false end
	return not sg:IsExists(Card.IsCode,1,nil,c:GetCode())
end
function c10200066.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10200066.tdchkfilter),tp,LOCATION_GRAVE,0,nil)
	if #g<4 or not g:IsExists(Card.IsCode,1,nil,10200046) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:FilterSelect(tp,Card.IsCode,1,1,nil,10200046)
	for i=1,3 do
		local ng=g:Filter(c10200066.tdfilter,nil,sg)
		if #ng==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tc=ng:Select(tp,1,1,nil):GetFirst()
		sg:AddCard(tc)
	end
	if #sg==4 then
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
