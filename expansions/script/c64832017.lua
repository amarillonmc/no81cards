--星光歌剧 星见纯那Revue
function c64832017.initial_effect(c)
	--summon with 1 tribute
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(64832017,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SUMMON_PROC)
	e0:SetCondition(c64832017.otcon)
	e0:SetOperation(c64832017.otop)
	e0:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(64832017,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetTarget(c64832017.target)
	e2:SetOperation(c64832017.operation)
	c:RegisterEffect(e2)
	--des
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(64832017,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c64832017.descon)
	e3:SetTarget(c64832017.destg)
	e3:SetOperation(c64832017.desop)
	c:RegisterEffect(e3)
	--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(64832017,3))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(TIMING_END_PHASE)
	e4:SetCondition(c64832017.condition)
	e4:SetOperation(c64832017.activate)
	c:RegisterEffect(e4)
	if c64832017.counter==nil then
		c64832017.counter=true
		c64832017[0]=0
		c64832017[1]=0
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e5:SetOperation(c64832017.resetcount)
		Duel.RegisterEffect(e5,0)
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_TO_GRAVE)
		e6:SetOperation(c64832017.addcount)
		Duel.RegisterEffect(e6,0)
	end
end
function c64832017.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c64832017[0]=0
	c64832017[1]=0
end
function c64832017.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local pl=tc:GetPreviousLocation()
		if pl==LOCATION_MZONE then
			local p=tc:GetPreviousControler()
			c64832017[p]=c64832017[p]+1
		end
		tc=eg:GetNext()
	end
end
function c64832017.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c64832017.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c64832017.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c64832017.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,64832017)
	Duel.Draw(tp,c64832017[tp],REASON_EFFECT)
end
function c64832017.otfilter(c)
	return c:IsSetCard(0x6410)
end
function c64832017.otcon(e,c,minc)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(c64832017.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	return c:IsLevelAbove(7) and minc<=1 and Duel.CheckTribute(c,1,1,mg)
end
function c64832017.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c64832017.otfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Duel.SelectTribute(tp,c,1,1,mg)
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_SUMMON+REASON_MATERIAL)
end
function c64832017.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) and Duel.GetTurnPlayer()~=tp
end
function c64832017.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local num=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,num,1-tp,LOCATION_ONFIELD)
end

function c64832017.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c64832017.filter(c)
	return c:IsFacedown()
end
function c64832017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c64832017.filter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c64832017.filter,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
	local tc=g:GetFirst()
	while tc do
		Duel.SetChainLimit(c64832017.limit(tc))
		tc=g:GetNext()
	end
end
function c64832017.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c64832017.operation(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end