--Kano 鹿乃
function c75646417.initial_effect(c)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c75646417.sprcon)
	e2:SetOperation(c75646417.sprop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c75646417.atkval)
	c:RegisterEffect(e3)
	--Draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(75646417,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c75646417.con1)
	e4:SetCost(c75646417.cost)
	e4:SetTarget(c75646417.tg)
	e4:SetOperation(c75646417.op)
	c:RegisterEffect(e4)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(75646417,0))
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetCountLimit(2,EFFECT_COUNT_CODE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c75646417.con)
	e6:SetTarget(c75646417.tg1)
	e6:SetOperation(c75646417.op1)
	c:RegisterEffect(e6)
	--
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_TO_GRAVE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c75646417.tg2)
	e7:SetOperation(c75646417.op2)
	c:RegisterEffect(e7)
end
function c75646417.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c75646417.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	return rc~=c and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c75646417.sprfilter(c,type)
	return c:IsFusionSetCard(0x32c4) and c:IsFusionType(type) and c:IsAbleToGraveAsCost()
end
function c75646417.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,TYPE_FUSION)
		and Duel.IsExistingMatchingCard(c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SYNCHRO)
		and Duel.IsExistingMatchingCard(c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,TYPE_XYZ)
		and Duel.IsExistingMatchingCard(c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,nil,TYPE_RITUAL)
end
function c75646417.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_FUSION)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_SYNCHRO)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_XYZ)
	local g4=Duel.SelectMatchingCard(tp,c75646417.sprfilter,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_RITUAL)
	g1:Merge(g2)
	g1:Merge(g3)
	g1:Merge(g4)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c75646417.vfilter(c)
	return c:IsSetCard(0x32c4) and (c:IsLocation(LOCATION_GRAVE+LOCATION_ONFIELD) or c:IsFaceup())
end
function c75646417.atkval(e,c)
	return Duel.GetMatchingGroupCount(c75646417.vfilter,c:GetControler(),LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_REMOVED,0,nil)*400
end
function c75646417.efilter(e,re)
	local loc=Duel.GetChainInfo(re,CHAININFO_TRIGGERING_LOCATION)
	return re:GetOwner()~=e:GetHandler() and re:IsActivated() and loc==LOCATION_MZONE or loc==LOCATION_SZONE 
end
function c75646417.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return g:FilterCount(Card.IsAbleToGraveAsCost,nil)==1 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=2 end
	if g:GetFirst():IsSetCard(0x32c4) then e:SetLabel(1) else e:SetLabel(0) end
	Duel.DisableShuffleCheck()
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646417.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if e:GetLabel()==1 then
		e:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
		if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
		end
	end
end
function c75646417.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	if e:GetLabel()==1 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function c75646417.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetControler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
end
function c75646417.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	end
end
function c75646417.filter(c,e,tp)
	return c:IsSetCard(0x32c4) and c:GetPreviousControler()==tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_COST) and c:IsCanBeEffectTarget(e) and not c:IsForbidden()
end
function c75646417.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c75646417.filter(chkc,e,tp) end
	if chk==0 then return re and re:GetHandler()~=e:GetHandler() and re:IsHasType(0x7f0) and eg:IsExists(c75646417.filter,1,nil,e,tp) end
	local g=eg:Filter(c75646417.filter,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function c75646417.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end