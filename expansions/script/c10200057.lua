--午夜战栗·四万年的尸气
function c10200057.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--①：双方召唤午夜战栗怪兽的解放减少1只
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,LOCATION_HAND+LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xe25))
	e1:SetValue(c10200057.decval)
	c:RegisterEffect(e1)
	--②：午夜战栗怪兽移动或表示形式变更或变成里侧守备
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10200057,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,10200058)
	e2:SetTarget(c10200057.mvtg)
	e2:SetOperation(c10200057.mvop)
	c:RegisterEffect(e2)
	--③：不死族怪兽移动或表示形式变更时对方全部怪兽变成里侧守备
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10200057,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CUSTOM+0xe25)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,10200057)
	e3:SetCondition(c10200057.poscon)
	e3:SetTarget(c10200057.postg)
	e3:SetOperation(c10200057.posop)
	c:RegisterEffect(e3)
	local e3b=e3:Clone()
	e3b:SetCode(EVENT_CHANGE_POS)
	e3b:SetCondition(c10200057.poscon2)
	c:RegisterEffect(e3b)
end
--①效果
function c10200057.decval(e,c)
	return 1,1
end
--②效果
function c10200057.mvfilter(c,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xe25) then return false end
	--能移动
	local seq=c:GetSequence()
	local b1=false
	if seq<=4 then
		b1=(seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1))
			or (seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1))
	end
	--能表示形式变更
	local b2=c:IsCanChangePosition()
	--能变成里侧守备
	local b3=c:IsCanTurnSet()
	return b1 or b2 or b3
end
function c10200057.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c10200057.mvfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c10200057.mvfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c10200057.mvfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c10200057.mvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local seq=tc:GetSequence()
	--检查各选项可用性
	local b1=false
	local flag=0
	if seq<=4 then
		if seq>0 and Duel.CheckLocation(tp,LOCATION_MZONE,seq-1) then flag=flag|(1<<(seq-1)) end
		if seq<4 and Duel.CheckLocation(tp,LOCATION_MZONE,seq+1) then flag=flag|(1<<(seq+1)) end
		b1=flag~=0
	end
	local b2=tc:IsCanChangePosition()
	local b3=tc:IsCanTurnSet()
	if not b1 and not b2 and not b3 then return end
	--构建选项
	local ops={}
	local opval={}
	if b1 then
		table.insert(ops,aux.Stringid(10200057,2))
		table.insert(opval,1)
	end
	if b2 then
		table.insert(ops,aux.Stringid(10200057,3))
		table.insert(opval,2)
	end
	if b3 then
		table.insert(ops,aux.Stringid(10200057,4))
		table.insert(opval,3)
	end
	local op=opval[Duel.SelectOption(tp,table.unpack(ops))+1]
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local zone=Duel.SelectField(tp,1,LOCATION_MZONE,0,~flag)
		local nseq=math.log(zone,2)
		Duel.MoveSequence(tc,nseq)
	elseif op==2 then
		if tc:IsAttackPos() then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		else
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
	else
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end
--③效果
function c10200057.poscfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsControler(tp)
end
function c10200057.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10200057.poscfilter,1,nil,tp)
end
function c10200057.poscon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp) return c:IsFaceup() and c:IsRace(RACE_ZOMBIE) and c:IsControler(tp) end,1,nil,tp)
end
function c10200057.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c10200057.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10200057.posfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c10200057.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,0,0)
end
function c10200057.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10200057.posfilter,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
