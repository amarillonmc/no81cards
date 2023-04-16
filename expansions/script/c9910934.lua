--匪魔杀人狂 西卡里奥
function c9910934.initial_effect(c)
	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c9910934.syncon)
	e0:SetTarget(c9910934.syntg)
	e0:SetOperation(c9910934.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,9910934)
	e1:SetCondition(c9910934.damcon)
	e1:SetTarget(c9910934.damtg)
	e1:SetOperation(c9910934.damop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910935)
	e2:SetCost(c9910934.descost)
	e2:SetTarget(c9910934.destg)
	e2:SetOperation(c9910934.desop)
	c:RegisterEffect(e2)
end
function c9910934.synfilter(c)
	return (c:IsSetCard(0x3954) and c:IsType(TYPE_MONSTER) and c:IsCanBeSynchroMaterial() and c:IsLocation(LOCATION_HAND)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
end
function c9910934.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local mg=Duel.GetMatchingGroup(c9910934.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1,99,smat,mg)
end
function c9910934.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(c9910934.synfilter,c:GetControler(),LOCATION_HAND+LOCATION_MZONE,0,nil)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,nil,aux.NonTuner(Card.IsRace,RACE_FIEND),1,99,smat,mg)
	end
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c9910934.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c9910934.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c9910934.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0x3954) end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3954)
	local dam=g:GetClassCount(Card.GetCode)*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c9910934.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3954)
	local dam=g:GetClassCount(Card.GetCode)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c9910934.cfilter(c)
	return c:IsSetCard(0x3954) and c:IsAbleToGraveAsCost()
end
function c9910934.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910934.cfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9910934.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c9910934.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910934.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsDestructable()
		and Duel.IsExistingMatchingCard(c9910934.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,rc) end
	local g=Duel.GetMatchingGroup(c9910934.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,rc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c9910934.desop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) and Duel.Destroy(rc,REASON_EFFECT)~=0 then
		local g=Duel.GetMatchingGroup(c9910934.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
	end
end
