--人理之星 查理曼
function c22023560.initial_effect(c)
	aux.AddCodeList(c,22023340)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xff1),3)
	c:EnableReviveLimit()
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_COST)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCost(c22023560.sumcon)
	c:RegisterEffect(e0)
	--base atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c22023560.atkcon1)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(2000)
	e2:SetCondition(c22023560.atkcon2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetValue(3000)
	e3:SetCondition(c22023560.atkcon3)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetValue(4000)
	e4:SetCondition(c22023560.atkcon4)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetValue(5000)
	e5:SetCondition(c22023560.atkcon5)
	c:RegisterEffect(e5)
	local e6=e1:Clone()
	e6:SetValue(6000)
	e6:SetCondition(c22023560.atkcon6)
	c:RegisterEffect(e6)
	local e7=e1:Clone()
	e7:SetValue(7000)
	e7:SetCondition(c22023560.atkcon7)
	c:RegisterEffect(e7)
	local e8=e1:Clone()
	e8:SetValue(8000)
	e8:SetCondition(c22023560.atkcon8)
	c:RegisterEffect(e8)
	local e9=e1:Clone()
	e9:SetValue(9000)
	e9:SetCondition(c22023560.atkcon9)
	c:RegisterEffect(e9)
	local e10=e1:Clone()
	e10:SetValue(10000)
	e10:SetCondition(c22023560.atkcon10)
	c:RegisterEffect(e10)
	local e11=e1:Clone()
	e11:SetValue(11000)
	e11:SetCondition(c22023560.atkcon11)
	c:RegisterEffect(e11)
	local e12=e1:Clone()
	e12:SetValue(12000)
	e12:SetCondition(c22023560.atkcon12)
	c:RegisterEffect(e12)
	local e13=e1:Clone()
	e13:SetValue(13000)
	e13:SetCondition(c22023560.atkcon13)
	c:RegisterEffect(e13)
	--Negate
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(22023560,0))
	e14:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_COIN)
	e14:SetType(EFFECT_TYPE_QUICK_O)
	e14:SetCode(EVENT_CHAINING)
	e14:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1,22023560)
	e14:SetCondition(c22023560.condition)
	e14:SetTarget(c22023560.cointg)
	e14:SetOperation(c22023560.coinop)
	c:RegisterEffect(e14)
	--Negate ere
	local e15=Effect.CreateEffect(c)
	e15:SetDescription(aux.Stringid(22023560,1))
	e15:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_COIN)
	e15:SetType(EFFECT_TYPE_QUICK_O)
	e15:SetCode(EVENT_CHAINING)
	e15:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e15:SetRange(LOCATION_GRAVE)
	e15:SetCountLimit(1,22023560)
	e15:SetCondition(c22023560.erecon)
	e15:SetCost(c22023560.erecost)
	e15:SetTarget(c22023560.cointg)
	e15:SetOperation(c22023560.coinop)
	c:RegisterEffect(e15)
	--
	--if not c22023560.global_flag then
		--c22023560.global_flag=true
		--local ge1=Effect.CreateEffect(c)
		--ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		--ge1:SetCode(EVENT_CHAIN_SOLVED)
		--ge1:SetOperation(c22023560.regop)
		--Duel.RegisterEffect(ge1,0)
	--end
end
c22023560.toss_coin=true
--function c22023560.regop(e,tp,eg,ep,ev,re,r,rp)
	--local rc=re:GetHandler()
	--if not rc:IsCode(22023340) then return end
	--local p,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	--Duel.RegisterFlagEffect(p,22023560,0,0,0,tc:GetCode())
--end
function c22023560.sumcon(e,c,tp,st)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)>=3
end
function c22023560.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==1
end
function c22023560.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==2
end
function c22023560.atkcon3(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==3
end
function c22023560.atkcon4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==4
end
function c22023560.atkcon5(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==5
end
function c22023560.atkcon6(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==6
end
function c22023560.atkcon7(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==7
end
function c22023560.atkcon8(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==8
end
function c22023560.atkcon9(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==9
end
function c22023560.atkcon10(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==10
end
function c22023560.atkcon11(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==11
end
function c22023560.atkcon12(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)==12
end
function c22023560.atkcon13(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandler():GetControler(),22023340)>12
end
function c22023560.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainNegatable(ev)
end
function c22023560.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
end
function c22023560.coinop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	local c1,c2,c3=Duel.TossCoin(tp,3)
	if c1+c2+c3>=1 and Duel.IsChainDisablable(ev) and rc:IsRelateToEffect(re) then
		Duel.NegateEffect(ev)
	end
	if c1+c2+c3>=2 and sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	if c1+c2+c3==3 then
		Duel.SelectOption(tp,aux.Stringid(22023560,2))
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.RegisterFlagEffect(tp,22023340,0,0,0)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
		Duel.Hint(HINT_CARD,0,22023340)
	end
end
function c22023560.erecon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and Duel.IsChainNegatable(ev) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22023560.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end