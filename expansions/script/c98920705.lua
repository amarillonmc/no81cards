--次世代兵器 复位机
function c98920705.initial_effect(c)
	c:SetSPSummonOnce(98920705)	--synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98920705.syncon)
	e0:SetTarget(c98920705.syntg)
	e0:SetOperation(c98920705.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920705,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c98920705.tgtg)
	e2:SetOperation(c98920705.tgop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920705,2))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c98920705.descon)
	e3:SetTarget(c98920705.destg)
	e3:SetOperation(c98920705.desop)
	c:RegisterEffect(e3)
end
function c98920705.synfilter(c)
	return (c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_REMOVED)) or (c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
end
function c98920705.hand(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)<=1
end
function c98920705.syncon(e,c,smat)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local mg=Duel.GetMatchingGroup(c98920705.synfilter,c:GetControler(),LOCATION_REMOVED+LOCATION_MZONE,0,nil)
	local res=mg:CheckSubGroup(aux.TRUE,1,99,tp,c,c98920705.hand)
	if smat and smat:IsType(TYPE_TUNER) then
		return Duel.CheckTunerMaterial(c,smat,nil,aux.NonTuner(nil),1,99,mg) end
	return Duel.CheckSynchroMaterial(c,nil,aux.NonTuner(nil),1,99,smat,mg)
end
function c98920705.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,smat)
	local g=nil
	local mg=Duel.GetMatchingGroup(c98920705.synfilter,c:GetControler(),LOCATION_REMOVED+LOCATION_MZONE,0,nil)
	local res=mg:CheckSubGroup(aux.TRUE,1,99,tp,c,c98920705.hand)
	if smat and smat:IsType(TYPE_TUNER) then
		g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,nil,aux.NonTuner(nil),1,99,mg)
	else
		g=Duel.SelectSynchroMaterial(c:GetControler(),c,nil,aux.NonTuner(nil),1,99,smat,mg)
	end
	if g then
		if g:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)>1 then return false end
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c98920705.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	local g2=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	local g1=g:Clone()
	g1:Sub(g2)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)
	Duel.SendtoGrave(g2,REASON_MATERIAL+REASON_SYNCHRO+REASON_RETURN)
	g:DeleteGroup()
	g1:DeleteGroup()
	g2:DeleteGroup()
end
function c98920705.tgfilter(c)
	return c:IsSetCard(0x2) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c98920705.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920705.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c98920705.thfilter(c,e,tp)
	return c:IsCode(68505803) and c:IsAbleToHand()
end
function c98920705.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c98920705.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE)
		and Duel.IsExistingMatchingCard(c98920705.thfilter,tp,LOCATION_DECK,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(98920705,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c98920705.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c98920705.acfilter(c,attr)
	return c:IsAttribute(attr)
end
function c98920705.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=Duel.GetAttackTarget()
	if not bc then return false end
	if tc:IsControler(1-tp) then tc,bc=bc,tc end
	if tc:IsFaceup() and tc:IsSetCard(0x2) and Duel.IsExistingMatchingCard(c98920705.acfilter,tp,LOCATION_GRAVE,0,1,nil,bc:GetAttribute()) then
		e:SetLabelObject(bc)
		return true
	else return false end
end
function c98920705.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,bc,1,0,0)
end
function c98920705.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end