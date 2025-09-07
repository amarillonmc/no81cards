--炽融快速集结
local s,id=GetID()
function s.initial_effect(c)
	-- 效果①: 从卡组·墓地检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	-- 效果②: 墓地除外发动
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+1)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
end

function s.filter1(c,tp)
	return c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,c)
end
function s.filter2(c,fc)
	return aux.IsCodeListed(fc,c:GetCode()) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,cg:GetFirst())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- 效果②: 目标（结束阶段送墓）
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

-- 效果②: 操作（设置结束阶段效果）
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.tgcon2)
	e1:SetOperation(s.tgop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.eqfilter2(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_EQUIP) and not c:IsForbidden()
end

function s.eqfilter3(c)
	return c:IsSetCard(0x612) and c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.tgcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.eqfilter2,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(s.eqfilter3,tp,LOCATION_MZONE,0,1,nil) 
end

function s.tgop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(s.eqfilter3,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	Duel.BreakEffect()
	local eqc=Duel.SelectMatchingCard(tp,s.eqfilter2,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local eqtc=Duel.SelectMatchingCard(tp,s.eqfilter3,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
		if eqtc and eqc then
		Duel.Equip(tp,eqc,eqtc) 
		end
	end
end
