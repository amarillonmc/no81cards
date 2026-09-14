--源于黑影 螺旋
local s,id,o=GetID()
function s.initial_effect(c)
	-- ① 尽可能支付2000LP，增加本家○效果使用次数（最多10次）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(s.rmcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.rmop)
	c:RegisterEffect(e1)

	-- ② 墓地：本家让自己LP脱离0的场合，除外自身，从卡组盖放1张本家魔法
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SSET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+65820000)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.setcon)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- ① cost：尽可能支付2000LP；支付后LP为0则变4000并触发EVENT_CUSTOM
function s.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=Duel.GetLP(tp)
	if lp>=2000 then
		Duel.PayLPCost(tp,2000,REASON_COST)
	else
		Duel.PayLPCost(tp,lp,REASON_COST)
	end
	if Duel.GetLP(tp)<=0 then
		Duel.SetLP(tp,4000)
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+65820000,e,REASON_COST,tp,tp,4000)
	end
end

-- ① target：使用次数未满10次
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,65820099)<10 end
	Duel.SetTargetPlayer(tp)
end

-- ① operation：使用次数+1，并刷新 client hint 显示
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local count=Duel.GetFlagEffect(p,65820099)
	if count>=10 then return end
	for i=0,10 do
		Duel.ResetFlagEffect(p,EFFECT_FLAG_EFFECT+65820000+i)
	end
	Duel.RegisterFlagEffect(p,65820099,0,0,1)
	local count1=math.max(Duel.GetFlagEffect(p,65820099),0)
	local te=Effect.CreateEffect(e:GetHandler())
	te:SetDescription(aux.Stringid(65820000,count1))
	te:SetType(EFFECT_TYPE_FIELD)
	te:SetCode(EFFECT_FLAG_EFFECT+65820000+count1)
	te:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	te:SetTargetRange(1,0)
	Duel.RegisterEffect(te,p)
end

-- ② 触发条件：本家卡让自己LP脱离0
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0x3a32)
end

-- ② cost：除外自身
function s.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end

-- ② filter：本家魔法且可盖放
function s.setfilter(c)
	return c:IsSetCard(0x3a32) and c:IsType(TYPE_SPELL) and c:IsSSetable()
end

-- ② target
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SSET,nil,1,tp,LOCATION_DECK)
end

-- ② operation：选1张本家魔法在自己场上盖放
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SSet(tp,g)
	end
end