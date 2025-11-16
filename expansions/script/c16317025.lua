--魔法国度 威彻尔尼
function c16317025.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--summon proc
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16317025,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c16317025.otcon)
	e1:SetTarget(c16317025.ottg)
	e1:SetOperation(c16317025.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e11=e1:Clone()
	e11:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e11)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1,16317025)
	e2:SetCost(c16317025.cost)
	e2:SetCondition(c16317025.drcon)
	e2:SetTarget(c16317025.drtg)
	e2:SetOperation(c16317025.drop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,16317025+1)
	e3:SetCost(c16317025.cost)
	e3:SetTarget(c16317025.target)
	e3:SetOperation(c16317025.activate)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(16317025,ACTIVITY_SPSUMMON,c16317025.counterfilter)
end
function c16317025.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function c16317025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(16317025,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c16317025.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c16317025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end
function c16317025.disfilter(c,tp)
	return c:IsAttribute(0xf) and c:IsDiscardable(0x40)
		and Duel.IsExistingMatchingCard(c16317025.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetAttribute())
end
function c16317025.thfilter(c,attr)
	return c:IsSetCard(0x5dc7) and not c:IsAttribute(attr) and c:IsAbleToHand()
end
function c16317025.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16317025.disfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c16317025.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,c16317025.disfilter,1,1,REASON_EFFECT+REASON_DISCARD)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		local attr=tc:GetAttribute()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c16317025.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,attr)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c16317025.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsSummonPlayer(tp) and tc:IsSummonType(SUMMON_TYPE_ADVANCE)
		and tc:IsFaceup() and tc:IsAttribute(0xf)
end
function c16317025.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c16317025.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c16317025.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsAttribute(0xf)
end
function c16317025.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc<=2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16317025.rmfilter,tp,LOCATION_GRAVE,0,2,nil)
end
function c16317025.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2 and c:IsAttribute(0xf)
end
function c16317025.otop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c16317025.rmfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	c:SetMaterial(nil)
end