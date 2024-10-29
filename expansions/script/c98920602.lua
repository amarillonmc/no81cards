--DDD 罹实王 觉醒创世神
function c98920602.initial_effect(c)
	c:EnableReviveLimit()
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--special summon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--search1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920602,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,98920602)
	e1:SetCost(c98920602.thcost)
	e1:SetTarget(c98920602.thtg1)
	e1:SetOperation(c98920602.thop1)
	c:RegisterEffect(e1)
	--search2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920602,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,98920602)
	e2:SetCost(c98920602.thcost)
	e2:SetTarget(c98920602.thtg)
	e2:SetOperation(c98920602.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c98920602.sprcon)
	e3:SetTarget(c98920602.sprtg)
	e3:SetOperation(c98920602.sprop)
	c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c98920602.immval)
	c:RegisterEffect(e3)
	--disable spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920602,3))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SPSUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98930602)
	e2:SetTarget(c98920602.target)
	e2:SetOperation(c98920602.operation)
	c:RegisterEffect(e2)
	 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920602,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98940602)
	e3:SetTarget(c98920602.destg)
	e3:SetOperation(c98920602.desop)
	c:RegisterEffect(e3)
end
function c98920602.immval(e,re)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and re:IsActivated() and re:GetActivateLocation()==LOCATION_MZONE
end
function c98920602.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,2,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,2,2,REASON_COST+REASON_DISCARD)
end
function c98920602.thfilter(c)
	return c:IsSetCard(0xae) and not c:IsType(TYPE_MONSTER) and not c:IsCode(10833828,60168186,33814281) and c:IsAbleToHand()
end
function c98920602.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920602.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function c98920602.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920602.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920602.thfilter1(c)
	return c:IsCode(10833828,60168186) and c:IsAbleToHand()
end
function c98920602.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920602.thfilter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920602.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920602.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920602.spcfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xae) and c:IsAbleToGraveAsCost()
end
function c98920602.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c98920602.spcfilter,tp,LOCATION_ONFIELD,0,nil)
	return mg:CheckSubGroup(aux.mzctcheck,3,3,tp) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c98920602.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c98920602.spcfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=mg:SelectSubGroup(tp,aux.mzctcheck,true,3,3,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c98920602.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
function c98920602.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c98920602.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c98920602.cfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c98920602.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c98920602.cfilter,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
function c98920602.desfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c98920602.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c98920602.desfilter(chkc,tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c98920602.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c98920602.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c98920602.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=tc:GetLevel()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)>0 then
--choice
	local g=Duel.GetMatchingGroup(c98920602.tefilter,tp,0,LOCATION_MZONE,nil,lv)
	local b1=atk>0
	local b2=#g>0
	if not b1 and not b2 then return end
	local off=1
	local ops={}
	local opval={}
	if b1 then
		ops[off]=aux.Stringid(98920602,2)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(98920602,3)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(1-tp,table.unpack(ops))+1
	local sel=opval[op]
	if sel==0 then
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	elseif sel==1 then
		local g=Duel.GetMatchingGroup(c98920602.tefilter,1-tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 then
		   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_RELEASE)
		   local sg=g:Select(1-tp,1,1,nil)
		   Duel.HintSelection(sg)
		   Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
		end
	end
--END
	end
end
function c98920602.tefilter(c,lv)
	 return c:IsLevelAbove(lv+1) and c:IsAbleToRemove()
end